#!/usr/bin/env bash
#
# ключ из двух частей
#
# первая часть сохранена в файл где-то в сети
# head -c 2048 /dev/urandom | base64 -w 0 | less
a1=( $(curl -L $key1URL 2>/dev/null | base64 -d | xxd -c 5 -p) )
# вторая часть передается в урл http://host/cgi-bin/key.php?...  http://host/cgi-bin/mount.php?...
# head -c 512 /dev/urandom | base64 -w 0 
a2=( $(echo -n $QUERY_STRING | base64 -d | xxd -c 5 -p) )

#printf "%x ^ %x = %x\n" $(( 0x${a1[c]} )) $(( 0x${a2[c]} )) $(( 0x${a1[c]} ^ 0x${a2[c]} ));
for (( c=0; c < ${#a1[@]}; c++ )); do 
  printf "%x" $(( 0x${a1[c]} ^ 0x${a2[c]} ));
done | xxd -r -p
