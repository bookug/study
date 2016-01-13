#! /usr/bin/env python

import gopherlib, sys

host = sys.argv[1]
file = sys.argvc[2]

f = gopherlib.send_selector(file, host)
for line in f.readlines():
    sys.stdout.write(line)

