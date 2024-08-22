#!/bin/bash

gst-launch-1.0 -v udpsrc port=5600 caps="application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)H264, payload=(int)96" ! rtph264depay ! decodebin ! videoconvert ! autovideosink

# # Получаем текущее разрешение экрана
# res=$(xrandr --current | sed -n 's/.* connected \([0-9]*\)x\([0-9]*\)+.*/\1x\2/p')

# if [ -z "$res" ]; then
#     echo "Display resolution not found"
#     # Если дисплей не подключен, используем размер картинки
# gst-launch-1.0 -v udpsrc port=5600 caps="application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)H264, payload=(int)96" ! rtph264depay ! decodebin ! videoconvert ! autovideosink
# else
#     # Если дисплей подключен, разворачиваем видео на весь экран
#     width=$(echo $res | cut -d'x' -f1)
#     height=$(echo $res | cut -d'x' -f2)
#     gst-launch-1.0 -v udpsrc port=5600 caps="application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)H264, payload=(int)96" ! rtph264depay ! decodebin ! videoconvert ! videoscale ! video/x-raw,width=$width,height=$height ! autovideosink
# fi
