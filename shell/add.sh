#! /bin/bash -
#add two nos, which are supplied as command line argument, 
#and if this two nos are not given show error and its usage

if [ $# -ne 2 ] 
then
	echo "ERROR: invalid arguments"
	echo "USAGE: $0 n1 n2"
	exit 1
else
	echo "Sum of $1 and $2 is `expr $1 + $2`"
fi
