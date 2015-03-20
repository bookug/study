#! /bin/bash -
#to show information about the command line arguments

echo "Total number of command line argument are $#"
echo "$0 is script name"	#not counted to args-num
echo "$1 is first argument"
echo "$2 is second argument"
echo "All of them are : $* or $@"
