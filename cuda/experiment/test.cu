#include <stdio.h>
#include <cuda.h> 
#include <cuda_runtime.h> 
#include <cuda_runtime_api.h> 
#include <cassert>

#define checkCudaErrors(val) check( (val), #val, __FILE__, __LINE__)

template<typename T>
void check(T err, const char* const func, const char* const file, const int line) {
  if (err != cudaSuccess) {
    printf("CUDA error at: %s:%d\n", file, line);
    printf("%s %s\n", cudaGetErrorString(err), func);
    exit(1);
  }
}

//Dynamic memory allocation in the kernel function of GPU
//https://docs.nvidia.com/cuda/cuda-c-programming-guide/index.html#dynamic-global-memory-allocation-and-operations
//very slow, dozens of times slower than pre-assigned memory

//NOTICE: the limit of block number is given by compute/arch capablity
//nvcc -arch=sm_35 will allow block num >= 65536
//https://en.wikipedia.org/wiki/CUDA
//WARN: this setting will cause the kernel function unable to work
//As a result, we should set block num < 65536
#define NUM_BLOCKS 65536
/*#define NUM_BLOCKS 400*/
#define BLOCK_WIDTH 1
/*#define BLOCK_WIDTH 1024*/

__global__ void hello()
{
	/*__shared__ int array[128];*/
	printf("Hello, world! I am a thread in block %d\n", blockIdx.x);
	/*__syncthreads();*/
}

int main(int argc, const char* argv[])
{
	//NOTICE: this API is out-ofo-date
	/*cudaPrintfInit(100*NUM_BLOCKS*BLOCK_WIDTH);*/
	size_t io_buffer_size = 0;
	cudaDeviceGetLimit(&io_buffer_size, cudaLimitPrintfFifoSize);
	printf("io buffer size: %u\n", io_buffer_size);   //1M by default
	//NOTICE: no need to assign space for all threads' output, because there are at most 3840 threads running in parallel really
	//The former analysis is wrong!  IO buffer is flushed at the end of kernel execution, so overwriting will occur!
	cudaDeviceSetLimit(cudaLimitPrintfFifoSize, 400*1024*200);
	cudaDeviceGetLimit(&io_buffer_size, cudaLimitPrintfFifoSize);
	printf("io buffer size: %u\n", io_buffer_size);   //1M by default

	hello<<<NUM_BLOCKS, BLOCK_WIDTH>>>();
	//Below checks if the kernel launches successfully
	checkCudaErrors(cudaGetLastError());

	//force the printf()s to flush
	cudaDeviceSynchronize();
	//Below checks if the kernel runs and ends successfully
	checkCudaErrors(cudaGetLastError());

	printf("That's all!\n");

	return 0;
}

