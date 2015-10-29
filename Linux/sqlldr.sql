LOAD DATA INFILE '/data0/htdocs/portal/ibope_2/bkp/TMP.MOVIBOPE20150718043021.txt' INSERT INTO TABLE TMP.SQLLOADER_IBOPE FIELDS TERMINATED BY '†' TRAILING NULLCOLS




sqlplus prod2/prod2@ora_lx1 @/usr/local/apache/htdocs/portal/ibope_2/prc_insere_dados.sql > /usr/local/apache/htdocs/portal/ibope_2/prc_insere_dados.log

sqlldr userid=ibope/ibope@ora1 @/usr/local/apache/htdocs/portal/ibope_2/TMP.MOVIBOPE20150718043021.txt

sqlldr userid=ibope/ibope@ora1 control=TMP.MOVIBOPE20150718043021.txt log=loader.log