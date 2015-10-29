--Dica: Descobrir objetos inválidos no Oracle

SELECT owner, object_type, object_name, status
  FROM dba_objects
 WHERE status != 'VALID'
   AND upper(owner) = 'SEU_OWNER_EM_MAIUSCULO'
 ORDER BY owner, object_type, object_name;
