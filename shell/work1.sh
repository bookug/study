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
	wget -P data http://iciba.com/$1;
	str=`grep -m1 -A8 "<span class=\"eg\">" data/$1 | grep -o "asplay('.*\.mp3');"`
	if [ "$str" = "" ]
	then
		echo "Voice Not Found"
	else
		len=`expr ${#str} - 11`				#QUERY:strange here!
		url=`expr substr $str 9 $len`
		echo $url
		wget -P data $url					#QUERY:if indicate directory?
		rm -f data/$1.html
	fi
}

array=(`cut -f1 /usr/share/dict/words | shuf -n $1`) #extract $1 words randomly
#length=${#array[@]}		
#NOTICE: if use multiple variable with same name, bug come!!!
for ((i=0; i<$1; i++))
do
	f ${array[$i]}
	sleep `expr $RANDOM % 3`				#to avoid ip-forbidden
done
#echo -e "An apple a day keeps away \a\t\tdoctor\n"
#echo "ERROR!" 1>&2		#redirect stdout to stderr, use &num or filename
#cat < /usr/share/dict/words |xargs 

