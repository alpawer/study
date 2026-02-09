from http.server import BaseHTTPRequestHandler, HTTPServer
import random
import argparse

class MyHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/random":
            result = random.choice(["зрада", "перемога"])
            self.send_response(200)
            self.send_header("Content-type", "text/plain; charset=utf-8")
            self.end_headers()
            self.wfile.write(result.encode("utf-8"))
            return

        if self.path == "/style.css":
            self.send_response(200)
            self.send_header("Content-type", "text/css; charset=utf-8")
            self.end_headers()
            with open("style.css", "rb") as f:
                self.wfile.write(f.read())
            return

        if self.path == "/" or self.path == "/index.html":
            self.send_response(200)
            self.send_header("Content-type", "text/html; charset=utf-8")
            self.end_headers()
            with open("index.html", "rb") as f:
                self.wfile.write(f.read())
            return

        self.send_response(404)
        self.end_headers()
        self.wfile.write(b"404 Not Found")


# --- Вибір порту ---
parser = argparse.ArgumentParser()
parser.add_argument("--port", type=int, default=7001, help="Port to run server on")
args = parser.parse_args()

server = HTTPServer(("127.0.0.1", args.port), MyHandler)
print(f"Server running at http://127.0.0.1:{args.port}")
server.serve_forever()
