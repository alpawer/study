#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

case "$1" in
    start)
        bash "$SCRIPT_DIR/start_server.sh"
        ;;
    stop)
        bash "$SCRIPT_DIR/stop_server.sh"
        ;;
    status)
        if [ -f "$SCRIPT_DIR/server_on" ]; then
            PID=$(cat "$SCRIPT_DIR/server_on")
            if ps -p "$PID" > /dev/null; then
                echo "Сервер працює. PID: $PID"
            else
                echo "PID є, але процес не працює."
            fi
        else
            echo "Сервер не запущений."
        fi
        ;;
    restart)
        bash "$SCRIPT_DIR/stop_server.sh"
        bash "$SCRIPT_DIR/start_server.sh"
        ;;
    *)
        echo "Використання: server {start|stop|status|restart}"
        ;;
esac

