/*=============================================================================
# Filename: logout.c
# Author: syzz
# Mail: 1181955272@qq.com
# Last Modified: 2015-05-23 11:59
# Description: actions when a user log out
=============================================================================*/

#include <stdio.h>
#include <stdlib.h>

//mark a utmp record as logged out
//dose not blank username or remote host
//return -1 on error, 0 on success
int 
logout_tty(char* line)
{
	int fd;
	struct utmp rec;
	int len = sizeof(struct utmp);
	int retval = -1;							//pessimism
	if((fd = open(UTMP_FILE, O_RDWR)) == -1)	//open file
		return -1;
	//search and replace
	while(read(fd, &rec, len) == len)
		if(strncmp(rec.ut_line, line, sizeof(rec.ut_line)) == 0)
		{
			rec.ut_type = DEAD_PROCESS;
			if(time(&rec.ut_time != -1))
				if(lseek(fd, -len, SEEK_CUR) != -1)
					if(write(fd, &rec, len) == len)
						retval = 0;
			break;
		}
	if(close(fd) == -1)
		retval = -1;
	return retval;
}

int
main(int argc, const char* argv[])
{
	return 0;
}

