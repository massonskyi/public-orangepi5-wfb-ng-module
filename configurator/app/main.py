from fastapi import FastAPI
from routes import router as API_CRUD
from starlette.middleware.cors import CORSMiddleware

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

if __name__ == '__main__':
    import os 
    import sys
    config_file_path = os.path.expanduser("~/.config/sysconfwfb.conf")
    if not os.path.exists(config_file_path):
        print("Конфигурационный файл не найден, запустите ~/scripts/installer.sh для его создания")
        sys.exit(1)
    import uvicorn
    uvicorn.run(app, host='0.0.0.0', port=8000)