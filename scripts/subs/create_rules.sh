#!/bin/bash

# Функция для создания правила udev
create_udev_rule() {
    local script_path=$1
    local interface=$2

    # Проверка существования файла правил
    if [ ! -f "/etc/udev/rules.d/99-ethernet.rules" ]; then
        touch "/etc/udev/rules.d/99-ethernet.rules"
    fi

    # Добавление правила в файл
    echo "ACTION==\"add\", SUBSYSTEM==\"net\", KERNEL==\"$interface\", RUN+=\"$script_path\"" >> "/etc/udev/rules.d/99-ethernet.rules"
    echo "Правило udev для интерфейса $interface добавлено в /etc/udev/rules.d/99-ethernet.rules."
}

# Проверка параметров
while getopts "p:" opt; do
    case $opt in
        p)
            SCRIPT_PATH="$OPTARG"
            ;;
        \?)
            echo "Неверный параметр: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

# Проверка, что параметр -p передан
if [ -z "$SCRIPT_PATH" ]; then
    echo "Параметр -p не передан."
    exit 1
fi

# Проверка существования скрипта
if [ ! -f "$SCRIPT_PATH" ]; then
    echo "Скрипт $SCRIPT_PATH не найден."
    exit 1
fi

# Создание правила udev
create_udev_rule "$SCRIPT_PATH" "eth0"

# Перезапуск udev для применения изменений
sudo udevadm control --reload-rules
