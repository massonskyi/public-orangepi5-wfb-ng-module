#!/bin/bash

read_config() {
    local config_file=$1
    local section=$2
    local key=$3
    local value=$(grep -E "^\s*$key\s*=" "$config_file" | awk -F '=' '{print $2}' | tr -d ' ')
    echo "$value"
}

config_file="sysconfwfb.conf"
config_path="$HOME/.config/$config_file"

# Проверка, существует ли файл
if [ ! -f "$config_path" ]; then
  log_error "Файл $config_path не найден. Возможно, вы не выполнили установку"
  exit -1
fi

fps=$(read_config "$config_path" "TX" "tx_video_fps")

if [ ! $fps ]; then
    log_error "Не удалось получить параметр tx_video_fps из конфигурационного файла"
    exit 1
fi

bitrate=$(read_config "$config_path" "TX" "tx_bitrate_video")
if [ ! $bitrate ]; then
    log_error "Не удалось получить параметр tx_bitrate_video из конфигурационного файла"
    exit 1
fi
resolution=$(read_config "$config_path" "TX" "tx_resolution_video")

if [ ! $resolution ]; then
    log_error "Не удалось получить параметр tx_resolution_video из конфигурационного файла"
    exit 1
fi

# Извлекаем ширину и высоту
width=${resolution%x*}
if [ ! $width ]; then
    log_error "Не удалось получить параметр width из $resolution"
    exit 1
fi

height=${resolution#*x}
if [ ! $height ]; then
    log_error "Не удалось получить параметр height из $resolution"
    exit 1
fi

gst-launch-1.0 -v v4l2src device=/dev/video0 ! video/x-raw,framerate=$fps/1 ! videoscale ! video/x-raw,width=$width,height=$height ! videoconvert ! x264enc tune=zerolatency bitrate=$bitrate speed-preset=superfast ! rtph264pay ! udpsink host=127.0.0.1 port=5600
