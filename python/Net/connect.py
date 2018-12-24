#! /usr/bin/env python

import socket

print "creating socket..."
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)    #ipv4, tcp
print "done."

print "looking up port number..."
port = socket.getservbyname('http', 'tcp')
print "done."

print "connecting to remote host on port %d..." % port
s.connect(("www.google.com", port))
print "done."

print "connected from", s.getsockname()  #port randomly set
print "connected to", s.getpeername()

