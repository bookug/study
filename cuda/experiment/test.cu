/*=============================================================================
# Filename: test.cu
# Author: bookug 
# Mail: bookug@qq.com
# Last Modified: 2018-10-24 19:56
# Description: 
This program tests I/O and thread capacity on GPU(using Titan X Pascal)
=============================================================================*/

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

__global__ void hello(unsigned* d_data)
{
	/*__shared__ int array[128];*/

	/*printf("Hello, world! I am a thread in block %d\n", blockIdx.x);*/

	/*__syncthreads();*/

    //HACK: we can hack the global load/store transaction number/size here
    //Or we can explore the mechanism of register allocation.
    unsigned ele = d_data[threadIdx.x];
    ele = 2 * ele;
    d_data[threadIdx.x] = ele;
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
    hello<<<1, 32>>>(d_data);
	//Below checks if the kernel launches successfully
	checkCudaErrors(cudaGetLastError());
	//force the printf()s to flush
	cudaDeviceSynchronize();
	//Below checks if the kernel runs and ends successfully
	checkCudaErrors(cudaGetLastError());
    cudaFree(d_data);

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

