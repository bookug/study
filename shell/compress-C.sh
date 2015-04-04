#! /bin/bash -
#this program is used to finish homework 2.2
#given a C source code, compress it: to remove comments, remove unnecessary spaces, reduce 
#blank lines.
#Notice: C source code's ability must be reserved!
#NOTICE: delete the \ tag in C: not use \ in comments!
#NOTICE: comments symbol in quotes will not be considered, because it's rare and
#not simple to deal!

function remove_comments_file() 
{	#the operation order is important! 
	#use -i to operate in file itself
	#remove the comment line begin with '//comment' 
	sed -i '/^[ \t]*\/\//d' $file	
	#remove the comment line end with '//comment' 
	sed -i 's/\/\/.*//' $file		
	#remove the comment only occupied one line  
	sed -i 's/\/\*.*\*\///' $file 
	#remove the comment that occupied many lines 
	sed -i '/^.*\/\*/,/.*\*\//{//!d}' $file		#remove lines between
	sed -i 's/\/\*.*//' $file					#remove content/*.....
	sed -i 's/.*\*\///' $file					#remove ...*/content
	#remove all blank lines, not all '\n'
	sed -i '/^$/d' $file
	#remove unnecessary spaces
	sed -i 's/^[ \t]*//' $file
	sed -i 's/[ \t]*$//' $file
	sed -i 's/[ \t]\{2,\}/ /g' $file			#one \t will remain, only 1-byte as space
} 

function remove_comments_directory() 
{ 
	for file in `ls`
	do 
		case $file in 
			*.c) remove_comments_file;; 
			*.cpp) remove_comments_file;; 
			*.h) remove_comments_file;;
			*)									#if directory then recurse, otherwise error
			if [ -d $file ]
			then 
				cd $file	
				remove_comments_directory
				cd .. 
			else
				echo "file type is not supported"
				#exit 1
			fi 
		esac 
	done 
} 

#acquire the file or directory 
DIR=$1 
if [ ! -e $DIR ]	
then 
	echo 'The file or directory does not exist.' 
	exit 1 
fi 

if [ -f $DIR ]								#it is a file
then 
	file=`basename $DIR`					#strip the directory from filename
	#echo $file
	if [[ `echo $DIR | grep /` == $DIR ]]	#user assigns the path
	then									#goto the exact directory
		cd `echo $DIR | sed 's/'$file'//'`	#$file must be quoted here
		remove_comments_file 
	else 
		remove_comments_file 
	fi 
	exit 0; 
fi 

if [ -d $DIR ]								#it is a directory
then
	cd $DIR									#open and deal in directory
	remove_comments_directory 
	exit 0; 
fi

