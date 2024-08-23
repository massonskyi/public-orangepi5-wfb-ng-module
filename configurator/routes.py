from fastapi import HTTPException
from fastapi import APIRouter
from models import ConfigUpdate

router = APIRouter(
    prefix="/crud",
    tags=["API CRUD Configurator"],
)


@router.get('/data')
def get_data_from_config():
    from tools import read_config
    from config import DEFAULT_CONFIG_PATH
    
    import os
    
    if not os.path.exists(DEFAULT_CONFIG_PATH):
        raise HTTPException(status_code=501, detail="Config file not found: {DEFAULT_CONFIG_PATH}")

    config = read_config(config_file=DEFAULT_CONFIG_PATH)
    config_dict = {
        section: dict(config.items(section))
        for section in config.sections()
    }
    print(f"Sections: {config.sections()}")
    print(f"Config dict: {config_dict}")
    return config_dict

@router.post("/config")
def update_config(update: ConfigUpdate):
    from tools import read_config, write_config
    from config import DEFAULT_CONFIG_PATH
    config = read_config(config_file=DEFAULT_CONFIG_PATH)

    if not config.has_section(update.section):
        config.add_section(update.section)

    config.set(update.section, update.key, update.value)
    write_config(config_file=DEFAULT_CONFIG_PATH, config=config)

    return {"message": "Configuration updated successfully"}