#! /usr/bin/env python

import socket, sys

host = ''       #bind to all interfaces
port = 51423

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
s.bind((host, port))
s.listen(1)
print "server is running on port %d; press Ctrl-C to terminate." \
        % port
while True:
    clientsock, clientaddr = s.accept()
    clientfile = clientsock.makefile('rw', 0)
    clientfile.write("welcome, " + str(clientaddr) + "\n")
    clientfile.write("please enter a string: ")
    line = clientfile.readline().strip()
    sys.stdout.write(line);
    sys.stdout.flush()    #write() is with buffering
    clientfile.write("you entered %d characters\n" % len(line))
    clientfile.close()
    clientsock.close()

