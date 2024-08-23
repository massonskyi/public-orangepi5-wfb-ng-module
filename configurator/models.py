from pydantic import BaseModel

from typing import Any, Dict, List

class ConfigUpdate(BaseModel):
    config: Dict[str, Dict[str, Any]]

class ConfigDelete(BaseModel):
    section: str
    key: str
    
    

class FavoritesRequest(BaseModel):
    favorites: List[str]