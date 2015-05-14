#! /bin/bash -
#show the battery left, while hardware information is kept in /proc for Linux

#DEBUG: file location errors!
a=$(cat /proc/acpi/battery/BAT0/state | awk '/remain/ {print $3}')
b=`cat /proc/acpi/battery/BAT0/info|awk '/last full capacity/ {print $4}'`
echo $[$a*100/$b]%

