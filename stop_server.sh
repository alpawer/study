#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ ! -f "$SCRIPT_DIR/server_on" ]; then
    echo "Сервер не запущений."
    exit 1
fi

PID=$(cat "$SCRIPT_DIR/server_on")

kill "$PID"

rm "$SCRIPT_DIR/server_on"

echo "Сервер зупинено."
