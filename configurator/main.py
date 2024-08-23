import json
from fastapi import FastAPI
from routes import router as API_CRUD
from starlette.middleware.cors import CORSMiddleware
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.responses import HTMLResponse
from fastapi.middleware.cors import CORSMiddleware
import asyncio
import paramiko

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


@app.websocket("/ws/ssh")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    try:
        while True:
            data = await websocket.receive_text()
            try:
                data_dict = json.loads(data)
                address = data_dict.get('address')
                command = data_dict.get('command')

                if not address or not command:
                    await websocket.send_text('Invalid data format')
                    continue
                print(address)
                # Handle SSH connection and commands here
                ssh = paramiko.SSHClient()
                ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
                ssh.connect(address, username='your_username', password='your_password')

                stdin, stdout, stderr = ssh.exec_command(command)
                result = stdout.read().decode()
                await websocket.send_text(result)
            except json.JSONDecodeError:
                await websocket.send_text('Invalid data format')
    except WebSocketDisconnect:
        pass
    

if __name__ == '__main__':
    import os 
    import sys
    config_file_path = os.path.expanduser("~/.config/sysconfwfb.conf")
    if not os.path.exists(config_file_path):
        print("Конфигурационный файл не найден, запустите ~/scripts/installer.sh для его создания")
        sys.exit(1)
    import uvicorn
    uvicorn.run(app, host='0.0.0.0', port=8000)