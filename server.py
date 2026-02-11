from http.server import BaseHTTPRequestHandler, HTTPServer
import random
import argparse
import os

# === БАЗОВА ПАПКА, ДЕ ЛЕЖИТЬ server.py ===
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

def path(*parts):
    return os.path.join(BASE_DIR, *parts)

# === ФАЙЛ ДЛЯ ЗБЕРЕЖЕННЯ КОЛЬОРУ ===
COLOR_FILE = path("bg_color.txt")

def get_color():
    if os.path.exists(COLOR_FILE):
        return open(COLOR_FILE, "r").read().strip()
    return "#0033cc"  # стандартний синій

def set_color(color):
    with open(COLOR_FILE, "w") as f:
        f.write(color)


class MyHandler(BaseHTTPRequestHandler):
    def do_GET(self):

        # --- API: випадкове слово ---
        if self.path == "/random":
            result = random.choice(["зрада", "перемога"])
            self.send_response(200)
            self.send_header("Content-type", "text/plain; charset=utf-8")
            self.end_headers()
            self.wfile.write(result.encode("utf-8"))
            return

        # --- API: отримати поточний колір ---
        if self.path == "/color":
            color = get_color()
            self.send_response(200)
            self.send_header("Content-type", "text/plain")
            self.end_headers()
            self.wfile.write(color.encode())
            return

        # --- Видача CSS ---
        if self.path.startswith("/css/"):
            file_path = path(self.path.lstrip("/"))
            if os.path.exists(file_path):
                self.send_response(200)
                self.send_header("Content-type", "text/css; charset=utf-8")
                self.end_headers()
                with open(file_path, "rb") as f:
                    self.wfile.write(f.read())
            else:
                self.send_response(404)
                self.end_headers()
            return

        # Golang static server
        # --- Видача HTML ---
        if self.path == "/" or self.path == "/index.html":
            with open(path("pornhub.html"), "r", encoding="utf-8") as f:
                html = f.read()

            self.send_response(200)
            self.send_header("Content-type", "text/html; charset=utf-8")
            self.end_headers()
            self.wfile.write(html.encode("utf-8"))
            return

        # --- 404 ---
        self.send_response(404)
        self.end_headers()


    def do_POST(self):

        # --- API: встановити новий колір ---
        if self.path == "/color":
            length = int(self.headers["Content-Length"])
            body = self.rfile.read(length).decode()
            set_color(body)

            self.send_response(200)
            self.end_headers()
            self.wfile.write(b"OK")
            return

        self.send_response(404)
        self.end_headers()


# === ВИБІР ПОРТУ ===
parser = argparse.ArgumentParser()
parser.add_argument("--port", type=int, default=8080)
args = parser.parse_args()

# === ЗАПИС PID ===
pid = os.getpid()
with open(path("server_on"), "w") as f:
    f.write(str(pid))

print(f"Server running at http://127.0.0.1:{args.port}")
print(f"PID: {pid}")

server = HTTPServer(("127.0.0.1", args.port), MyHandler)
server.serve_forever()
