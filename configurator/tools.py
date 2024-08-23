import configparser
import json
import os

# Функция для чтения конфигурационного файла
def read_config(config_file: str):
    config = configparser.ConfigParser()
    config.read(config_file)
    return config


# Функция для записи в конфигурационный файл
def write_config(config_file: str, config):
    with open(config_file, 'w') as configfile:
        config.write(configfile)
        
        
        
# Helper function to load favorites from JSON file
def load_favorites():
    from config import FAVORITES_FILE
    if os.path.exists(FAVORITES_FILE):
        with open(FAVORITES_FILE, "r") as f:
            try:
                return json.load(f)
            except json.JSONDecodeError:
                return []
    return []

# Helper function to save favorites to JSON file
def save_favorites(favorites):
    from config import FAVORITES_FILE
    with open(FAVORITES_FILE, "w") as f:
        json.dump(favorites, f, indent=4)