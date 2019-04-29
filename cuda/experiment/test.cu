/*=============================================================================
# Filename: test.cu
# Author: bookug 
# Mail: bookug@qq.com
# Last Modified: 2018-10-24 19:56
# Description: 
This program tests I/O and thread capacity on GPU(using Titan X Pascal)
=============================================================================*/

//WARN: no shared memory configs for Maxwell/Pasacal, no split of L1/shared mem
//https://stackoverflow.com/questions/52305331/how-to-call-cudadevicesetsharedmemconfig-and-cudadevicesetcacheconfig

#include <stdio.h>
#include <cuda.h> 
#include <cuda_runtime.h> 
#include <cuda_runtime_api.h> 
#include <cassert>

#include "Util.h"
using namespace std; 

#define checkCudaErrors(val) check( (val), #val, __FILE__, __LINE__)

template<typename T>
void check(T err, const char* const func, const char* const file, const int line) {
  if (err != cudaSuccess) {
    printf("CUDA error at: %s:%d\n", file, line);
    printf("%s %s\n", cudaGetErrorString(err), func);
    exit(1);
  }
}

//NOTICE: the limit of block number is given by compute/arch capablity
//nvcc -arch=sm_35 will allow block num >= 65536
//https://en.wikipedia.org/wiki/CUDA
//WARN: this setting will cause the kernel function unable to work
//As a result, we should set block num < 65536
/*#define NUM_BLOCKS 65536*/

//this is ok to start
#define NUM_BLOCKS 1000000000

/*#define NUM_BLOCKS 400*/
#define BLOCK_WIDTH 1
/*#define BLOCK_WIDTH 1024*/

//Initially, this function uses 328B constant memory
//(this may include all constant numbers, which will also occupy registers when running)
//If we add more constant variables, this size will grow
__global__ void hello(unsigned* d_data)
{
    __shared__ unsigned duck;
	/*__shared__ int array[128];*/

	/*printf("Hello, world! I am a thread in block %d\n", blockIdx.x);*/

    if(threadIdx.x > 512)
    {
        return;
    }
    //NOTICE: for a block, if some threads has returned, we can still use __syncthreads()
    //However, these threads can not be used to finish works again
    __syncthreads();
    if(threadIdx.x == 0)
    {
        printf("after sync!\n");
    }
    if(threadIdx.x > 512)
    {
        printf("the thread still alive\n");
    }

    //HACK: we can hack the global load/store transaction number/size here
    //Or we can explore the mechanism of register allocation.
    /*unsigned ele = d_data[threadIdx.x];*/
    /*ele = 2 * ele;*/
    /*d_data[threadIdx.x] = ele;*/
    //NOTICE: below requires 4 gst transactions
    /*d_data[threadIdx.x] = 0;*/

    //shared variable does not occupy registers and it does not occupy gld/gst transactions
    duck = 0;

    //To hack the gst write transactions(whether write cache is needed)
    //when only use this instruction in the context, only 6 registers occupied, the same as none instructions
    /*d_data[threadIdx.x] = 0;*/
    //below will add 2 registers for usage, and the gst transactions number+4 (32 bytes once)
    /*d_data[threadIdx.x] = 1;*/

    //test multiple warps write continuously
    int idx = threadIdx.x % 32;
    int group = threadIdx.x / 32;
    //below uses 32 gst transactions (this should be tested using block size 1024)
    //EXPLAIN: though the addresses written by different warps are continuous, these warps may be not run in the same time(although with sync function here)
    /*__syncthreads();*/
    /*if(idx == 0)*/
    /*{*/
        /*//WARN: we should not use sync function here(in judgement) because it will cause deadlock*/
        /*d_data[group] = 0;*/
    /*}*/
    //below uses 4 gst transactions, but they are faster than 4 separated gst transactions
    /*if(group == 0)*/
    /*{*/
        /*d_data[idx] = 0;*/
    /*}*/

    //test if adoptingg 128B mechanism: -Xptxas -dlcm=ca  (close, -dlcm=cg)
    //If with no specification, below needs 8 gld transactions
    /*unsigned ele = d_data[threadIdx.x];   //this single instruction  adds 4 regsiters usage. In real running, registers usage may be more or less*/

    //below test the speed of 128B transactions and 32B transactions
    //nvcc -arch=sm_35 -lcudadevrt -rdc=true -G --ptxas-options=-v -lcurand -Xptxas -dlcm=ca test.cu -o test.exe
    //On titan xp, though L1 cache is used, still 8 gld transactions for a warp
    //nvprof -m gld_transactions -m gst_transactions ./test.exe ans.txt 3>& prof.log
    //On titan xp, though L1 cache is forbidden, still 8 gld transactions for a warp
    unsigned ele;
    //below requires 8 gld transactions
    /*ele = d_data[idx];*/
    //below requires 4 gld transactions
    /*if(idx < 2)*/
    /*{*/
        /*ele = d_data[idx*8];*/
    /*}*/
    //below requires 1 gld transactions
    /*if(idx < 2)*/
    /*{*/
        /*ele = d_data[idx];*/
    /*}*/
    //below requires 2 gld transactions
    /*if(idx < 8)*/
    /*{*/
        /*ele = d_data[idx];*/
    /*}*/
    //below requires 2 gld transactions
    //NOTICE: this claims the fact that each 4 unsigned numbers(16B) requires a gld transaction
    //The 16B size is optimized for scatter read, which is the advantage of read-only cache(texture cache)
    //The constant cache is optimized for broadcasting.
    //
    /*if(idx < 5)*/
    /*{*/
        /*ele = d_data[idx];*/
    /*}*/

    //test the read cahe
    //below uses 16 gld transactions, no read cache for time
    /*ele = d_data[idx];*/
    /*ele = d_data[idx];*/
    //test the write cache
    //below uses 8 gld transactions, no write cache for time
    /*d_data[idx] = 0;*/
    /*d_data[idx] = 0;*/

    //test broadcasting
    //below also uses 4 gld transactions?
    ele = d_data[0];

    //test overlapping
    //below requires 4 transactions, which seems reads of each 4 threads are combined into a small group and small groups may be not executed at the same time
    /*ele = d_data[idx%4];*/

    //test writing to the same address
    //below uses 1 gst transaction
    d_data[0] = 0;

    //TODO:test relations among gld transactions, throughput and efficiency
    //if one 128B read is better then 4 separated 32B reads?
    //TODO: test the transactions when using constant memory instead of registers
    //the speed of 32 threads writing to the same address in shared mem, compared with only one
    //TODO: compare gld and dram transactions
    //TODO: test the efficiency of one thread do a single transaction, save vs not-saved
    //TODO:test the transactions of read/write by memcpy with a single thread
    //TODO:test the speed of CudaMemcpy, memcpy in kernel and multiple threads copying

    //TODO: test the efficiency of load balance among warps(combine the tasks of different warps)
    //TODO: tets the tiem cost of adding unnecessary __syncthreads calls
}

__global__ void
spill_kernel(unsigned* ptr0, unsigned* ptr1)
{
    //https://stackoverflow.com/questions/12167926/forcing-cuda-to-use-register-for-a-variable?answertab=active#tab-top
    int i = threadIdx.x;
    int idx = threadIdx.x % 32;
    int group = threadIdx.x / 32;
    unsigned x = i;
    unsigned y = x * x;
    unsigned z = y * y;
    unsigned p = x + y + z;
    unsigned q = p * p;
    unsigned r = q * q;
    //NOTICE: the compiler will place the below content in local memory
    /*unsigned xxx[30];*/
    unsigned xxx[9];
    xxx[7] = 18;
    unsigned myid = 9;  //this inst not change register and constant memory usage
    unsigned offset = idx * idx;  //this inst adds one register
    unsigned p0 = i;   //this inst not adds register
    //insts below not add registers
    unsigned p1 = i * i;
    unsigned p2 = i * i * i;
    unsigned p3 = group * group;

    unsigned f0 = 100; //no adds
    unsigned f1 = f0 * f0;  //no adds
    //QUERY: if 10 is a boottleneck? later all will be palced in local memory?
}

int main(int argc, const char* argv[])
{
	//NOTICE: this API is out-of-date
	/*cudaPrintfInit(100*NUM_BLOCKS*BLOCK_WIDTH);*/
	size_t io_buffer_size = 0;
	cudaDeviceGetLimit(&io_buffer_size, cudaLimitPrintfFifoSize);
	printf("io buffer size: %u\n", io_buffer_size);   //1M by default
	//NOTICE: no need to assign space for all threads' output, because there are at most 3840 threads running in parallel really
	//The former analysis is wrong!  IO buffer is flushed at the end of kernel execution, so overwriting will occur!
	cudaDeviceSetLimit(cudaLimitPrintfFifoSize, 400*1024*200);
	cudaDeviceGetLimit(&io_buffer_size, cudaLimitPrintfFifoSize);
	printf("io buffer size: %u\n", io_buffer_size);   //1M by default

    unsigned* d_data = NULL;
    cudaMalloc(&d_data, sizeof(unsigned)*32);
    /*hello<<<NUM_BLOCKS, BLOCK_WIDTH>>>();*/
    /*hello<<<1000000000L, 1024>>>();*/
    /*hello<<<1, 32>>>(d_data);*/
    hello<<<1, 1024>>>(d_data);
	//Below checks if the kernel launches successfully
	checkCudaErrors(cudaGetLastError());
	//force the printf()s to flush
	cudaDeviceSynchronize();
	//Below checks if the kernel runs and ends successfully
	checkCudaErrors(cudaGetLastError());
    cudaFree(d_data);

    //test register spill
    unsigned ptr[10];
    spill_kernel<<<1,32>>>(ptr+0, ptr+1);

    //test the latency of small transfer between CPU and GPU
    /*unsigned *h_data[3];*/
    /*cudaMalloc( (void **) &d_data, 3 * sizeof(unsigned));*/
    /*long t1, t2;*/
    /*int limit = 1000, tt=0;*/
    /*for(int i = 0; i < limit; ++i)*/
    /*{*/
        /*t1 = Util::get_cur_time();*/
        /*cudaMemcpy(d_data, h_data, 3 * sizeof(unsigned), cudaMemcpyHostToDevice);*/
        /*t2 = Util::get_cur_time();*/
        /*tt += t2-t1;*/
    /*}*/
    /*printf("transfer 12 bytes 1000 times used: %ld ms\n", tt);*/

	printf("That's all!\n");

	return 0;
}

