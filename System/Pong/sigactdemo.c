/*=============================================================================
# Filename: sigactdemo.c
# Author: syzz
# Mail: 1181955272@qq.com
# Last Modified: 2015-06-08 15:13
# Description: show use of sigaction()
blocks ^\ while handling ^C;does not reset ^C handler, so two kill
=============================================================================*/

#include <stdio.h>
#include <signal.h>

#define INPUTLEN 100

int
main(int argc, const char* argv[])
{
	struct sigaction newhandler;
	sigset_t blocked;
	void inthandler(int);
	char input[INPUTLEN];

	//load these two members firstly
	newhandler.sa_handler = inthandler;
	newhandler.sa_flags = SA_RESETHAND | SA_RESTART;
	//build the list of blocked signals
	sigemptyset(&blocked);				//clear all bits
	sigaddset(&blocked, SIGQUIT);	
	newhandler.sa_mask = blocked;		//store blockmask

	if(sigaction(SIGINT, &newhandler, NULL) == -1)
		perror("sigaction");
	else
	{
		while(1)
		{
			fgets(input, INPUTLEN, stdin);
			printf("input: %s\n", input);
		}
	}
	return 0;
}

void inthandler(int s)
{
	printf("Called with signal %d\n", s);
	sleep(s);
	printf("done handling signal %d\n", s);
}

