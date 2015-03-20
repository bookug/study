#! /bin/bash -
#to draw all kinds of shape in the screen

function drawBox()		#left, top, bottom, right
{
	echo TODO;			#use 11m? alt + 178
}

#a=`expr $1 + $4`;
#b=`expr $2 + $3`;
#$1:left $2:top $3:height $4:width
#drawBox $1 $2 $a $b;

#echo -e "\033[5;10H Hello";
#press alt + 178
#echo -e "\033[11m"
#press alt + 178
#echo -e "\033[0m"
#press alt + 178

char=( 6a 6b 6c 6d 6e 71 74 75 76 77 78 )
for i in ${char[*]}
do
	printf "0x$i \x$i \e(0\x$i\e(B\n"
done
