#! /bin/bash -
#display colors and other specials

echo -e "\033[34m   Hello Colorful  World!";	#-e indicates \ should be specialized
sleep 1;
echo -e "\033[0q Turning all kbd -LED lights off"; 
echo  "* * * Press CTRL + C to stop";
echo -e "\033[1q Scroll On Other Off";
sleep 1;
echo -e "\033[2q Num On Other Off"; 
sleep 1;
echo -e "\033[3q Caps On Other Off";  
sleep 1;

echo -e "\033[1m BOLD"
echo -e "\033[7m Background White Forground Black(reverse video)" 
echo -e "\033[5m Blink"
echo -e "\033[0m Normal"
echo  "30-37 Forground Color value as follows"
echo -e "\033[30m 30 - BLACK (Can U See?-)"
echo -e "\033[31;43m 31 - Red "
echo -e "\033[32m 32 - Green"
echo -e "\033[33m 33 - Brown"
echo -e "\033[34m 34 - Blue"
echo -e "\033[35m 35 - Magenta"
echo -e "\033[36m 36 - Cyan"
echo -e "\033[37m 37 - Gray"
echo -e "\033[38m Dark Gray"
echo -e "\033[39m Bright Red"
echo "40-47 Specifyes background Color value as follows (With default forgound color value)"
echo -e "\033[42m 42 - WOW!!!"
echo -e "\033[44m 44 - WOW!!!"
echo -e "\033[45m 45 - WOW!!!"
echo -e "\033[49m Back to Original (Use deafault background color)"

echo "Digital Clock for Linux"
echo "To stop this clock use command kill pid, see above for pid"
echo "Press a key to continue. . ."
while :
do
	ti=`date +"%r"`      
	echo -e -n "\033[7s"    #save current screen postion & attributes
	# Show the clock
	tput cup 0 69          # row 0 and column 69 is used to show clock
	echo -n $ti            # put clock on screen
	echo -e -n "\033[8u"   #restore current screen postion & attributs
	#Delay fro 1 second
	sleep 1
done
