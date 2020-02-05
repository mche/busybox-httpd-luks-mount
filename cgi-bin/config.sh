
# Если нужно убрать подальше в сеть luks-key.sh и luks-mount.sh, тогда локально их удалить и раскомментировать и указать baseURL
export baseURL=https://raw.githubusercontent.com/mche/busybox-httpd-luks-mount/master/cgi-bin

# Укаазать, где сохранена первая часть ключа
export key1URL=https://gist.githubusercontent.com/mche/3894cedc3997e3acd97470c63bf9ba4a/raw/key.txt