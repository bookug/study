#! /usr/bin/env python

#get list of available socket options

import socket

solist = [x for x in dir(socket) if x.startswith('SO_')]
solist.sort()
for x in solist:
    print x

