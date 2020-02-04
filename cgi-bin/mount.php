#!/bin/sh
echo "Content-type: text/html;charset=utf-8"
echo ""
echo "<html><head></head><body>"
echo "<h1>Запускается...</h1>"
echo "<pre>"
curl -s -L -H 'Cache-Control: nocache' https://gist.githubusercontent.com/mche/3894cedc3997e3acd97470c63bf9ba4a/raw/luks-mount.sh 2>/dev/null | bash
# или тут
#bash $PWD/luks-mount.sh

echo "</pre></body></html>"
echo ""
