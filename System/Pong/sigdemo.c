/*=============================================================================
# Filename:		sigdemo.c
# Author: syzz
# Mail: 1181955272@qq.com
# Last Modified:	2015-06-07 22:54
# Description: show answers to signal questions
1. does the handler stay in effect after a signal arrives?
2. what if a signalX arrives while handling signalX?
3. what if a signalX arrives while handling signalY?
4. what happens to read() when a signal arrives?
=============================================================================*/

#include <stdio.h>
#include <signal.h>

#define INPUTLEN 100

int
main(int argc, const char* argv[])
{
	void inthandler(int);
	void quithandler(int);
	char input[INPUTLEN];
	int nchars;
	signal(SIGINT, inthandler);
	signal(SIGQUIT, quithandler);

	do
	{
		printf("\nType a message\n");
		if(nchars == -1)
			perror("read returned an error");
		else
		{
			input[nchars] = '\0';
			printf("You typed: %s", input);
		}
	}while(strncmp(input, "quit", 4) != 0);

	return 0;
}

void 
inthandler(int s)
{
	printf("Received signal %d .. waiting\n", s);
	sleep(2);
	printf("Leaving inthandler\n");
}

void
quithandler(int s)
{
	printf("Received signal %d .. waiting\n", s);
	sleep(3);
	printf("Leaving quithandler\n");
}

