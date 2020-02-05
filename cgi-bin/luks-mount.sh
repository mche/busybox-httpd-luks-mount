#!/usr/bin/env bash

echo -n "Открытие > > > > > "
if [ -z $baseURL ]; then
  bash $PWD/luks-key.sh | cryptsetup -v luksOpen $luksDEV $mapName -d - 2>&1;
else
  curl -s -L -H 'Cache-Control: nocache' $baseURL/luks-key.sh 2>/dev/null | bash | cryptsetup -v luksOpen $luksDEV $mapName -d - 2>&1;
fi

if [ $? -ne 0 ]; then
  #echo " . . . . . FAIL"
  exit;
fi


mount /dev/mapper/$mapName $mountPoint 2>&1

if [ $? -ne 0 ]; then
  exit;
fi

echo -n "Монтирование > > > > > ";
mount | grep $mapName;

