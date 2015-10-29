#Variáveis Limpa Controle.txt para destravar entrada de imagens!!!
DIR="/data_media/antigohome/"
DIAS="1"
CMD="find $DIR -name "controle.txt" -type d -mtime +$DIAS"
 
#Log
ARQ="/data_media/antigohome/bkp_controle_old.log"
 
#Variaveis envia e-mails
EMAIL_FROM="luciano.silva@shoppingbrasil.com.br"  
EMAIL_TO="luciano.silva@shoppingbrasil.com.br"
SERVIDOR_SMTP="smtp.cedilrs.com.br:587"
SENHA=***********
ASSUNTO="$1"
MENSAGEM=$2

#Procedimentos de Limpeza
$CMD &> $ARQ 2> /dev/null
AUX=$(cat $ARQ | wc -l)
if [ $AUX = 0 ]; then
   sendEmail -f $EMAIL_FROM -t $EMAIL_TO -u "Exclusao de Controles.txt antigos" -m "Nenhum Back up com mais de 1 dia para exclusao" $ANEXO -s $SERVIDOR_SMTP -xu $EMAIL_FROM -xp $SENHA
else
   $CMD | xargs rm -rf
   sendEmail -f $EMAIL_FROM -t $EMAIL_TO -u "Exclusao de Controles.txt antigos" -m "Controles.txt com mais de 1 dia excluidos" $ANEXO -s $SERVIDOR_SMTP -xu $EMAIL_FROM -xp $SENHA
   rm -rf $ARQ
fi