# Конфиг 
# LUKS устройство
#export luksDEV=/dev/md0
export luksDEV=/home/guest/luksTest.img

# Map to name /dev/mapper/myTest
export mapName=myTest

# Точка монтирования
# export mountPoint=/home
export mountPoint=/mnt/iso

# Если нужно убрать подальше в сеть luks-key.sh и luks-mount.sh, тогда локально их удалить и раскомментировать и указать baseURL для них
#export baseURL=https://raw.githubusercontent.com/mche/busybox-httpd-luks-mount/master/cgi-bin

# Указать, где сохранена первая часть ключа
export key1URL=https://gist.githubusercontent.com/mche/3894cedc3997e3acd97470c63bf9ba4a/raw/key.txt
