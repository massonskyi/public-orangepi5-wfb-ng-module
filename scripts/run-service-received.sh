#!/bin/bash
sleep 10
# Логирование
logfile="/home/orangepi/repo/wfb-ng-module/received.log"
exec > >(tee -a "$logfile") 2>&1

# Получаем название Wi-Fi адаптера
adapter=$(sudo iwconfig 2>/dev/null | grep -oP '^\w+')

if [ -z "$adapter" ]; then
  echo "Wi-Fi адаптер не найден"
  exit 1
fi

echo "Найден Wi-Fi адаптер: $adapter"

# Устанавливаем адаптер в режим монитора
if ! sudo ifconfig $adapter down; then
  echo "Не удалось отключить адаптер $adapter"
  exit 1
fi

if ! sudo iw dev $adapter set type monitor; then
  echo "Не удалось установить адаптер $adapter в режим монитора"
  exit 1
fi

if ! sudo ifconfig $adapter up; then
  echo "Не удалось включить адаптер $adapter"
  exit 1
fi

# Устанавливаем канал 140
if ! sudo iw dev $adapter set channel 140; then
  echo "Не удалось установить канал 140 для адаптера $adapter"
  exit 1
fi

# Проверяем и убиваем процессы, которые могут мешать
if ! sudo airmon-ng check kill; then
  echo "Не удалось убить процессы, которые могут мешать"
  exit 1
fi

# Запускаем airmon-ng
if ! sudo airmon-ng start $adapter; then
  echo "Не удалось запустить airmon-ng для адаптера $adapter"
  exit 1
fi

# Переходим в директорию с исполняемым файлом
cd /home/orangepi/repo/wfb-ng-module/build/ || { echo "Не удалось перейти в директорию ../build/"; exit 1; }

# Запускаем receiver
if ! sudo ./VideoRx $adapter; then
  echo "Не удалось запустить VideoRx для адаптера $adapter"
  exit 1
fi
