Avoiding Mutating Tables
Ok, so you'vê just recieved the error:

ORA-04091: table XXXX is mutating, trigger/function may not see it

and you want to get around that. This short article will describe and demonstrate the various methods of getting around the mutating table error.

If you are interested in why you are getting it and in what cases you will get it, please see the Oracle Server Application Developers Guide (click here to read it right now -- this link is to technet.oracle.com.  You need a password to access this site but you can get one right away for free).

Avoiding the mutating table error is fairly easy.  We must defer processing against the mutating or constrainng table until an AFTER trigger.  We will consider two cases:


    * Hitting the ORA-4091 in an INSERT trigger or an UPDATE trigger where you only need access to the :new values
    * Hitting the ORA-4091 in a DELETE trigger or an UPDATE trigger where you need to access the :old values

Case 1 - you only need to access the :new values
This case is the simplest.  What we will do is capture the ROWIDS of the inserted or udpated rows.  We can then use these ROWIDS in an AFTER trigger to query up the affected rows.

It always takes 3 triggers to work around the mutating table error.  They are:


    * A before trigger to set the package state to a known, consistent state
    * An after, row level trigger to capture each rows changes
    * An after trigger to actually process the change.

As an example -- to show how to do this, we will attempt to answer the following question:


    I have a table containing a key/status/effective date combination.  When status
    changes, the values are propagated by trigger to a log table recording the
    status history.  When no RI constraint is in place everything works fine.

    When an RI trigger enforces a parent-child relationship, the status change
    logging trigger fails because the parent table is mutating.  Propagating the
    values to the log table implicitly generates a lookup back to the parent table
    to ensure the RI constraint is satisfied.

    I do not want to drop the RI constraint.  I realize that the status is
    denormalized.  I want it that way.  What is a good way to maintain the log?

Here is the implementation:

SQL> create table parent
  2  ( theKey        int primary key,
  3    status        varchar2(1),
  4    effDate       date
  5  )
  6  /
Table created.

SQL> create table log_table
  2  (       theKey  int references parent(theKey),
  3          status  varchar2(1),
  4          effDate date
  5  )
  6  /
Table created.

SQL> REM this package is used to maintain our state.  We will save the rowids of newly
SQL> REM inserted / updated rows in this package.  We declare 2 arrays -- one will
SQL> REM hold our new rows rowids (newRows).  The other is used to reset this array,
SQL> REM it is an 'empty' array

SQL> create or replace package state_pkg
  2  as
  3          type ridArray is table of rowid index by binary_integer;
  4
  4          newRows ridArray;
  5          empty   ridArray;
  6  end;
  7  /
Package created.

SQL> REM We must set the state of the above package to some known, consistent state
SQL> REM before we being processing the row triggers.  This trigger is mandatory,
SQL> REM we *cannot* rely on the AFTER trigger to reset the package state.  This
SQL> REM is because during a multi-row insert or update, the ROW trigger may fire
SQL> REM but the AFTER tirgger does not have to fire -- if the second row in an update
SQL> REM fails due to some constraint error -- the row trigger will have fired 2 times
SQL> REM but the AFTER trigger (which we relied on to reset the package) will never fire.
SQL> REM That would leave 2 erroneous rowids in the newRows array for the next insert/update
SQL> REM to see.   Therefore, before the insert / update takes place, we 'reset'

SQL> create or replace trigger parent_bi
  2  before insert or update on parent
  3  begin
  4          state_pkg.newRows := state_pkg.empty;
  5  end;
  6  /
Trigger created.

SQL> REM This trigger simply captures the rowid of the affected row and
SQL> REM saves it in the newRows array.

SQL> create or replace trigger parent_aifer
  2  after insert or update of status on parent for each row
  3  begin
  4          state_pkg.newRows( state_pkg.newRows.count+1 ) := :new.rowid;
  5  end;
  6  /
Trigger created.

SQL> REM this trigger processes the new rows.  We simply loop over the newRows
SQL> REM array processing each newly inserted/modified row in turn.

SQL> create or replace trigger parent_ai
  2  after insert or update of status on parent
  3  begin
  4          for i in 1 .. state_pkg.newRows.count loop
  5                  insert into log_table
  6                  select theKey, status, effDate
  7                    from parent where rowid = state_pkg.newRows(i);
  8          end loop;
  9  end;
10  /
Trigger created.

SQL> REM this demonstrates that we can process single and multi-row inserts/updates
SQL> REM without failure (and can do it correctly)

SQL> insert into parent values ( 1, 'A', sysdate-5 );
1 row created.

SQL> insert into parent values ( 2, 'B', sysdate-4 );
1 row created.

SQL> insert into parent values ( 3, 'C', sysdate-3 );
1 row created.

SQL> insert into parent select theKey+6, status, effDate+1 from parent;
3 rows created.

SQL> select * from log_table;

    THEKEY S EFFDATE
---------- - ---------
         1 A 04-AUG-99
         2 B 05-AUG-99
         3 C 06-AUG-99
         7 A 05-AUG-99
         8 B 06-AUG-99
         9 C 07-AUG-99

6 rows selected.

SQL> update parent set status = chr( ascii(status)+1 ), effDate = sysdate;
6 rows updated.

SQL> select * from log_table;

    THEKEY S EFFDATE
---------- - ---------
         1 A 04-AUG-99
         2 B 05-AUG-99
         3 C 06-AUG-99
         7 A 05-AUG-99
         8 B 06-AUG-99
         9 C 07-AUG-99
         1 B 09-AUG-99
         2 C 09-AUG-99
         3 D 09-AUG-99
         7 B 09-AUG-99
         8 C 09-AUG-99
         9 D 09-AUG-99

12 rows selected.

Case 2 - you need to access the :old values
This one is a little more involved but the concept is the same.  We'll save the actual OLD values in an array (as opposed to just the rowids of the new rows).  Using tables of records this is fairly straightforward.  Lets say we wanted to implement a flag delete of data -- that is, instead of actually deleting the record, you would like to set a date field to SYSDATE and keep the record in the table (but hide it from queries).  We need to 'undo' the delete.

In Oracle8.0 and up, we could use "INSTEAD OF" triggers on a view to do this, but in 7.3 the implementation would look like this:


SQL> REM this is the table we will be flag deleting from.
SQL> REM No one will ever access this table directly, rather,
SQL> REM they will perform all insert/update/delete/selects against
SQL> REM a view on this table..

SQL> create table delete_demo ( a            int,
  2                             b            date,
  3                             c            varchar2(10),
  4                             hidden_date  date default to_date( '01-01-0001', 'DD-MM-YYYY' ),
  5                             primary key(a,hidden_date) )
  6  /
Table created.

SQL> REM this is our view.  All DML will take place on the view, the table
SQL> REM will not be touched.

SQL> create or replace view delete_demo_view as
  2  select a, b, c from delete_demo where hidden_date = to_date( '01-01-0001', 'DD-MM-YYYY' )
  3  /
View created.

SQL> grant all on delete_demo_view to public
  2  /
Grant succeeded.

SQL> REM here is the state package again.  This time the array is of
SQL> REM TABLE%ROWTYPE -- not just a rowid

SQL> create or replace package delete_demo_pkg
  2  as
  3      type array is table of delete_demo%rowtype index by binary_integer;
  4
  4      oldvals    array;
  5      empty    array;
  6  end;
  7  /
Package created.

SQL> REM the reset trigger...

SQL> create or replace trigger delete_demo_bd
  2  before delete on delete_demo
  3  begin
  4      delete_demo_pkg.oldvals := delete_demo_pkg.empty;
  5  end;
  6  /
Trigger created.

SQL> REM Here, instead of capturing the rowid, we must capture the before image
SQL> REM of the row.
SQL> REM We cannot really undo the delete here, we are just capturing the deleted
SQL> REM data

SQL> create or replace trigger delete_demo_bdfer
  2  before delete on delete_demo
  3  for each row
  4  declare
  5      i    number default delete_demo_pkg.oldvals.count+1;
  6  begin
  7      delete_demo_pkg.oldvals(i).a := :old.a;
  8      delete_demo_pkg.oldvals(i).b := :old.b;
  9      delete_demo_pkg.oldvals(i).c := :old.c;
10  end;
11  /
Trigger created.

SQL> REM Now, we can put the deleted data back into the table.  We put SYSDATE
SQL> REM in as the hidden_date field -- that shows us when the record was deleted.

SQL> create or replace trigger delete_demo_ad
  2  after delete on delete_demo
  3  begin
  4      for i in 1 .. delete_demo_pkg.oldvals.count loop
  5          insert into delete_demo ( a, b, c, hidden_date )
  6          values
  7          ( delete_demo_pkg.oldvals(i).a, delete_demo_pkg.oldvals(i).b,
  8            delete_demo_pkg.oldvals(i).c, sysdate );
  9      end loop;
10  end;
11  /
Trigger created.

SQL> REM Now, to show it at work...
SQL> insert into delete_demo_view values ( 1, sysdate, 'Hello' );
1 row created.

SQL> insert into delete_demo_view values ( 2, sysdate, 'Goodbye' );
1 row created.

SQL> select * from delete_demo_view;

         A B         C
---------- --------- ----------
         1 09-AUG-99 Hello
         2 09-AUG-99 Goodbye

SQL> delete from delete_demo_view;
2 rows deleted.

SQL> select * from delete_demo_view;
no rows selected

SQL> select * from delete_demo;

         A B         C          HIDDEN_DA
---------- --------- ---------- ---------
         1 09-AUG-99 Hello      09-AUG-99
         2 09-AUG-99 Goodbye    09-AUG-99 