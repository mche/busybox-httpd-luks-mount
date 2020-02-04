#!/bin/sh

bash $PWD/luks-key.sh | cryptsetup luksOpen /home/guest/luksTest.img myTest -d - 2>&1

if [ $? -ne 0 ]; then
  exit;
fi

echo "Открытие - OK"
mount /dev/mapper/myTest /mnt/iso 2>&1

if [ $? -ne 0 ]; then
  exit;
fi

echo "Монтирование - OK"
mount | grep myTest

