from pydantic import BaseModel

# Модель данных для обновления конфигурации
class ConfigUpdate(BaseModel):
    section: str
    key: str
    value: str