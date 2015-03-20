#! /bin/bash -
# operations about pipe and re-direction

tr -d '\r' < dos-file.txt > unix-file.txt

for f in dos-file*.txt
do
	tr -d '\r' < $f >> big-unix-file.txt
done

tr -d '\r' < dos-file.txt | sort > unix-file.txt

if grep pattern myfile > /dev/null #not use output
then
	printf "found";
else
	printf "not found";
fi

printf "Enter new password: "
stty -echo		#not print characters input automaticly
read pass1 < /dev/tty
printf "\nEnter again: "
read pass2 < /dev/tty
printf "\n"
stty echo		#remember to open
