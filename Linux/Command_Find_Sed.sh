find . | xargs grep -s -a -i DBUSER_CEA | uniq


find . | xargs grep -s -a -i DBUSER_CEA | uniq > bkp_usuario.txt		#fazer na pasta um nivel acima

find . -iname '*.php' | xargs sed -i 's/DBUSER_CEA/DBUSER_VEST/g'

find . -iname '*.php' | xargs sed -i 's/DBPASS_CEA/DBPASS_VEST/g'

find . | xargs grep -s -a -i DBPASS_CEA | uniq > bkp_senha.txt			#fazer na pasta um nivel acima

find . -iname '*.sql' | xargs sed -i 's/DBUSER_CEA/DBUSER_VEST/g'

find . -iname '*.sql' | xargs sed -i 's/DBPASS_CEA/DBPASS_VEST/g'


find . | xargs grep -s -a -i ï»¿ | uniq

find . -iname '*.CSV' | xargs sed -i 's/ï»¿//g'


find . | xargs grep -s -a -i rcpt to | uniq > bkp_usuario.txt