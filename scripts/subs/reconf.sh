#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "You must run this with superuser priviliges.  Try \"sudo ./installer.sh\"" 2>&1
  exit 1
else
  echo "About to run install steps..."
fi

echo "Удаление старого конфигурациононного файла"
if ! rm -rf "~/.config/sysconfwfs.conf"; then
    echo "Не удалось удалить старый конфигурационный файл"
    exit 1
fi

RES=$"$HOME/repo/public-orangepi5-wfb-ng-module/scripts/subs/./create_conf.sh"
echo $RES