#include <stdio.h>

//WARN: this setting will cause the kernel function unable to work
//As a result, we should set block num < 65536
/*#define NUM_BLOCKS 65536*/
#define NUM_BLOCKS 400
/*#define BLOCK_WIDTH 1*/
#define BLOCK_WIDTH 1024

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

	//force the printf()s to flush
	cudaDeviceSynchronize();

	printf("That's all!\n");

	return 0;
}

