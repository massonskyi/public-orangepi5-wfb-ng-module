from fastapi import HTTPException, APIRouter
from models import ConfigUpdate, ConfigDelete

endpoint = APIRouter(
    prefix="/crud",
    tags=["API CRUD Configurator"],
)

@endpoint.get('/data')
def get_data_from_config():
    from tools import read_config
    from config import DEFAULT_CONFIG_PATH

    import os

    if not os.path.exists(DEFAULT_CONFIG_PATH):
        raise HTTPException(status_code=501, detail=f"Config file not found: {DEFAULT_CONFIG_PATH}")

    config = read_config(config_file=DEFAULT_CONFIG_PATH)
    config_dict = {
        section: dict(config.items(section))
        for section in config.sections()
    }
    print(f"Sections: {config.sections()}")
    print(f"Config dict: {config_dict}")
    return config_dict

@endpoint.post("/config")
def update_config(update: ConfigUpdate):
    from tools import read_config, write_config
    from config import DEFAULT_CONFIG_PATH
    config = read_config(config_file=DEFAULT_CONFIG_PATH)

    for section, items in update.config.items():
        if not config.has_section(section):
            config.add_section(section)

        for key, value in items.items():
            config.set(section, key, value)

    # Remove sections that are no longer present
    for section in config.sections():
        if section not in update.config:
            config.remove_section(section)

    write_config(config_file=DEFAULT_CONFIG_PATH, config=config)

    return {"message": "Configuration updated successfully"}
    return {"message": "Configuration updated successfully"}

@endpoint.post("/config/add")
def add_config(update: ConfigUpdate):
    from tools import read_config, write_config
    from config import DEFAULT_CONFIG_PATH
    config = read_config(config_file=DEFAULT_CONFIG_PATH)

    if not config.has_section(update.section):
        config.add_section(update.section)

    config.set(update.section, update.key, update.value)
    write_config(config_file=DEFAULT_CONFIG_PATH, config=config)

    return {"message": "Configuration added successfully"}

@endpoint.delete("/config/delete")
def delete_config(delete: ConfigDelete):
    from tools import read_config, write_config
    from config import DEFAULT_CONFIG_PATH
    config = read_config(config_file=DEFAULT_CONFIG_PATH)

    if not config.has_section(delete.section):
        raise HTTPException(status_code=404, detail=f"Section '{delete.section}' not found")

    if not config.has_option(delete.section, delete.key):
        raise HTTPException(status_code=404, detail=f"Key '{delete.key}' not found in section '{delete.section}'")

    config.remove_option(delete.section, delete.key)

    # If the section becomes empty, remove it
    if not config.options(delete.section):
        config.remove_section(delete.section)

    write_config(config_file=DEFAULT_CONFIG_PATH, config=config)

    return {"message": "Configuration deleted successfully"}
