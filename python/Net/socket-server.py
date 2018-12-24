#! /usr/bin/env python
# -*- coding=utf-8 -*-

import SocketServer

class SocketHandler(SocketServer.BaseRequestHandler):
    def handle(self):
        print "get a connection from client:", self.client_address
        data = 'start'
        while len(data):
            data = self.request.recv(2048)
            self.request.send("return: " + data)
        print "client close..."
servAddr = ("0.0.0.0", 8888)
print "waiting for connection..."
server = SocketServer.TCPServer(servAddr, SocketHandler)
server.serve_forever()

