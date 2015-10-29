#!/bin/sh

#
# Inicialização ================================================================
#

#Variáveis Limpa Controle.txt para destravar entrada de imagens!!!
DIR="/data_media/antigohome/"
DIAS="1"
CMD="find $DIR -name "controle.txt" -type d -mtime +$DIAS"

#Log
ARQ="/home/desenv/bkp_controle_old.log"

#Procedimentos de Limpeza
$CMD &> $ARQ 2> /dev/null
AUX=$(cat $ARQ | wc -l)
if [ $AUX = 0 ]; then
        echo "Arquivos: Nenhum Controle.txt com mais de 1 dia para exclusao" | mail -s "Exclusao de Controles.txt antigos" suporte.ti@shoppingbrasil.com.br < bkp_controle_old.log
else
   $CMD | xargs rm -rf
        echo "Arquivos: Controles.txt com mais de 1 dia excluidos" | mail -s "Exclusao de Controles.txt antigos" suporte.ti@shoppingbrasil.com.br < bkp_controle_old.log
   rm -rf $ARQ
fi
