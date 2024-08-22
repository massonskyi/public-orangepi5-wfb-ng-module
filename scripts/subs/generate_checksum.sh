#!/bin/bash

# Функция для генерации контрольной суммы
generate_checksum() {
    local file=$1

    if [ ! -f "$file" ]; then
        echo "Файл $file не найден."
        return 1
    fi

    # Вычисление контрольной суммы файла
    checksum=$(sha256sum "$file" | awk '{print $1}')

    # Сохранение контрольной суммы в файл
    checksum_file="${file}.sha256"
    echo "$checksum" > "$checksum_file"

    echo "Контрольная сумма для файла $file сохранена в $checksum_file."
}

# Проверка параметров
if [ $# -ne 1 ]; then
    echo "Использование: $0 <файл>"
    exit 1
fi

# Генерация контрольной суммы
generate_checksum $1
