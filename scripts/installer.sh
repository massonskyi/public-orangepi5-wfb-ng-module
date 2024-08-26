#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "You must run this with superuser priviliges.  Try \"sudo ./installer.sh\"" 2>&1
  exit 1
else
  echo "About to run install steps..."
fi

# Получение текущей директории
current_dir=$(pwd)
build_dir="$current_dir/../build"
driver_dir="$current_dir/../driver"
log_file = "$current_dir/../installer.log"

echo > "started installation" >> log_file;
sudo chown orangepi:orangepi $log_file
sudo chmod 664 $log_file


# Логирование
logfile=$log_file
exec > >(tee -a "$logfile") 2>&1

# Функция для логирования ошибок
log_error() {
    local message="$1"
    echo "ERROR: $message"
    exit 1
}

# Обновление и установка необходимых пакетов
echo "Обновление пакетов..."
if ! apt update && apt upgrade -y; then
    log_error "Не удалось обновить пакеты."
    exit -1
fi

echo "Установка необходимых пакетов..."
if ! apt install -y libsodium-dev libpcap-dev dkms cmake aircrack-ng curl; then
    log_error "Не удалось установить необходимые пакеты."
    exit -1
fi
# installs nvm (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
# download and install Node.js (you may need to restart the terminal)
nvm install 20
# verifies the right Node.js version is in the environment
node -v # should print `v20.17.0`
# verifies the right npm version is in the environment
npm -v # should print `10.8.2`
# Создание директории build
echo "Создание директории build..."
if ! mkdir -p "$build_dir"; then
    log_error "Не удалось создать директорию build."
    exit -1
fi

echo "Создание ключей..."
cp rx.key "$build_dir"

cp tx.key "$build_dir"

# Переход в директорию build
echo "Переход в директорию build..."
if ! cd "$build_dir"; then
    log_error "Не удалось перейти в директорию build."
    exit -1
fi

# Запуск cmake
echo "Построение приложения"
if ! cmake ..; then
    log_error "Не удалось запустить cmake."
    exit -1
fi

# Запуск make
if ! make; then
    log_error "Не удалось запустить make."
    exit -1
fi

if ! cd ..; then
    log_error "Неизвестная ошибка"
    exit 1
fi

# # Создание config файла
# echo "Создание конфигурационного файла"

# if ! cd /scripts/subs; then
#     log_error "Неизвестная ошибка, проверьте целостность файлов"
#     exit 1
# fi

# for script in *.sh; do
#     # Проверка, существует ли файл
#     if [ -f "$script" ]; then
#         # Делаем файл исполняемым
#         chmod +x "$script"
#         echo "Сделал $script исполняемым."

#         # Выполняем файл
#         ./"$script"
#         echo "Выполнил $script."
#     else
#         echo "Файл $script не найден."
#     fi
# done

# echo "Все скрипты обработаны."

# Переход в директорию driver
echo "Переход в директорию driver..."
if ! cd "$driver_dir"; then
    log_error "Не удалось перейти в директорию driver."
fi

# Запуск скрипта dkms-install.sh TODO: Реализовать выбор устанавливаемого драйвера
echo "Установка драйверов для адаптера"
chmod +x ./8812au/setup-8812au.sh
if ! ./8812au/setup-8812au.sh; then
   log_error "Не удалось запустить скрипт setup-8812au.sh"
fi

chmod +x ./88x2bu/setup-88x2bu-20210702.sh
if ! ./88x2bu/setup-88x2bu-20210702.sh; then
   log_error "Не удалось запустить скрипт setup-88x2bu-20210702.sh"
fi

echo "Установка завершена успешно."
echo "Далее запустите скрипт 'system-include.sh' для добавление программы в систему"