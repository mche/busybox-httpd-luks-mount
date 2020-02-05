#!/usr/bin/env bash
# Это неисполняемый файл, не точка УРЛ
# Этот файл можно ( и желательно ) перенести в сеть и назначить в config.sh
# соотвествующую переменную baseURL

echo -n "Открытие > > > > > "
if [ -z $baseURL ]; then
  bash $PWD/luks-key.sh | cryptsetup -v luksOpen $luksDEV $mapName -d - 2>&1;
else
  curl -s -L -H 'Cache-Control: nocache' $baseURL/luks-key.sh 2>/dev/null | bash | cryptsetup -v luksOpen $luksDEV $mapName -d - 2>&1;
fi

if [ $? -ne 0 ]; then
  exit;
fi


mount /dev/mapper/$mapName $mountPoint 2>&1

if [ $? -ne 0 ]; then
  exit;
fi

echo -n "Монтирование > > > > > ";
mount | grep $mapName;

if [ -f $PWD/post-mount.sh ]; then
  echo "Послемонтирование . . .";
  bash $PWD/post-mount.sh;
fi
