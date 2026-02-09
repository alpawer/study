from http.server import BaseHTTPRequestHandler, HTTPServer
import random
import os

HOST = "127.0.0.1"
PORT = 80

class MyHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        # Маршрут для випадкового слова
        if self.path == "/random":
            result = random.choice(["зрада", "перемога"])
            self.send_response(200)
            self.send_header("Content-type", "text/plain; charset=utf-8")
            self.end_headers()
            self.wfile.write(result.encode("utf-8"))
            return

        # Видача CSS
        if self.path == "/style.css":
            self.send_response(200)
            self.send_header("Content-type", "text/css; charset=utf-8")
            self.end_headers()
            with open("style.css", "rb") as f:
                self.wfile.write(f.read())
            return

        # Видача HTML
        if self.path == "/" or self.path == "/index.html":
            self.send_response(200)
            self.send_header("Content-type", "text/html; charset=utf-8")
            self.end_headers()
            with open("index.html", "rb") as f:
                self.wfile.write(f.read())
            return

        # Якщо сторінка не знайдена
        self.send_response(404)
        self.end_headers()
        self.wfile.write(b"404 Not Found")

server = HTTPServer((HOST, PORT), MyHandler)
print(f"Server running at http://{HOST}:{PORT}")
server.serve_forever()
