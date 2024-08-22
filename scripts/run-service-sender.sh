#!/bin/bash
sleep 10

read_config() {
    local config_file=$1
    local section=$2
    local key=$3
    local value=$(grep -E "^\s*$key\s*=" "$config_file" | awk -F '=' '{print $2}' | tr -d ' ')
    echo "$value"
}


# Логирование
logfile="${pwd}/../sender.log"
exec > >(tee -a "$logfile") 2>&1

# Функция для логирования ошибок
log_error() {
    local message="$1"
    echo "ERROR: $message"
    exit 1
}

config_file="sysconfwfb.conf"
config_path="$HOME/.config/$config_file"

# Проверка, существует ли файл
if [ ! -f "$config_path" ]; then
  log_error "Файл $config_path не найден. Возможно, вы не выполнили установку"
  exit -1
fi

adapter=$(read_config "$config_path" "WIFI" "wifi_channel")

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

# Устанавливаем канал 36
if ! sudo iw dev $adapter set channel 36; then
  echo "Не удалось установить канал 36 для адаптера $adapter"
  exit 1
fi
# Переходим в директорию с исполняемым файлом
cd /home/orangepi/repo/public-orangepi5-wfb-ng-module/build || { echo "Не удалось перейти в директорию $pwd/../build"; exit 1; }

# Запускаем receiver
if ! sudo ./VideoTx $adapter; then
  echo "Не удалось запустить VideoRx для адаптера $adapter"
  exit 1
fi
