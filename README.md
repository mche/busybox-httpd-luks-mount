# Монтирование LUKS раздела через busybox httpd

### Клонирование

`git clone https://github.com/mche/busybox-httpd-luks-mount.git --depth=1`

### Запуск httpd

`sudo busybox httpd -p 8080 -h /home/guest/busybox-httpd-luks-mount/`

###   Создание раздела с паролем в первом слоте

```
$ sudo cryptsetup -s 512 luksFormat <device|file>
$ sudo cryptsetup luksOpen /home/guest/luksTest.img myTest
$ sudo mkfs.ext4 -m 0  /dev/mapper/myTest
$ sudo cryptsetup luksClose /dev/mapper/myTest
```

### Сохранение части ключа где-то в сети

` head -c 2048 /dev/urandom | base64 -w 0 | less`

### Добавление сборного ключа

```
$ head -c 512 /dev/urandom | base64 -w 0 
$ curl -vv -L 'http://127.0.0.1:8080/cgi-bin/key.php?<from prev line>' > enc.key
$ sudo cryptsetup luksAddKey luksTest.img enc.key
$ shred enc.key
```
