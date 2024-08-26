import os

# Определение домашней директории пользователя
HOME_DIR = os.path.expanduser("~")

# Определение пути к конфигурационному файлу
DEFAULT_CONFIG_PATH = os.path.join(HOME_DIR, ".config", "sysconfwfb.conf")

# Вывод пути к конфигурационному файлу
print(f"Путь к конфигурационному файлу: {DEFAULT_CONFIG_PATH}")

# Проверка существования конфигурационного файла
if os.path.exists(DEFAULT_CONFIG_PATH):
    print("Конфигурационный файл существует.")
else:
    print("Конфигурационный файл не существует. Запустите ~/scripts/installer.sh для его создания.")


import os
import platform
import json

def get_config_path():
    return "../data/favorites.json"
