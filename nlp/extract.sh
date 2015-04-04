#! /bin/bash -
#this program is used to extract essay-class information, create
#directory, remove tags and punctuation, then mv content to that directory

#TODO: split firstly, create directory, remain only words
sed -e '/<[ \t]*ccnc_cat/,/\/ccnc_cat[ \t]*>/d' -e 's/<[^>]*>//g' -e 's/[\[\]{}|\\\/!@#$%\^&\*\.\?-_=+,:;]//g' -e	's/["()（）《》【】？，•·。、…”“：‘；’]//g' train | less
#~"'
echo "Job Done!"


