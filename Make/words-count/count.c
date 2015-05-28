/*=============================================================================
# Filename: count.c
# Author: syzz
# Mail: 1181955272@qq.com
# Last Modified: 2015-05-27 01:00
# Description: count specific words num in file, using flex
=============================================================================*/

#include <stdio.h>

extern int fee_count;
extern int fie_count, foe_count, fum_count;
extern int yylex();

int
main(int argc, const char* argv[])
{
	yylex();
	printf("%u %u %u %u \n", fee_count, fie_count, foe_count, fum_count);

	return 0;
}

