/*=============================================================================
# Filename: lock.cu
# Author: bookug 
# Mail: bookug@qq.com
# Last Modified: 2019-07-08 22:40
# Description: The implementation of lock mechanism in CUDA.
A straightfoward application is the frontier queue used in BFS/SSSP.
=============================================================================*/

#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include<math_functions.h>
#include<time.h>
#include<cuda.h>
#include<cuda_runtime.h>

// number of blocks
#define nob 10

struct Lock
{
    int *mutex;
    Lock(void){
        int state = 0;
        cudaMalloc((void**) &mutex, sizeof(int));
        cudaMemcpy(mutex, &state, sizeof(int), cudaMemcpyHostToDevice);
    }
    ~Lock(void){
        cudaFree(mutex);
    }
    __device__ void lock(uint compare)
    {
        while(atomicCAS(mutex, compare, 0xFFFFFFFF) != compare);    //0xFFFFFFFF is just a very large number. The point is no block index can be this big (currently).
    }
    __device__ void unlock(uint val)
    {
        atomicExch(mutex, val+1);
    }
};

__global__ void 
theKernel(Lock myLock)
{
    int index = blockIdx.x; //using only one thread per block
    // execute some parallel code
    // critical section of code (thread with index=0 needs to start, followed by index=1, etc.)
    myLock.lock(index);
    printf("Thread with index=%i inside critical section now...\n", index);
    __threadfence_system();   // For the printf. I'm not sure __threadfence_system() can guarantee the order for calls to printf().
    myLock.unlock(index);
}

int 
main(void)
{
    Lock myLock;
    theKernel<<<nob, 1>>>(myLock);
    return 0;
}

