#!/usr/bin/env bash
#
# Запрос сборного ключа
#

source $PWD/config.sh

echo "Content-type: application/octet-stream"
echo ""
if [ -z $baseURL ]; then
  bash $PWD/luks-key.sh;
else
  curl -s -L -H 'Cache-Control: nocache' $baseURL/luks-key.sh 2>/dev/null | bash;
fi

