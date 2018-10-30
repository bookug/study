/*=============================================================================
# Filename: memory.cu
# Author: bookug 
# Mail: bookug@qq.com
# Last Modified: 2018-10-24 01:07
# Description: 
warp operations are very fast and important because threads in a warp are naturally synchronized
束表决函数：简单的理解就是在一个warp内进行表决
__all(int predicate)：指的是predicate与0进行比较，如果当前线程所在的Wrap所有线程对应predicate不为0，则返回1。
__any(int predicate)：指的是predicate与0进行比较，如果当前线程所在的Wrap有一个线程对应的predicate值不为0，则返回1。
__ballot(int predicate)：指的是当前线程所在的Wrap中第N个线程对应的predicate值不为0，则将整数0的第N位进行置位。

//__shfl __shfl_up  ...
//https://blog.csdn.net/bruce_0712/article/details/64926471
//NOTICE: in __shfl_up or other functions, the thread not in range will receive itself!!!

置位可以用或操作符“|”实现：y = x | (1 << n)  对x的第n位进行置位
清楚可以用与操作符”&“实现：y = x & (~(1 << n))
取反可以用异或操作符”^“实现： y = x ^ (1 << n)
Bit提取操作： bit = (x & (1 << n)) >> n

如何判断一个数是否为2的整数次幂   x & (x-1) == 0
如何提取一个数的最低位的1     x & (-x)
已知一个数是2的幂，如何提取幂次    可以使用log，有更好的方法么？
C语言的log函数耗时钟周期多，且取的是自然对数，要取以2为底的对数还得转化。(or use log2 function)
一种比较好的方式是右移位运算，做二分查找，最多只需五次
=============================================================================*/

#include <stdio.h>
#include <cuda.h> 
#include <cuda_runtime.h> 
#include <cuda_runtime_api.h> 
#include <cassert>
#include <curand.h> 

#include "Util.h" 

using namespace std;

#define checkCudaErrors(val) check( (val), #val, __FILE__, __LINE__)
#define ERROR_EXIT -1
#define NUM_BLOCKS 1
#define BLOCK_WIDTH 32

template<typename T>
void check(T err, const char* const func, const char* const file, const int line) {
  if (err != cudaSuccess) {
    printf("CUDA error at: %s:%d\n", file, line);
    printf("%s %s\n", cudaGetErrorString(err), func);
    exit(1);
  }
}
/* Check the return value of CUDA Runtime API */
#define CHECK_CUDA(err) do{\
    if((err) != cudaSuccess){\
            fprintf(stderr, "CUDA Runtime API error %d at file %s line %d: %s.\n",\
                                                   (int)(err), __FILE__, __LINE__, cudaGetErrorString((err)));\
            exit(ERROR_EXIT);\
        }}while(0)

/* Check the return value of CURAND api. */
#define CHECK_CURAND(err) do{\
    if( (err) != CURAND_STATUS_SUCCESS  ){\
            fprintf(stderr, "CURAND error %d at file %s line %d.\n", (int)(err), __FILE__, __LINE__);\
        exit(ERROR_EXIT);\
        }}while(0)

void initGPU(int dev)
{
    int deviceCount;
    cudaGetDeviceCount(&deviceCount);
    if (deviceCount == 0) {
        fprintf(stderr, "error: no devices supporting CUDA.\n");
        exit(EXIT_FAILURE);
    }
    cudaSetDevice(dev);
	//NOTE: 48KB shared memory per block, 1024 threads per block, 30 SMs and 128 cores per SM
    cudaDeviceProp devProps;
    if (cudaGetDeviceProperties(&devProps, dev) == 0)
    {
        printf("Using device %d:\n", dev);
        printf("%s; global mem: %luB; compute v%d.%d; clock: %d kHz; shared mem: %dB; block threads: %d; SM count: %d\n",
               devProps.name, devProps.totalGlobalMem, 
               (int)devProps.major, (int)devProps.minor, 
               (int)devProps.clockRate,
			   devProps.sharedMemPerBlock, devProps.maxThreadsPerBlock, devProps.multiProcessorCount);
    }
	cout<<"GPU selected"<<endl;
	//GPU initialization needs several seconds, so we do it first and only once
	//https://devtalk.nvidia.com/default/topic/392429/first-cudamalloc-takes-long-time-/
	int* warmup = NULL;
	/*unsigned long bigg = 0x7fffffff;*/
	/*cudaMalloc(&warmup, bigg);*/
	/*cout<<"warmup malloc"<<endl;*/
	cudaMalloc(&warmup, sizeof(int));
	cudaFree(warmup);
	cout<<"GPU warmup finished"<<endl;
	unsigned long size = 0x7fffffff;
	/*size *= 3;   //heap corruption for 3 and 4*/
	size *= 2;
    //NOTICE: it is ok to expand the heap memory capacity to 8G if using long type
    //However, it is not suggested because the remaining memory is too small
    //In fact, the program not ends if using 8G heap memory
    //Once you set the memory limit, then you will see the limit occupation if using nvidia-smi command to see, but it not really occupy so much at once
    /*size *= 2;*/
	//NOTICE: the memory alloced by cudaMalloc is different from the GPU heap(for new/malloc in kernel functions)
	cudaDeviceSetLimit(cudaLimitMallocHeapSize, size);
	cudaDeviceGetLimit(&size, cudaLimitMallocHeapSize);
	cout<<"check heap limit: "<<size<<endl;

	// Runtime API
	// cudaFuncCachePreferShared: shared memory is 48 KB
	// cudaFuncCachePreferEqual: shared memory is 32 KB
	// cudaFuncCachePreferL1: shared memory is 16 KB
	// cudaFuncCachePreferNone: no preference
	/*cudaFuncSetCacheConfig(MyKernel, cudaFuncCachePreferShared)*/
	//The initial configuration is 48 KB of shared memory and 16 KB of L1 cache
	//The maximum L2 cache size is 3 MB.
	//also 48 KB read-only cache: if accessed via texture/surface memory, also called texture cache;
	//or use _ldg() or const __restrict__
	//64KB constant memory, ? KB texture memory. cache size?
	//CPU的L1 cache是根据时间和空间局部性做出的优化，但是GPU的L1仅仅被设计成针对空间局部性而不包括时间局部性。频繁的获取L1不会导致某些数据驻留在cache中，只要下次用不到，直接删。
	//L1 cache line 128B, L2 cache line 32B, notice that load is cached while store not
	//mmeory read/write is in unit of a cache line
	//the word size of GPU is 32 bits
}

__global__ void warp_kernel()
{
    __shared__ int vote;
    //this is also called a lane
    int idx = threadIdx.x & 0x1f;
    //USAGE: the function of vote control can be easily implemented
    vote = idx;
    __syncthreads();
    //NOTICE: bit operations are suggested instead of / and %, which are really costly
    int warp = threadIdx.x >> 5;
    if(idx == 0)
    {
        printf("thread %d control the warp %d\n", vote, warp);
    }

    //NOTICE: the return value of __ballot, __any, __all
    int flag = 0;
    if(idx < 15)
    {
        flag = 3;
    }
    int check = __shfl_up(flag, 4);
    //NOTICE: it is not safe for thread 0 because it will receive 3 as result, not the former 4-th one
    //because 0-4 is out of bound, so it will use the value of itself instead
    if(idx == 0)
    {
        printf("check: %d\n", check);
    }
    int t1 = __any(flag);
    int t2 = __all(flag);
    unsigned t3 = __ballot(flag);
    //WARN: thsi may cause problem, the return value of __ballot may be 1<<31, i.e. 2147483648 which exceeds the maximum integer value
    /*int t3 = __ballot(flag);*/

    if(idx == 0)
    {
        printf("check: %d %d %u\n",t1, t2, t3);
        //logarithmic function may be not accurate and can cause problem
        int x = log2((double)16777216);  //this is wrong, it should be 24, but it outputs 23
        /*int x = log2((double)1);  // this is right, 0*/
        printf("x: %d\n", x);
    }

    //use shfl to do warp prefix-scan
    int val = 0;
    if(idx == 0 || idx == 7 || (idx>1 &&idx<6))
    {
        val = 1;
    }
    unsigned size = 8;
    //no need to use 32 here, we can stop when we count what we need
    for(unsigned stride = 1; stride <= size; stride<<=1)
    {
        //WARN: this logic is wrong because the 0-th thread will not send its value to the 1-th thread
        /*if(idx >= stride)*/
        /*{*/
            /*int tmp = __shfl_up(val, stride, 32);*/
            /*val += tmp;*/
        /*}*/
        int tmp = __shfl_up(val, stride);
        //NOTICE: for prefix we must do this judgement, but no need for reduce-sum
        if(idx >= stride)
        {
            val += tmp;
        }
    }
}

int main(int argc, const char* argv[])
{
	int dev = 0;
	if(argc == 2)
	{
		dev = atoi(argv[1]);
	}
    initGPU(dev);

    //this should be -2,  x的补码是-x，等于反码加1，所以负数在计算机中可以直接用补码表示，因此得到统一
    cout<<~1<<endl;
    unsigned tmp = false;
    cout<<tmp<<endl;
    tmp = true;
    cout<<tmp<<endl;

    long t1 = Util::get_cur_time();

    warp_kernel<<<NUM_BLOCKS, BLOCK_WIDTH>>>();
	//force the printf()s to flush
	cudaDeviceSynchronize();
	//Below checks if the kernel runs and ends successfully
	checkCudaErrors(cudaGetLastError());

    long t2 = Util::get_cur_time();
    printf("warp_kernel used %lu ms\n", t2 - t1);

	printf("That's all!\n");

	return 0;
}

