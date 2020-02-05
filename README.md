¡ ¡ ¡ ALL GLORY TO GLORIA ! ! !

# Монтирование LUKS раздела через busybox httpd

Задача: монтировать шифрованные разделы и запускать в них программы без сохранения LUKS-ключей на самом сервере.

Команду на монтирование подавать через браузер.

### Клонирование этой репы

```
$ sudo git clone --depth=1 https://github.com/mche/busybox-httpd-luks-mount.git foo-folder
```

### Конфигурация в config.sh

См. комментарии в [cgi-bin/config.sh](https://github.com/mche/busybox-httpd-luks-mount/tree/master/cgi-bin/config.sh)


### Запуск httpd

```
$ sudo busybox httpd -p 8080 -h /path/to/foo-folder
```

Увы, пока без заморочек с рутовскими привилегиями, может переделаю.

###  (Если еще не создан) LUKS раздел

Пример файлового устройства:
```
$ dd if=/dev/zero of=luksTest.img bs=1M count=100
$ sudo cryptsetup -s 512 luksFormat luksTest.img
$ sudo cryptsetup luksOpen luksTest.img myTest
$ sudo mkfs.ext4 -m 0  /dev/mapper/myTest
$ sudo cryptsetup luksClose /dev/mapper/myTest
```

### Алгоритм комбинации/дешифрования ключа

В [cgi-bin/luks-key.sh](https://github.com/mche/busybox-httpd-luks-mount/tree/master/cgi-bin/luks-key.sh) представлен пример наложения двух случайных строк частей в единый ключ.
Тут открываются широкие возможности для творчества масс во всевозможных алгоритмах.

Далее процедуры ключа для встроенного алгоритма.

### Сохранение первой части ключа файлом где-то в сети/облаке

```
$ head -c 2048 /dev/urandom | base64 -w 0 > enc1.key
```

Вписать в [cgi-bin/config.sh](https://github.com/mche/busybox-httpd-luks-mount/tree/master/cgi-bin/config.sh) место сохраненной первой части ключа, например:

`export key1URL=https://gist.githubusercontent.com/foo/3894cedc3997e3acd97470c63bf9ba4a/raw/enc1.key`

### Вторая часть ключа

Также генерируется случайная строка и она передается с УРЛами запросов. Генерация не обязательно длинная
```
$ head -c 512 /dev/urandom | base64 -w 0
```

Копипастим строку в УРЛы запросов.

### Ключ в LUKS

Стыкуем две части в единый составной ключ

```
$ curl  'http://127.0.0.1:8080/cgi-bin/key.sh?<вторая часть ключа>' > enc.key
```

Ключ готов для внедрения в LUKS.


### Добавление ключа в LUKS устройство

```
$ sudo cryptsetup luksAddKey luksTest.img enc.key
$ shred enc.key
```
Полученный файл ключа успешно внедрен и не будет использоваться. Всякий раз будут стыковаться две части из строки запроса и сетевого файла.


### Монтирование

С другого компьютера, если сервер был выключен/перезагружен

```
$ curl  'http://хост:8080/cgi-bin/mount.sh?<вторая часть ключа>'
```

Таким образом, доверенные пользователи знают этот URL и тычут в браузере когда надо.

Если комп с LUKS навсегда  утрачен ликвидируем файл в сети первой  части ключа и не делаем http-монтирований.

### (Необязательно) Послемонтирование (post-mount.sh)

Если прописать дополнительные команды в [cgi-bin/post-mount.sh](https://github.com/mche/busybox-httpd-luks-mount/tree/master/cgi-bin/post-mount.sh), то после успешного монтирования они выполнятся.

### (Необязательно) Свои символические ссылки на точки запросов


```
$ sudo su
# cd foo-folder/cgi-bin
# mv mount.sh jh4355k0398-mount.sh
# ln -s jh4355k0398-mount.sh mount.php
# mv key.sh jh4355k0398-key.sh
# ln -s jh4355k0398-key.sh key.php
```

Соответственно изменятся УРЛы http-запросов:

`http://хост:8080/cgi-bin/key.php?<вторая часть ключа>` и `http://хост:8080/cgi-bin/mount.php?<вторая часть ключа>`

ВНИМАНИЕ! Только два файла mount.sh и key.sh исполняемые для точек http-запросов. Неисполняемые файлы будут 404 не найдены.

# Доброго всем и успехов!