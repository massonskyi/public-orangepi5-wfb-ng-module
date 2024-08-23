from fastapi import HTTPException, APIRouter, Query
from fastapi.responses import PlainTextResponse
from models import FavoritesRequest
endpoint = APIRouter(
    prefix="/sys",
    tags=["API SYS Configurator"],
)

@endpoint.get("/api/favorites")
async def get_favorites():
    from tools import load_favorites
    return load_favorites()

@endpoint.post("/api/favorites")
async def save_favorites_endpoint(favorites_request: FavoritesRequest):
    from tools import save_favorites
    save_favorites(favorites_request.favorites)
    return {"message": "Favorites saved successfully"}


@endpoint.get("/api/reboot_system")
async def reboot_system_endpoint():
    import subprocess
    try:
        subprocess.run(['sudo', 'reboot'], check=True)
    except subprocess.CalledProcessError as e:
        return {f"Error: {e}"}
    
@endpoint.get("/api/logs", response_class=PlainTextResponse)
async def get_logs(filename: str = Query(..., description="The name of the log file to retrieve")):
    import os
    from config import LOG_FILE_PATH
    log_file_path = os.path.join(LOG_FILE_PATH, filename)
    print(log_file_path)
    if os.path.exists(log_file_path):
        with open(log_file_path, 'r') as file:
            logs = file.read()
        return logs
    else:
        raise HTTPException(status_code=404, detail="Log file not found")