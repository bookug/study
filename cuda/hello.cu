#include <stdio.h>

#define NUM_BLOCKS 16
#define BLOCK_WIDTH 1

__global__ void hello()
{
	/*__shared__ int array[128];*/
	printf("Hello, world! I am a thread in block %d\n", blockIdx.x);
	/*__syncthreads();*/
}

int main(int argc, const char* argv[])
{
	hello<<<NUM_BLOCKS, BLOCK_WIDTH>>>();

	//force the printf()s to flush
	cudaDeviceSynchronize();

	printf("That's all!\n");

	return 0;
}

