#! /bin/bash -
#this script is used to create direectory for class, and divide essays into them accordingly
#each class will have one folder named by its id, as well as each essay


if [ $# -ne 2 ]
then
	echo "Invalid arguments list"
	echo "USAGE: $0 file directory"
fi

sed -i '/<[ \t]*\/doc[ \t]*>/d' $1
#TODO: remove spaces in quotes, or use two docid to match two lines
while [ 1 ]
do
	str=`grep -m1 "<[ \t]*cat" $1`
	echo $str
	if [ ! "$str" ]			# "$str" X$str = "X" -z $str
	then
		exit 0
	fi
	class=`echo $str | sed -e 's/<[^<>]*>//g' -e 's/[ \t]//g'`
	echo $class
	docid1=`grep -m1 "<[ \t]*doc" $1 | grep -o "\"[ \t0-9]*\"" | sed 's/[\"]//g'`
	echo $docid1
	docid2=`echo $str | grep -o "\"[ \t0-9]*\"" | sed 's/[\"]//g'`
	echo $docid2
	puredocid=`echo $docid2 | sed 's/[ \t]//g'`
	if [ ! -e $2 ]
	then
		echo "$2 does not esist!"
		exit 1
	elif [ ! -d $2 ]
	then
		echo "$2 is not a directory!"
		exit 1
	fi

	cd $2
	if [ ! -e $class ]
	then
		mkdir $class
	fi
	cd ..
	#use docid to locate
	sed -n "/\"[ \t]*$docid1[ \t]*\"/,/\"[ \t]*$docid2[ \t]*\"/p" $1 > "$puredocid".essay
	sed -i "/\"[ \t]*$docid1[ \t]*\"/,/\"[ \t]*$docid2[ \t]*\"/d" $1 
	mv "$puredocid".essay "$2"/"$class"/
done


