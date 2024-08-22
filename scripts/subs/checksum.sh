#!/bin/bash

# Функция для проверки целостности файлов
check_integrity() {
    local file=$1
    local checksum_file=$2

    if [ ! -f "$file" ]; then
        echo "Файл $file не найден."
        return 1
    fi

    if [ ! -f "$checksum_file" ]; then
        echo "Файл контрольной суммы $checksum_file не найден."
        return 1
    fi

    # Вычисление контрольной суммы файла
    current_checksum=$(sha256sum "$file" | awk '{print $1}')

    # Чтение контрольной суммы из файла
    expected_checksum=$(cat "$checksum_file")

    if [ "$current_checksum" == "$expected_checksum" ]; then
        echo "Файл $file целостен."
    else
        echo "Файл $file изменен."
    fi
}

# Проверка параметров
if [ $# -ne 2 ]; then
    echo "Использование: $0 <файл> <файл_контрольной_суммы>"
    exit 1
fi

# Проверка целостности файлов
check_integrity $1 $2
