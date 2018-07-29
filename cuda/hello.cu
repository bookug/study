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
	/*cudaPrintfInit(100*NUM_BLOCKS*BLOCK_WIDTH);*/

	hello<<<NUM_BLOCKS, BLOCK_WIDTH>>>();

	//force the printf()s to flush
	cudaDeviceSynchronize();

	printf("That's all!\n");

	return 0;
}

