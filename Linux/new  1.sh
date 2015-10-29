#
# Log dos walmart_tvi
#
echo "*** TEMP/walmart_tvi (arquivos): $PATH_PORTAL/htdocs/portal/shellscript/walmart_tvi/*.log"
find $PATH_PORTAL/htdocs/portal/shellscript/walmart_tvi/*.log -maxdepth 1 -type f -daystart ! -mtime -7 -exec rm {} \;

echo "*** TEMP/walmart_tvi (arquivos): $PATH_PORTAL/htdocs/portal/shellscript/walmart_tvi/*.log"
find $PATH_PORTAL/htdocs/portal/shellscript/walmart_tvi/*.zip -maxdepth 1 -type f -daystart ! -mtime -7 -exec rm {} \;

