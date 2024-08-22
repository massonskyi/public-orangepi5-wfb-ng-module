#!/bin/bash

# Директория, в которой находится index.html
WEB_DIR="$(pwd)/configurator"
echo $WEB_DIR
# Порт, на котором будет слушать сервер
PORT=9000

# Проверка существования директории
if [ ! -d "$WEB_DIR" ]; then
    echo "Директория $WEB_DIR не существует."
    exit 1
fi

# Проверка существования файла index.html
if [ ! -f "$WEB_DIR/index.html" ]; then
    echo "Файл $WEB_DIR/index.html не найден."
    exit 1
fi

# Запуск встроенного HTTP-сервера Python
echo "Запуск веб-сервера на порту $PORT..."
cd "$WEB_DIR" || exit 1
python3 -m http.server $PORT
# Получение PID запущенного сервера
SERVER_PID=$!

# Открытие браузера по умолчанию с запущенным index.html
echo "Открытие браузера..."
xdg-open "http://localhost:$PORT/index.html"

# Ожидание завершения сервера
wait $SERVER_PID