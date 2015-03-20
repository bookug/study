#########################################################################
# File Name: start.sh
# Author: syzz 
# mail: 1181955272@qq.com 
# Created Time: Mon 16 Mar 2015 03:46:21 PM CST
#########################################################################
#!/bin/bash
#This is my first shell program

#You must want to know how to debug shell-scripts
#Here are three ways for you：
#1. in command-line: bash -x script.sh
#2. in shell-script: set -x ... set +x
#3. in shell-script: 
#log()
#{
#	if [ "$DEBUG" = "true" ]; then
#	echo "debug information"
#	fi
#}
#and control the DEBUG in command-line

#test if the given file exists
#if [ -f $1 ]
#then
#	echo "$1 file exist"
#else
#	echo "Sorry, $1 file does not exist"
#fi
