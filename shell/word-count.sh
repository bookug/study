#! /bin/bash -
#this program is used to finish homework 2.1
#goto any 10 links in a english-web-page, and count out the top 1000 frequent words

function work()
{	#download web-page and count words-num
	wget $1 -O data/web.tmp
	#remove all tags, reduce spaces
	sed -i -e '/<[ \t]*!--/,/--[ \t]*>/d' -e '/<[ \t]*script[^>]*>/, /<[ \t]*\/script[ \t]*>/d' -e '/{/,/}/d' -e '/[{}]/d' -e 's/<[^>]*>//g' -e 's/\t/ /g;s/ \{2,\}/ /g' data/web.tmp
	#to delete num and all kinds of punctuation, maybe others
	#sed -i -e 's/[-_+!%|\*$@0-9()\^&#",\.:;\\\/•·– =\?[]]//g' data/web.tmp
	sed -i -e 's/[^ a-zA-Z]//g' data/web.tmp
	#add all these words 
	cat data/web.tmp >> data/words.tmp
}

#empty this file for later usage
`> data/words.tmp`
wget http://en.wikipedia.org/wiki/Main_Page -O data/wiki.html
#extract the url, remove ", adjust the leading /, add prefix when needed
 awk '/href/{print $0}' data/wiki.html | grep -o "href=\"[^\"]*\"" | shuf -n 10 | awk -F '=' '{print $2};' | sed -e 's/"//g' -e 's/^\/*//' | sed -e '/^.*\.org/!s/^/en.wikipedia.org\//' > data/url.tmp
for i in `cat data/url.tmp`
do
	echo $i
	work $i
done
#sort and print
#NOTICE: sort should be quoted, and two printed columns should be divided by ,
awk '{for(i=1;i<=NF;i++) count[$i]++;};END{for(j in count){print j,count[j] | "sort -r -n -k2";}}' data/words.tmp | head -1000


