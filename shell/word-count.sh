#! /bin/bash -
#this program is used to finish homework 2.1
#goto any 10 links in a english-web-page, and count out the top 1000 frequent words

function work()
{		#download web-page and count words-num
	echo "you are a lucky dog!"	
}

wget http://en.wikipedia.org/wiki/Main_Page -O data/wiki.html
#
 awk '/href/{print $0}' data/wiki.html | grep -o "href=\"[^\"]*\"" | shuf -n 10 | awk -F '=' '{print $2};' | sed -e 's/"//g' -e 's/^\/*//' -e 's/^/en.wikipedia.org\//'

