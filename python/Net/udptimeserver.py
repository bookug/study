#! /usr/bin/env python

#it is easier to use UDP in server than TCP, while reversed in client:)
#not use makefile() in UDP, not like files

import socket, traceback, time, struct

host = ''
port = 51423

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
s.bind((host, port))

while True:
    try:
        message, address = s.recvfrom(8192)
        secs = int(time.time())   #seconds since 1970.1.1
        secs -= 60 * 60 * 24      #make it yesterday
        secs += 2208988800        #convert to secs since 1900.1.1
        reply += struct.pack("!I", secs)
        s.sendto(reply, address)
    except (KeyboardInterrupt, SystemExit):
        raise
    except:
        traceback.print_exc()

