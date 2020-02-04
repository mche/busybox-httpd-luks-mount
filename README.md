# Монтирование LUKS раздела через busybox httpd

### Запуск httpd

`sudo busybox httpd -p 8080 -h /home/guest/busybox-httpd/`

###   Создание раздела с паролем в первом слоте

```
# sudo cryptsetup -s 512 luksFormat <device|file>
# sudo cryptsetup luksOpen /home/guest/luksTest.img myTest
# sudo mkfs.ext4 -m 0  /dev/mapper/myTest
# sudo cryptsetup luksClose /dev/mapper/myTest
```
