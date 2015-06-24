/*=============================================================================
# Filename: more.c
# Author: syzz
# Mail: 1181955272@qq.com
# Last Modified: 2015-05-22 13:20
# Description: simulate the action as more in shell
=============================================================================*/

/*
 * read and print 24 lines then pause for a few special commands 
 * feature: reads from /dev/tty for commands
 * TODO: more? will also scroll! percentage? no buffer? no echo?
 */

#include <stdio.h>
#include <stdlib.h>

#define PAGELEN 24
#define LINELEN 512

void do_more(FILE* _fp);
int see_more(FILE* _fp);

int
main(int argc, const char* argv[])
{
	FILE* fp;
	if(argc == 1)
		do_more(stdin);
	else
		while(--argc)
			if((fp = fopen(*++argv, "r")) != NULL)
			{
				do_more(fp);
				fclose(fp);
			}
			else
				exit(1);
	return 0;
}

//read PAGELEN lines, then call see_more() for further instructions
void
do_more(FILE* _fp)
{
	char line[LINELEN]	;
	int num_of_lines = 0;
	int see_more(FILE* _fp), reply;
	FILE* fp_tty;
	fp_tty = fopen("/dev/tty", "r");	//NEW: cmd stream 
	if(fp_tty == NULL)					//open fails
		exit(1);						//no use in running
	while(fgets(line, LINELEN, _fp))		//more input
	{
		if(num_of_lines == PAGELEN)		//full screen?
		{
			reply = see_more(fp_tty);	//NEW: pass FILE
			if(reply == 0)				//n: done
				break;
			num_of_lines -= reply;		//reset count
		}
		if(fputs(line, stdout) == EOF)	//show line
			exit(1);					//or die
		num_of_lines++;
	}
}

//print message, wait for response, return # of lines to advance
//q means no, space means yes, CR means one line
int 
see_more(FILE* _cmd)					//NEW: accepts arg
{
	int c;
	printf("\033[7m more? \033[m");		//reverse on a vt100
	while((c = getc(_cmd)) != EOF)		//NEW: reads from tty
	{
		if(c == 'q')					//q->N
			return 0;
		if(c == ' ')					//' '->next page
			return PAGELEN;
		if(c == '\n')					//Enter key => 1 line
			return 1;
	}
	return 0;
}

