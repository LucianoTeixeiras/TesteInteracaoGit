--Select para descobrir os objetos lockados no Oracle

SELECT c.owner,
       c.object_name,
       c.object_type,
       b.SID,
       b.serial#,
       b.status,
       b.osuser,
       b.machine
  FROM v$locked_object a, v$session b, dba_objects c
 WHERE b.SID = a.session_id
   AND a.object_id = c.object_id
   AND upper(c.owner) = 'SEU_OWNER_EM_MAIUSCULO'
 ORDER BY c.owner, c.object_name;
