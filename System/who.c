/*=============================================================================
# Filename: who.c
# Author: syzz
# Mail: 1181955272@qq.com
# Last Modified: 2015-05-22 20:36
# Description: simulate the action as who do in shell. Read /etc/utmp and list
# info there in; Suppresses empty records; Formats time nicely!
=============================================================================*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <utmp.h>
#include <fcntl.h>
#include <time.h>

//#define SHOWHOST

void showtime(long);
void show_info(struct utmp*);

//BETTER: use cache!!!

int
main(int argc, const char* argv[])
{
	struct utmp utbuf;					//read into here
	int utmpfd;							//read from this descriptor
	if((utmpfd = open(UTMP_FILE, O_RDONLY)) == -1)
	{
		perror(UTMP_FILE);
		exit(1);
	}
	while(read(utmpfd, &utbuf, sizeof(utbuf)) == sizeof(utbuf))
	{
		show_info(&utbuf);
	}
	close(utmpfd);
	return 0;
}

//display the contents of the utmp struct in human readable form
//display nothing if record has no user name
void
show_info(struct utmp* utbufp)
{
	if(utbufp->ut_type != USER_PROCESS)
		return;
	printf("%-8.8s", utbufp->ut_name);	//the login name
	printf(" ");
	printf("%-8.8s", utbufp->ut_line);	//the tty
	printf(" ");
	showtime(utbufp->ut_time);			//display time
#ifdef SHOWHOST
	if(utbufp->ut_host[0] != '\0')
		printf("(%s)", utbufp->ut_host);//the host
#endif
	printf("\n");
}

//display time in a format fit for human consumption
//use ctime to build a string then picks parts out of it
//Note: %12.12s prints a string 12 chars wide and limited to 12 chars
void
showtime(long timeval)
{
	char* cp;							//to hold address of time
	cp = ctime(&timeval);				//convert time to string
	//string looks like Mon Feb 4 00:46:40 EST 1991
	//0123456789012345
	printf("%12.12s", cp+4);			//pick 12 chars from pos 4
}
	
