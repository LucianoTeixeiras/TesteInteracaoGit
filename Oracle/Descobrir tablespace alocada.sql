--Dica: Descobrir a(s) tablespace(s) alocada(s) para um banco Oracle

SELECT DISTINCT
       T.OWNER,
       T.TABLESPACE_NAME,
       TS.STATUS,
       DF.FILE_NAME,
       DF.BYTES,
       DF.STATUS
  FROM DBA_TABLES T
 INNER JOIN DBA_TABLESPACES TS
    ON TS.TABLESPACE_NAME = T.TABLESPACE_NAME
 INNER JOIN DBA_DATA_FILES DF
    ON DF.TABLESPACE_NAME = TS.TABLESPACE_NAME
 WHERE T.TABLESPACE_NAME IS NOT NULL
   AND UPPER(T.OWNER) = 'PRODUCAO'
 ORDER BY T.OWNER;

---------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------



select l.SESSION_ID,
o.owner,
o.object_type,
o.object_name,
l.oracle_username,
l.os_user_name
FROM gv$locked_object l,
dba_objects o
WHERE l.object_id = o.object_id
ORDER by l.SESSION_ID,o.object_name;
