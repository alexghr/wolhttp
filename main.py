#!/usr/bin/env python

from flask import Flask
from wakeonlan import send_magic_packet
import os

app = Flask(__name__)

@app.route('/<addr>', methods = ['POST'])
def hello_world(addr):
    print(f'Sending magic packet to {addr}')
    send_magic_packet(addr)
    return 'OK'

if __name__ == '__main__':
    port = int(os.getenv('PORT', '8080'))
    app.run(host="0.0.0.0", port=port)

