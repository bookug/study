#! /bin/bash -
#this program is used to finish the first homework

function random()			#this function is not used, just for fun
{		#if not return explictly, using the last expression-value as ret
	t=`expr $2 - $1`;
	t=`expr $RANDOM % $t`;
	t=`expr $1 + $t`;	
	return $t;				#use $? to get the return-value
}

function f()				#deal and download the according voice
{
	wget -P data http://iciba.com/$1
	ret=`grep -o "您要查找的是不是:" data/$1`
	if [ "$ret" != "" ]		#the word not exist
	then
		echo "Fail to search this word!"
		rm -f data/$1
		return		#NOTICE: can't use exit here!
	fi
	#str1=`grep -m2 -A8 "<span class=\"eg\">" data/$1 | grep -A4 "英" | grep -o "asplay.*onmouseover" | grep -o "asplay('.*\.mp3')"`
	#str2=`grep -m2 -A8 "<span class=\"eg\">" data/$1 | grep -A4 "美" | grep -o "asplay.*onmouseover" | grep -o "asplay('.*\.mp3')"`		#how to find the second?
	str1=`grep -m2 -A8 "<span class=\"eg\">" data/$1 | grep -A4 "英" | grep -o "asplay.*onmouseover" | grep -o "http://[^)]*\.mp3"`
	str2=`grep -m2 -A8 "<span class=\"eg\">" data/$1 | grep -A4 "美" | grep -o "asplay.*onmouseover" | grep -o "http://[^)]*\.mp3"`
	echo $str1
	echo $str2
	if [ "$str1" = "" ]
	then
		echo "English Voice Not Found"
	else
		#len=`expr ${#str1} - 11`    #QUERY:strange here?
		#url=`expr substr $str1 9 $len`
		echo $str1
		wget $str1 -O data/$1-English.mp3	
		#above works because - can't be in variable name, but can be file-name. ${1}_...
	fi
	if [ "$str2" = "" ]
	then
		echo "American Voice Not Found"
	else
		#len=`expr ${#str2} - 11`
		#url=`expr substr $str2 9 $len`
		echo $str2
		wget $str2 -O data/$1-American.mp3
	fi
	rm -f data/$1
}

function error()
{
	echo "ERROR: invalid arguments"
	echo "USAGE: $0 [-f file] [num] [-t]"
	exit 1
}

file="/usr/share/dict/words"
num=100
if [ $# -eq 0 ]
then
	echo "all arguments will use default value"
elif [ $# -eq 3 ]
then
	if [ "$1" != "-f" ]
	then
		error
	fi
	file=$2		#BETTER: check number or string
	num=$3
elif [ $# -eq 1 ]
then
	if [ "$1" != "-t" ]
	then
		num=$1	#BETTER: check number
	else			#input words from the terminal
		echo "Please input in the terminal, press CTRL-C to exit"
		while [ 1 ]	
		do
			read -t 60 -p "Your Words: " query   #NOTICE: not use `` here
			if [ $? -ne 0 ]
			then
				echo "Please input in a minute"
				exit 1
			fi
			f $query
			sleep `expr 5 + $RANDOM % 30`
		done
		exit 0
	fi
else
	error
fi
#cut the first column from file, then extract $num words randomly
array=(`cut -f1 $file | shuf -n $num`) 
#length=${#array[@]}		
#NOTICE: if use multiple variable with same name, bug come!!!
for ((i=0; i<$num; i++))
do
	f ${array[$i]}
	sleep `expr 5 + $RANDOM % 30`		#wait in random-time, to avoid ip-forbidden
done

#echo -e "An apple a day keeps away \a\t\tdoctor\n"
#echo "ERROR!" 1>&2		#redirect stdout to stderr, use &num or filename
#cat < /usr/share/dict/words |xargs 

