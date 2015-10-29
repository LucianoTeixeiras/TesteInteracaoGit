Dica r�pida de como copiar arquivos mantendo sua estrutura de diret�rios e sub-diret�rios para outro local. 

Exemplo: tenho o diret�rio /home/fabio/projeto1/css/plugins/joaninha.css e quero copiar o arquivo para /home/fabio/projeto2 sem precisar de criar os diret�rios css e plugins. O comando seria: 

$ cd /home/fabio/projeto1
$ cp --parents css/plugins/joaninha.css ../projeto2 

E pronto! O arquivo e sua estrutura de diret�rios estar� onde deveria estar: 

$ ls -lh /home/fabio/projeto2/css/plugins/ 

A "m�gica" foi proporcionada pelo par�metro "--parents" do cp. 