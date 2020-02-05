#!/usr/bin/env bash

source $PWD/config.sh

echo "Content-type: text/html;charset=utf-8"
echo ""
echo "<html><head></head><body>"
echo "<h1>Запускается...</h1>"
echo "<pre>"

if [ -z $baseURL ]; then
  bash $PWD/luks-mount.sh;
else
  curl -s -L -H 'Cache-Control: nocache' $baseURL/luks-mount.sh 2>/dev/null | bash;
fi

echo "</pre></body></html>"
echo ""
