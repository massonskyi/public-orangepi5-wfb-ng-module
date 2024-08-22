#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "You must run this with superuser priviliges.  Try \"sudo ./setup_88x2bu-20210702.sh\"" 2>&1
  exit 1
else
  echo "About to run install steps..."
fi

check_directory() {
    local directory=$1

    if [ -d "$directory" ]; then
        echo "Папка $directory существует."
    else
        echo "Папка $directory не существует.\nСоздание..."
        mkdir -p ~/drivers
    fi
  cd ~/drivers
}

apt update && sudo apt upgrade

apt install -y build-essential dkms iw

check_directory ~/drivers

git clone https://github.com/aircrack-ng/rtl8812au.git
cd ~/drivers/rtl8812au
make dkms_install
make dkms_remove

chmod +x ./dkms_install.sh

./dkms_install.sh