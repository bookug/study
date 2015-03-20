#! /bin/bash -
#this program is used to finish the first homework

function random()
{		#if not return explictly, using the last expression-value as ret
	t=`expr $2 - $1`;
	t=`expr $RANDOM % $t`;
	t=`expr $1 + $t`;	
	return $t;		#use $? to get the return-value
}

function f()	#deal and download the according voice
{
	wget http://iciba.com/$1.html;
	#url=""；	#how to find
	#wget $url;	#if indicate directory?
	#rm -f $1.html
}

array=(`cut -f1 /usr/share/dict/words | shuf -n 5`) #maybe 100 can be argument
length=${#array[@]}
for ((i=0; i<$length; i++))
do
	f ${array[$i]}
	sleep 1		#to avoid ip-forbidden
done
#echo -e "An apple a day keeps away \a\t\tdoctor\n"
#echo "ERROR!" 1>&2		#redirect stdout to stderr, use &num or filename
#cat < /usr/share/dict/words |xargs 

