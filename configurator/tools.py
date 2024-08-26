import configparser
import json
import os

def ensure_config_path_exists(config_path):
    config_dir = os.path.dirname(config_path)
    if not os.path.exists(config_dir):
        os.makedirs(config_dir)
    if not os.path.exists(config_path):
        with open(config_path, 'w') as f:
            json.dump([], f)
            
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
    from config import get_config_path
    config_path = get_config_path()
    ensure_config_path_exists(config_path)
    with open(config_path, "r") as f:
        try:
            return json.load(f)
        except json.JSONDecodeError:
            return []

def save_favorites(favorites):
    from config import get_config_path
    config_path = get_config_path()
    ensure_config_path_exists(config_path)
    with open(config_path, "w") as f:
        json.dump(favorites, f)
