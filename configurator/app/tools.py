import configparser

# Функция для чтения конфигурационного файла
def read_config(config_file: str):
    config = configparser.ConfigParser()
    config.read(config_file)
    return config


# Функция для записи в конфигурационный файл
def write_config(config_file: str, config):
    with open(config_file, 'w') as configfile:
        config.write(configfile)