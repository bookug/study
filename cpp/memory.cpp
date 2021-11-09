/*
 * =====================================================================================
 *
 *       Filename:  memory.cpp
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  2018年10月24日 22时26分52秒
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  bookug (), bookug@qq.com
 *   Organization:  
 *
 * =====================================================================================
 */
#include <stdlib.h>
#include <malloc.h>
#include <iostream>

using namespace std;

//Use Valgrind if memory is enough!
//(please add -g for compilation)

int main()
{
    //NOTICE: int a[1000000] on stack is invalid, but in machines with huge machines it will not report errors
    int a[100];
    //    free(a);
    int* b = new int[1000];
    //    mismatched memory allocation/recycle
    //    free(b);
    //    mismatched memory allocation/recycle
    //    delete b;
    int* c = b + 10;
    //invalid
    //    delete[] c;
    delete[] b;

    //NOTICE: this is huge, but it uses mmap if you use strace to watch, which means these memory is consumed only when used
    int* p = (int*)malloc(sizeof(int) * 10000000000L);
    cout << "check: " << p << endl;
    //    p[200000] = 1;
    for (long i = 0; i < 10000000000L; ++i) {
        p[i] = i + 1L;
    }
    //invalid
    //    free(p+100);
    //this is ok, nothing happens, so a good habbit is to set pointer to NULLafter releasing it
    free(NULL);

    //Question: is the heap memory recycled when the program ends? if the programmer does not release it in the program?
    //Theoretically, there has no guarantee that the system will recycle the missing heap memory, so programmers should take care of it by themselves(except some languages with garbage collection, but GC will cause low memory utilization)
    //However, in practice we find that the missing memory will be recycled immediately after the program ends, when we watch the output of free -h
    //Depend on systems, most operation systems will recycle the missing heap memory of the program
    //Linux does, because it will destroy the virtual memory of the process, but not the memory leak in kernel module!
    //some real-time systems not do this recycling
    //https://blog.csdn.net/libinjlu/article/details/54865887?utm_source=blogxgwz2
    cout << "byebye" << endl;
    getchar();

    return 0;
}
