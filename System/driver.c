/*=============================================================================
# Filename: driver.c
# Author: syzz
# Mail: 1181955272@qq.com
# Last Modified: 2015-05-14 00:28
# Description: 
=============================================================================*/

#include <stdio.h>
#include <ctype.h>

void 
rotate()		//map a->b b->c ... z->a
{				//useful for showing tty modes
	int c;
	while((c = getchar()) != EOF)
	{
		if(c == 'z')
			c = 'a';
		else if(islower(c))
			c++;
		putchar(c);
	}
}


int 
main(int argc, const char* argv[])
{
	rotate();

	return 0;
}

