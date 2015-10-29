--Select para descobrir os objetos desabilitados no Oracle

SELECT CONS.INDEX_NAME,
       CONS.CONSTRAINT_NAME,
       CONS.CONSTRAINT_TYPE,
       COLS.TABLE_NAME,
       COLS.COLUMN_NAME,
       COLS.POSITION,
       CONS.STATUS,
       CONS.OWNER
  FROM ALL_CONSTRAINTS CONS
 INNER JOIN ALL_CONS_COLUMNS COLS
    ON CONS.CONSTRAINT_NAME = COLS.CONSTRAINT_NAME
   AND CONS.OWNER = COLS.OWNER
 WHERE UPPER(CONS.STATUS) != 'ENABLED'
   AND UPPER(CONS.OWNER) = 'SEU_OWNER'
   -- A LINHA ACIMA PODE SER ELIMINADA PARA
   -- QUE TODOS OS OBJETOS INVÁLIDOS SEJAM
   -- LISTADOS, INDEPENDENTE DO OWNER
  ORDER BY COLS.TABLE_NAME, COLS.POSITION;
