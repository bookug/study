/*=============================================================================
# Filename: restrict.cpp
# Author: bookug 
# Mail: bookug@qq.com
# Last Modified: 2018-10-25 00:06
# Description: 
This program must be compiled using -std=c99 option!
command line option ‘-std=c99’ is valid for C/ObjC but not for C++
However, restrict can onlt be supported from C99, so it can not be used in C++ source file
http://bdxnote.blog.163.com/blog/static/84442352010017185053/
=============================================================================*/

#include <stdlib.h>
#include <stdio.h> 

//we need to watch assembly code to see the difference and we need to use -O2 or not to see the reduction of assembly code in these two functions
//use gcc -S or objdump -dS a.out
//https://www.cnblogs.com/justin-y-lin/p/5599217.html
//https://blog.csdn.net/zoomdy/article/details/50563680

int test_compiler(int* x, int* y)
{
    *x = 0;
    *y = 1;
    //In most cases this will return 0, but if x==y it will return 1
    //As a result, compiler can not optimize it
    return *x;
}

int test_restrict(int* restrict x, int* restrict y)
{
    *x = 0;
    *y = 1;
    //In most cases this will return 0, but if x==y it will return 1
    //As a result, compiler can not optimize it
    return *x;
}

int main()
{
    printf("use of restrict\n");

    return 0;
}

