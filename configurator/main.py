import json
from fastapi import FastAPI
from routers.api_crud import endpoint as API_CRUD
from starlette.middleware.cors import CORSMiddleware
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.responses import HTMLResponse
from fastapi.middleware.cors import CORSMiddleware
import os

app = FastAPI(
    title="Configurator"
)

origins = [
    "http://localhost",
    "http://localhost:8080",
    "http://localhost:3000",
    "*"
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,  # Specify allowed origins here
    allow_credentials=True,
    allow_methods=["*"],  # Allow all methods (GET, POST, etc.)
    allow_headers=["*"],  # Allow all headers
)

app.include_router(
    API_CRUD, prefix="/api"
)

# Define the path to the JSON file
FAVORITES_FILE = "favorites.json"

# Helper function to load favorites from JSON file
def load_favorites():
    if os.path.exists(FAVORITES_FILE):
        with open(FAVORITES_FILE, "r") as f:
            try:
                return json.load(f)
            except json.JSONDecodeError:
                return []
    return []

# Helper function to save favorites to JSON file
def save_favorites(favorites):
    with open(FAVORITES_FILE, "w") as f:
        json.dump(favorites, f, indent=4)
from models import FavoritesRequest


@app.get("/api/favorites")
async def get_favorites():
    return load_favorites()

@app.post("/api/favorites")
async def save_favorites_endpoint(favorites_request: FavoritesRequest):
    save_favorites(favorites_request.favorites)
    return {"message": "Favorites saved successfully"}

if __name__ == '__main__':
    import os 
    import sys
    config_file_path = os.path.expanduser("~/.config/sysconfwfb.conf")
    if not os.path.exists(config_file_path):
        print("Конфигурационный файл не найден, запустите ~/scripts/installer.sh для его создания")
        sys.exit(1)
    import uvicorn
    uvicorn.run(app, host='0.0.0.0', port=8000)