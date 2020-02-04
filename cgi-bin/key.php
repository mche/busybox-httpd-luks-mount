#!/bin/sh
#
# Запрос сборного ключа
# 

#
# Добавление сборного ключа в раздел
# head -c 512 /dev/urandom | base64 -w 0 
# curl -vv -L 'http://127.0.0.1:8080/cgi-bin/key.php?<from prev line>' > enc5.key
# sudo cryptsetup luksAddKey <device|file> enc5.key
# sudo cryptsetup luksAddKey luksTest.img enc5.key
# shred enc5.key
#
echo "Content-type: application/octet-stream"
echo ""
curl -s -L -H 'Cache-Control: nocache' https://gist.githubusercontent.com/mche/3894cedc3997e3acd97470c63bf9ba4a/raw/luks-key.sh 2>/dev/null | bash
# или тут
#bash $PWD/luks-key.sh


