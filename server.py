from http.server import BaseHTTPRequestHandler, HTTPServer
import random

HOST = "127.0.0.1"
PORT = 7001

class MyHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/random":
            # Повертаємо випадкове слово
            result = random.choice(["зрада", "перемога"])
            self.send_response(200)
            self.send_header("Content-type", "text/plain; charset=utf-8")
            self.end_headers()
            self.wfile.write(result.encode("utf-8"))
            return

        # Основна сторінка
        html = """
        <html>
        <head>
            <meta charset="UTF-8">
            <title>Женя</title>
            <style>
                body {
                    background-color: #0033cc;
                    color: yellow;
                    font-size: 48px;
                    text-align: center;
                    margin-top: 100px;
                    font-family: Arial, sans-serif;
                }
                button {
                    margin-top: 50px;
                    font-size: 32px;
                    padding: 20px 40px;
                    background-color: yellow;
                    color: black;
                    border: none;
                    cursor: pointer;
                    border-radius: 10px;
                }
            </style>
        </head>
        <body>
            <div>Женя гарна українка, танцює гопака</div>
            <button onclick="showMessage()">Слава Україні</button>

            <script>
                function showMessage() {
                    fetch('/random')
                        .then(response => response.text())
                        .then(text => alert(text));
                }
            </script>
        </body>
        </html>
        """

        self.send_response(200)
        self.send_header("Content-type", "text/html; charset=utf-8")
        self.end_headers()
        self.wfile.write(html.encode("utf-8"))

server = HTTPServer((HOST, PORT), MyHandler)
print(f"Server running at http://{HOST}:{PORT}")
server.serve_forever()
