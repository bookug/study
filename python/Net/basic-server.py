#! /usr/bin/env python

#server should not go down when error

import socket, traceback

host = ''
port = 54123        #> 1024 if not root

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
s.bind((host, port))
print "waiting for connections..."
s.listen(5)         #not  exceed 5 in queue

while True:
    try:
        clientsock, clientaddr = s.accept()     #blocked here
    except KeyboardInterrupt:
        raise
    except:
        traceback.print_exc()
        continue
    try:
        print "get connection from", clientsock.getpeername()
    except (KeyboardInterrupt, SystemExit):
        raise
    except:
        traceback.print_exc()
    try:
        clientsock.close()
    except KeyboardInterrupt:
        raise
    except:
        clientsock.print_exc()

