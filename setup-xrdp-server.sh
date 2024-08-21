#!/bin/bash
# Шаг первый - Установка пакетов
echo "Установка необходимых пакетов..."
sudo apt update
sudo apt install -y xrdp xorgxrdp ufw

# Шаг второй - Настройка службы XRDP
echo "Настройка службы XRDP..."
sudo adduser xrdp ssl-cert
sudo systemctl enable xrdp
sudo systemctl restart xrdp

# Настройка брандмауэра
echo "Настройка брандмауэра..."
sudo ufw allow from 192.168.2.0/24 to any port 3389
sudo ufw allow 3389

# Шаг третий - Редактирование startwm.sh
echo "Редактирование файла startwm.sh..."
STARTWM_FILE="/etc/xrdp/startwm.sh"

# Создаем резервную копию файла
sudo cp $STARTWM_FILE $STARTWM_FILE.bak

# Вносим изменения в файл
sudo sed -i '/test -x \/etc\/X11\/Xsession && exec \/etc\/X11\/Xsession/i unset DBUS_SESSION_BUS_ADDRESS\nunset XDG_RUNTIME_DIR' $STARTWM_FILE

echo "Настройка завершена."


# Важные команды для работы с xrdp
#echo "Проверка статуса службы xrdp..."
#sudo systemctl status xrdp

# echo "Проверка сетевых интерфейсов..."
# ip a

#echo "Просмотр логов xrdp..."
#sudo tail -f /var/log/xrdp.log

#echo "Просмотр логов xrdp-sesman..."
#sudo tail -f /var/log/xrdp-sesman.log
