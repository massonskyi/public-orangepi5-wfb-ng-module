#!/bin/bash

current_dir=$(pwd)
# Define log files for each process
FASTAPI_LOG="$current_dir/../../log/fastapi_server.log"
NPM_LOG="$current_dir/../../log/npm_server.log"

# Start FastAPI server in the background and log output
echo "Starting FastAPI server..."
# uvicorn /usr/local/bin/servers/configurator/main:app --host 0.0.0.0 --port 8000 > "$FASTAPI_LOG" 2>&1 &
source $current_dir/../../configurator/.venv/bin/activate
cd $current_dir/../../configurator/
python3 main.py > "$FASTAPI_LOG" 2>&1 &
FASTAPI_PID=$!
echo "FastAPI server started with PID $FASTAPI_PID. Logs are in $FASTAPI_LOG"
deactivate
# Start npm in the background and log output
echo "Starting npm server..."
cd "$current_dir/../../config-editor/"
npm run build
serve -s build > "$NPM_LOG" 2>&1 &

NPM_PID=$!
echo "npm server started with PID $NPM_PID. Logs are in $NPM_LOG"

# Wait for both processes to complete (if needed)
wait $FASTAPI_PID $NPM_PID