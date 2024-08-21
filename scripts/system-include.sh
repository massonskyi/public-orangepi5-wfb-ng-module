#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "You must run this with superuser privileges. Try \"sudo ./system-include.sh\"" 2>&1
  exit 1
else
  echo "About to run system-include steps..."
fi

param_r=0
param_s=0

while getopts ":rs" opt; do
  case ${opt} in
    r )
      param_r=1
      echo "Parameter -r detected"
      ;;
    s )
      param_s=1
      echo "Parameter -s detected"
      ;;
    \? )
      echo "Invalid option: $OPTARG" 1>&2
      exit 1
      ;;
    : )
      echo "Invalid option: $OPTARG requires an argument" 1>&2
      exit 1
      ;;
  esac
done

# Получение текущей директории
current_dir=$(pwd)
log_file_system_include="$current_dir/../system-include.log"
log_file_sender="$current_dir/../sender.log"
log_file_receiver="$current_dir/../receiver.log"

systemd_dir="$current_dir/../systemd/"
chown orangepi:orangepi "$log_file_system_include"
chmod 664 "$log_file_system_include"

# Логирование
logfile="${pwd}/../system-include.log"
exec > >(tee -a "$logfile") 2>&1

chown orangepi:orangepi "$log_file_sender"
chmod 664 "$log_file_sender"

chown orangepi:orangepi "$log_file_receiver"
chmod 664 "$log_file_receiver"

# Создаем временный файл
temp_file=$(mktemp)

# Копируем текущий файл sudoers в временный файл
sudo cp /etc/sudoers "$temp_file"

# Добавляем строки в временный файл
echo "orangepi ALL=(ALL) NOPASSWD: /usr/sbin/iwconfig, /usr/sbin/ifconfig, /usr/sbin/iw, /usr/sbin/airmon-ng, /bin/systemctl" >> "$temp_file"
echo "orangepi ALL=(ALL) NOPASSWD: /home/orangepi/repo/public-orangepi5-wfb-ng-module/build/VideoTx" >> "$temp_file"
echo "orangepi ALL=(ALL) NOPASSWD: /home/orangepi/repo/public-orangepi5-wfb-ng-module/build/VideoRx" >> "$temp_file"

# Проверяем синтаксис временного файла
sudo visudo -c -f "$temp_file"

# Если синтаксис корректен, копируем временный файл в /etc/sudoers
if [ $? -eq 0 ]; then
  sudo cp "$temp_file" /etc/sudoers
  echo "Строки успешно добавлены в файл sudoers"
else
  echo "Ошибка синтаксиса в файле sudoers"
  exit 1
fi

# Удаляем временный файл
rm "$temp_file"

cd "$systemd_dir"

cp ./receiver.service /etc/systemd/system/
cp ./sender.service /etc/systemd/system/
cp ./tx_stream.service /etc/systemd/system
systemctl daemon-reload

if [ $param_r -eq 1 ]; then
  echo "Parameter -r is set"
  systemctl enable receiver.service
  systemctl start receiver.service

  cd "$current_dir"	
  mkdir -p /usr/local/bin/receive
  cp run-service-received.sh /usr/local/bin/receive
  cp rx_stream_x264.sh /usr/local/bin/receive
fi

if [ $param_s -eq 1 ]; then
  echo "Parameter -s is set"

  systemctl enable sender.service
  systemctl start sender.service

  cd "$current_dir"	
  mkdir -p /usr/local/bin/sender
  cp run-service-sender.sh /usr/local/bin/sender
  cp tx_stream_x264.sh /usr/local/bin/sender
fi

echo "Встройка в систему завершена"
