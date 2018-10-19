/*
 * =====================================================================================
 *
 *       Filename:  goto.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  2018年10月19日 11时40分35秒
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  bookug (), bookug@qq.com
 *   Organization:  
 *
 * =====================================================================================
 */
#include <stdlib.h>
#include <stdio.h> 

int main()
{
	int i, j, k;
	//NOTICE: goto is not suggested but it can safely jump from multi-level loops
	for(i = 0; i < 100; ++i)
		for(j = 0; j < 100; ++j)
			for(k = 0; k < 100; ++k)
			{
				if(i+j+k == 100)
				{
					goto label;
				}
			}
label: printf("hello, world!\n");
	   printf("%d %d %d\n", i,j,k);

	return 0;
}

