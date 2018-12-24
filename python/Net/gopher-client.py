#! /usr/bin/env python

#Gopher protocol

import socket, sys

port = 70
host = sys.argv[1]
filename = sys.argv[2]

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
try:
	s.connect((host, port))
except socket.gaierror, e:
	print "error connecting to server: %s" % e
	sys.exit(1)
s.sendall(filename + "\r\n")       #ensure all is sent, diffrent from send()

while True:
	buf = s.recv(2048)
	if not len(buf):
		break
	sys.stdout.write(buf)

