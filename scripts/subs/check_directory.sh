#!/bin/bash

# Функция для проверки существования папки
check_directory() {
    local directory=$1

    if [ -d "$directory" ]; then
        echo "Папка $directory существует."
    else
        echo "Папка $directory не существует."
    fi
}

# Проверка параметров
if [ $# -ne 1 ]; then
    echo "Использование: $0 <путь_к_папке>"
    exit 1
fi

# Проверка существования папки
check_directory $1