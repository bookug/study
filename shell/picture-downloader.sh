#! /bin/bash -
#to download pictures from a site, requiring delete the background, maybe more...

#if [ $# -ne 3 ]
#then
#	echo "Usage: $0 URL -d DIRECTORY"
#	exit 1
#fi
#for i in {1..3}
#do
#	case $1 in
#		-d) shift; directory=$1;shift;;
#		*) url=${url:-$1};shift;;
#	esac
#done
#mkdir -p $directory
#baseurl=$(echo $url | egrep -o "https?://[a-z.]+")		
#echo "$baseurl"		
#curl -s $url | egrep -o "<img src=[^>]*>" | sed 's/<img src=\"\([^"]*\).*/\1/g' > /tmp/$$.list
#sed -i "s|^/|$baseurl/|" /tmp/$$.list
#cd $directory
#while read filename
#do
#	curl -s -O "$filename" --silent
#done < /tmp/$$.list

function error()
{
	echo "ERROR: invalid arguments"
	echo "USAGE: $0 [url]"
	exit 1
}

echo "Please ensure that you have installed ImageMagick!"
url="http://e.hiphotos.baidu.com/image/pic/item/aa18972bd40735fa12b197be9c510fb30f240870.jpg"
if [ $# -eq 1 ]		#user assign the url
then
	url=$1
elif [ $# -ne 0 ]	
then
	error
fi					#if not assigned, url is by default
wget $url -O data/src.jpg
str=`cd data;identify src.jpg`
width=690		#TODO: to extract width and height
height=451
`cd data;convert src.jpg -gravity center -crop 400x400+100+0 dest.jpg`
#more function to add: -shade...
echo "The original picture is src.jpg, while the modified one is called dest.jpg"
echo "Both pictures are placed in data folder"

