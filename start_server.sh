#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

python "$SCRIPT_DIR/server.py" --port 80 &
PID=$!

echo $PID > "$SCRIPT_DIR/server_on"

echo "Сервер запущено. PID: $PID"
