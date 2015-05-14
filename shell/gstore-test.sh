#! /bin/bash -

#This script is used to test the time of Gstore program.
#Place this in the Gstore directory, then run it with two args

path=/home/zengli/LUBM_triples/test_SPARQL/q

function run()
{
	query=${path}$1
	echo "the query file is $query"
	./gquery $db $query | grep "Total time used:"	| grep -o "[0-9]*ms" >> result.log
	echo 3 > /proc/sys/vm/drop_caches
}

min=0
max=21
if [ $# -ne 3 ]
then
	echo "In valid arguments"
	echo "USAGE: $0 min max db"
	exit 1
elif [ $1 -lt $min ]
then
	echo "Args must be integer, varying from 0 to 21"
	exit 1
elif [ $2 -gt $max ]
then
	echo "Args must be integer, varying from 0 to 21"
	exit 1
elif [ $1 -gt $2 ]
then
	echo "$1 can not be greater than $2"
	exit 1
else
	cnt=$1
	db=$3
	#`> result.log`
	echo "min: $1    max: $2    db: $3" > result.log
	while [ ! $cnt -gt $2 ]
	do
		run $cnt
		#echo $cnt
		cnt=`expr $cnt + 1`
	done
fi
	

