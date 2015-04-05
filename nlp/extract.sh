#! /bin/bash -
#this program is used to remove tags and punctuation in essays in one given folder
#then produce a list of 'words count' for each class

function extract()
{
	`>words.set`
	for file in `ls`
	do
		case $file in
			[0-9]*.essay) 
			sed -i -e '/<[ \t]*ccnc_cat/,/\/ccnc_cat[ \t]*>/d' -e 's/<[^>]*>//g' $file
			sed -i -e 's/[[]{}|\\\/!@#$%\^&\*\.\?-_=+,:;]//g' $file 
			sed -i -e 's/["()（）《》【】？，•·。、…”“：‘；’]//g' $file
			cat $file >> words.set
			echo "$file is extracted!";;
			*);;
		esac
	done
}

DIR=$1
if [ ! -e $DIR ]
then
	echo 'This directory does not exist!'
	exit 1
fi

if [ -f $DIR ]
then
	echo 'It should not be a file!'
	exit 1
fi

cd $DIR
for dir in `ls`
do
	if [ -d $dir ]
	then
		cd $dir
		extract
		`>words.list`
		#BETTER: IDF and relative frequency
		awk '{for(i=1;i<=NF;i++) count[$i]++;};
		END{
		for(j in count) {print j,count[j] | "sort -r -n -k2";}
		}' words.set | head -100 >> words.list
		cd ..
	fi
done


