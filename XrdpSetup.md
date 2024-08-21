# Установка и настройка xrdp

## Шаг первый - Установка пакетов

Установите необходимые пакеты с помощью следующих команд:

```sh
sudo apt install xrdp
sudo apt install xorgxrdp
sudo apt install ufw
```

## Шаг второй - Настройка службы XRDP

Добавьте пользователя xrdp в группу ssl-cert и настройте службу xrdp:

```sh
sudo adduser xrdp ssl-cert
sudo systemctl enable xrdp
sudo systemctl restart xrdp
```

Настройте брандмауэр для разрешения подключений к xrdp:

```sh
sudo ufw allow from 192.168.2.0/24 to any port 3389
sudo ufw allow 3389
```

## Шаг третий - Редактирование startwm.sh

Внесите изменения в файл startwm.sh:

1. Откройте файл startwm.sh для редактирования.
2. Добавьте следующие строки перед строкой test -x /etc/X11/Xsession && exec /etc/X11/Xsession:

```sh
unset DBUS_SESSION_BUS_ADDRESS
unset XDG_RUNTIME_DIR
```

## ВАЖНО! Если клиент - KRDC, обязательно отключить RemoteFX(Улучшенное представление) в параметрах хоста

## Важные команды для работы с xrdp

```sh
sudo systemctl status xrdp
ip a
```

## Проверка логгов сервера

```sh
sudo tail -f /var/log/xrdp.log
sudo tail -f /var/log/xrdp-sesman.log
```
