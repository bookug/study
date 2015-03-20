#! /bin/bash -
#using case statement to perform basic math operation as follows
#+ addition
#- subtraction
#x multiplication
#/ division
#% remainder #this is not ok to use here

if test $# = 3		#NOTICE
then
	case $2 in
	+) let z=$1+$3;;
	-) let z=$1-$3;;
	/) let z=$1/$3;;
	x|X) let z=$1*$3;;
	*) echo "ERROR: invalid operator $2"
		exit;;
	esac
	echo "Answer is $z"
else
	echo "ERROR: invalid arguments"
	echo "USAGE: ./$0 n1 operator n2"
	echo "Operator can be +, -, x, /"
fi

#echo 5.12 + 2.5 | bc	#this can compute the real number
#ret=`echo 1.0 + 2.3 | bc`
