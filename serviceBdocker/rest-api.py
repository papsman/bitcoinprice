import http.server
import threading

PORT = 8001

class HealthCheckHandler(http.server.BaseHTTPRequestHandler):

    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/plain")
        self.end_headers()
        self.wfile.write("Service is healthy!".encode())

with http.server.HTTPServer(("", PORT), HealthCheckHandler) as httpd:
    print(f"Serving on port {PORT}")
    httpd.serve_forever()
