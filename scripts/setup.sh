#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "You must run this with superuser privileges. Try \"sudo ./system-include.sh\"" 2>&1
  exit 1
else
  echo "About to run system-include steps..."
fi

# Получаем название Wi-Fi адаптера
adapter=$(sudo iwconfig 2>/dev/null | grep -oP '^\w+')

if [ -z "$adapter" ]; then
  echo "Wi-Fi адаптер не найден"
  exit 1
fi

ip link set $adapter down
iwconfig $adapter mode monitor
ip link set $adapter up

iw dev $adapter set channel 36

echo "Адаптер настроен"
echo "Отключение NetworkManager..."

airmon-ng check kill
airmon-ng start $adapter


echo "Настройка закончена"