# Монтирование LUKS раздела через busybox httpd

### Клонирование

```
$ sudo git clone --depth=1 https://github.com/mche/busybox-httpd-luks-mount.git foo-folder
```

### (Необязательно) Свои символические ссылки на точки запросов

As root
```
# cd foo-folder/cgi-bin
# mv mount.sh jh4355k0398-mount.sh
# ln -s jh4355k0398-mount.sh mount.php
# mv key.sh jh4355k0398-key.sh
# ln -s jh4355k0398-key.sh key.php
```

### Запуск httpd

```
$ sudo busybox httpd -p 8080 -h /home/guest/busybox-httpd-luks-mount/
```

###   LUKS раздел с паролем в первом слоте

```
$ sudo cryptsetup -s 512 luksFormat <device|file>
$ sudo cryptsetup luksOpen /home/guest/luksTest.img myTest
$ sudo mkfs.ext4 -m 0  /dev/mapper/myTest
$ sudo cryptsetup luksClose /dev/mapper/myTest
```

### Сохранение первой части ключа файлом где-то в сети

```
$ head -c 2048 /dev/urandom | base64 -w 0 > enc1.key
```

Вписать в *mount.sh* и *key.sh* место сохраненной первой части ключа, например:

`export key1URL=https://gist.githubusercontent.com/foo/3894cedc3997e3acd97470c63bf9ba4a/raw/enc1.key`

### Вторая часть ключа также генерируется и передается в урл, получаем сборный ключ

Генерация не обязательно длинная, копипастим случайную строку и она стыкуется с первой частью е единый составной ключ
```
$ head -c 512 /dev/urandom | base64 -w 0
$ curl -vv -L 'http://127.0.0.1:8080/cgi-bin/key.php?<вторая часть ключа>' > enc.key
```

### Добавление составного ключа в LUKS устройство

```
$ sudo cryptsetup luksAddKey luksTest.img enc.key
```


### Монтирование со второй частью ключа с другого компьютера, если комп был перезагружен


```
$ curl -s -L 'http://хост:8080/cgi-bin/mount.php?<вторая часть ключа>
```

Т.е. доверенные пользователи компании тычут в браузере этот урл.

### Если комп с дисками утрачен ликвидируем файл в сети первой  части ключа и не делаем http-монтирований