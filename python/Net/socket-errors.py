#! /usr/bin/env python

import socket, sys, time

host = sys.argv[1]
textport = sys.argv[2]
filename = sys.argv[3]

try:
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
except socket.error, e:
    print "strange error creating socket: %s" % e
    sys.exit(1)
#try passing it as a numeric port number
try:
    port = int(textport)
except ValueError:
    #that not work, probably a protocol name
    #look it up instead
    try:
        port = socket.getservbyname(textport, 'tcp')
    except socket.error, e:
        print "cannot find your port: %s" % e
        sys.exit(1)
try:
    s.connect((host, port))
except socket.gaierror, e:
    print "address-related error connecting to server: %s" % e
    sys.exit(1)
except socket.error, e:
    print "connection error: %s" % e
    sys.exit(1)
print "sleeping..."
time.sleep(10)
print "continuing."

try:
    s.sendall("GET %s HTTP/1.0\r\n\r\n" % filename)
except socket.error, e:
    print "error sending data: %s" % e
    sys.exit(1)

#WARN: if sendall returned before the server received data, then s.recv()
#will break:)

try:
    s.shutdown(1)
except socket.error, e:
    print "error sending data(detected by shutdown): %s" % e
    sys.exit(1)

while True:
    try:
        buf = s.recv(2048)    
    except socket.error, e:
        print "error recieving data: %s" % s
        sys.exit(1)
    if not len(buf):
        break
    sys.stdout.write(buf)

