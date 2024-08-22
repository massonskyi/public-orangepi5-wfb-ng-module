#!/bin/bash

read_config() {
    local config_file=$1
    local section=$2
    local key=$3
    local value=$(grep -E "^\s*$key\s*=" "$config_file" | awk -F '=' '{print $2}' | tr -d ' ')
    echo "$value"
}

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

echo $adapter