Dica rápida de como copiar arquivos mantendo sua estrutura de diretórios e sub-diretórios para outro local. 

Exemplo: tenho o diretório /home/fabio/projeto1/css/plugins/joaninha.css e quero copiar o arquivo para /home/fabio/projeto2 sem precisar de criar os diretórios css e plugins. O comando seria: 

$ cd /home/fabio/projeto1
$ cp --parents css/plugins/joaninha.css ../projeto2 

E pronto! O arquivo e sua estrutura de diretórios estará onde deveria estar: 

$ ls -lh /home/fabio/projeto2/css/plugins/ 

A "mágica" foi proporcionada pelo parâmetro "--parents" do cp. 