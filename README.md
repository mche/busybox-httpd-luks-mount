¡ ¡ ¡ ALL GLORY TO GLORIA ! ! !

# Монтирование LUKS раздела через busybox httpd

Будет использоваться составной ключ.

### Клонирование этой репы

```
$ sudo git clone --depth=1 https://github.com/mche/busybox-httpd-luks-mount.git foo-folder
```

### Конфигурация в config.sh

См. комментарии в ***cgi-bin/config.sh***

### (Необязательно) Свои символические ссылки на точки запросов

As root
```
# cd foo-folder/cgi-bin
# mv mount.sh jh4355k0398-mount.sh
# ln -s jh4355k0398-mount.sh mount.php
# mv key.sh jh4355k0398-key.sh
# ln -s jh4355k0398-key.sh key.php
```

ВНИМАНИЕ! Только два файла mount.sh и key.sh исполняемые для точек УРЛ.

### Запуск httpd

```
$ sudo busybox httpd -p 8080 -h /path/to/foo-folder
```

###  (Если еще не создан) LUKS раздел

```
$ sudo cryptsetup -s 512 luksFormat <device|file>
$ sudo cryptsetup luksOpen /home/guest/luksTest.img myTest
$ sudo mkfs.ext4 -m 0  /dev/mapper/myTest
$ sudo cryptsetup luksClose /dev/mapper/myTest
```

### Алгоритм комбинации/дешифрования ключа

В ***cgi-bin/luks-key.sh*** представлен пример наложения двух случайных строк частей в единый ключ.
Тут открываются широкие возможности для творчества масс во всевозможных алгоритмах.

Далее процедуры ключа для встроенного алгоритма.

### Сохранение первой части ключа файлом где-то в сети

```
$ head -c 2048 /dev/urandom | base64 -w 0 > enc1.key
```

Вписать в [cgi-bin/config.sh](https://github.com/mche/busybox-httpd-luks-mount/tree/master/cgi-bin/config.sh) место сохраненной первой части ключа, например:

`export key1URL=https://gist.githubusercontent.com/foo/3894cedc3997e3acd97470c63bf9ba4a/raw/enc1.key`

### Вторая часть ключа также генерируется и передается в УРЛ, получаем сборный ключ

Генерация не обязательно длинная, копипастим случайную строку и она стыкуется с первой частью в единый составной ключ
```
$ head -c 512 /dev/urandom | base64 -w 0
$ curl  'http://127.0.0.1:8080/cgi-bin/key.php?<вторая часть ключа>' > enc.key
```


### Добавление составного ключа в LUKS устройство

```
$ sudo cryptsetup luksAddKey luksTest.img enc.key
$ shred enc.key
```
Полученный файл ключа не будет использоваться, а всякий раз будут стыковаться две части из строки запроса и сетевого файла.


### Монтирование со второй частью ключа с другого компьютера, если комп был выключен/перезагружен

```
$ curl   'http://хост:8080/cgi-bin/mount.php?<вторая часть ключа>
```

Таким образом, доверенные пользователи знают этот URL и тычут в браузере когда надо.

Если комп с LUKS навсегда  утрачен ликвидируем файл в сети первой  части ключа и не делаем http-монтирований.

### (Необязательно) Послемонтирование (post-mount.sh)

Если прописать дополнительные команды в [cgi-bin/post-mount.sh](https://github.com/mche/busybox-httpd-luks-mount/tree/master/cgi-bin/post-mount.sh), то после успешного монтирования они выполнятся.

# Доброго всем и успехов!