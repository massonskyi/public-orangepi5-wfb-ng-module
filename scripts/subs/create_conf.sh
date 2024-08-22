create_conf(){
    local config_file=$1
    local wifi_channel=${2:-default_value_wifi_channel}
    local wifi_db=${3:-default_value_wifi_db}
    local tx_video_fps=${4:-default_value_tx_video_fps}
    local tx_bitrate_video=${5:-default_value_tx_bitrate_video}
    local tx_resolution_video=${6:-default_value_tx_resolution_video}

    cat << EOF > "$config_file"
[WIFI]
wifi_channel=$wifi_channel
wifi_db=$wifi_db

[TX]
tx_video_fps=$tx_video_fps
tx_bitrate_video=$tx_bitrate_video
tx_resolution_video=$tx_resolution_video

[RX]

EOF
}

# Создание config файла
echo "Создание конфигурационного файла"
# Получаем название Wi-Fi адаптера
adapter=$(sudo iwconfig 2>/dev/null | grep -oP '^\w+')

if [ -z "$adapter" ]; then
  echo "Wi-Fi адаптер не найден"
  # For test file this line change on adapter = "TestAdapter"
  # exit 1 
  adapter="TestAdapter"
fi

config_file="sysconfwfb.conf"

default_value_wifi_channel=${default_value_wifi_channel:-$adapter}
default_value_wifi_db=${default_value_wifi_db:-20}
default_value_tx_video_fps=${default_value_tx_video_fps:-30}
default_value_tx_bitrate_video=${default_value_tx_bitrate_video:-5500}
default_value_tx_resolution_video=${default_value_tx_resolution_video:-1920x1080}


create_conf $config_file $default_value_wifi_channel $default_value_wifi_db $default_value_tx_video_fps $default_value_tx_bitrate_video $default_value_tx_resolution_video

cp $config_file "~/.config/
echo "Конфигурационный файл $create_conf создан."
