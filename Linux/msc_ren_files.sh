#!/bin/bash

clear

cd $1

#Verifica se o diret�rio informado existe
if ! [ -d $1 ] 
then
	exit
fi

#diret�rio de backup
dir_backup="backup"

#Texto a ser substituido
old=$DBUSER_CEA
new=$DBUSER_VEST

#Verifica se ja existe o diret�rio de backup
if ! [ -d $dir_backup ] 
then
	mkdir $dir_backup
fi

#Tratamento dos arquivos
for file_old in *$old* 
do 
	#backup do original
	cp $file_old $dir_backup/$file_old

	for file_new in $(echo $file_old | sed "s/$old/$new/g"); 
	do 
		#Renomeia o arquivo
		mv $file_old $file_new; 

		#Troca o conte�do interno do arquivo
		sed -i "s/$old/$new/g"

	done; 
done
