#! /usr/bin/env python

# simple Gopher client with file-like interface

import socket, sys

port = 70
host = sys.argv[1]
filename = sys.argv[2]

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((host, port))
fd = s.makefile('rw', 0)   #file mode and buffering mode(better to set to 0)
fd.write(filename + "\r\n")
for line in fd.readlines():
    sys.stdout.write(line)

