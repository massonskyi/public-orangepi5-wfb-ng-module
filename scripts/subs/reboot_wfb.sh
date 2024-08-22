#!/bin/bash

# Функция для перезапуска служб
restart_services() {
    for service in "$@"; do
        echo "Перезапуск службы $service..."
        sudo systemctl restart $service
        if [ $? -eq 0 ]; then
            echo "Служба $service успешно перезапущена."
        else
            echo "Ошибка при перезапуске службы $service."
        fi
    done
}

# Проверка параметра -s
while getopts "s:" opt; do
    case $opt in
        s)
            SERVICES="$OPTARG"
            ;;
        \?)
            echo "Неверный параметр: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

# Проверка, что параметр -s передан
if [ -z "$SERVICES" ]; then
    echo "Параметр -s не передан."
    exit 1
fi

# Перезапуск служб
restart_services $SERVICES
