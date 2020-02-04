#!/bin/sh
#
# Запрос сборного ключа
# 
export baseURL=https://gist.githubusercontent.com/mche/3894cedc3997e3acd97470c63bf9ba4a/raw
export key1URL=https://gist.githubusercontent.com/mche/3894cedc3997e3acd97470c63bf9ba4a/raw/key.txt
echo "Content-type: application/octet-stream"
echo ""
curl -s -L -H 'Cache-Control: nocache' $baseURL/luks-key.sh 2>/dev/null | bash
# или тут
#bash $PWD/luks-key.sh


