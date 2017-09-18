//In CUDA, the memory is as follows:
//For a thread, local memory
//For a block, shared memory
//For all threads, global memory

#include <stdio.h>

#define NUM_BLOCKS 1
#define BLOCK_WIDTH 128

//__global__ indicates the kernel function, running on GPu, but launched by cpu
__global__ void hello()
{
	//NOTICE: __syncthreads is used within a block
	__shared__ int array[128];
	int idx = threadIdx.x;
	//sync all writes
	array[idx] = idx;
	__syncthreads();
	if(idx < 127)
	{
		int temp = array[idx+1];
		//sync all reads
		__syncthreads();
		array[idx] = temp;
		//sync all writes
		__syncthreads();
	}
	printf("Hello, world! I am thread %d, the value of array is %d\n", idx, array[idx]);
}

int main(int argc, const char* argv[])
{
	hello<<<NUM_BLOCKS, BLOCK_WIDTH>>>();
	//NOTICE: different kernels are implicitly synchronized

	//force the printf()s to flush
	cudaDeviceSynchronize();

	printf("That's all!\n");

	return 0;
}

