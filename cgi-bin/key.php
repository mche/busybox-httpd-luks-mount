#!/bin/sh
#
# Запрос сборного ключа
# 

echo "Content-type: application/octet-stream"
echo ""
curl -s -L -H 'Cache-Control: nocache' https://gist.githubusercontent.com/mche/3894cedc3997e3acd97470c63bf9ba4a/raw/luks-key.sh 2>/dev/null | bash
# или тут
#bash $PWD/luks-key.sh


