#! /bin/bash -
#find out biggest number from given three nos. Nos are supplies as command line argument. 
#Print error if sufficient arguments are not supplied.

if [ $# -ne 3 ]
then
	echo "ERROR: invalid arguments" #maybe >&2
	echo "USAGE: ./$0 n1 n2 n3"
	exit 1
else
	t=$1
	if [ $2 -gt $t ]
	then
		t=$2
	fi
	if [ $3 -gt $t ]
	then
		t=$3
	fi
	echo "The biggest number is $t"
fi

