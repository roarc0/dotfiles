#!/usr/bin/env python3

from http.server import HTTPServer, SimpleHTTPRequestHandler
import os

server_address = ('0.0.0.0', 8000)
httpd = HTTPServer(server_address, SimpleHTTPRequestHandler)
print('Running server ... http://localhost:8000')
httpd.serve_forever()
