//To compile cuda program using dynamic parallelism
//nvcc -arch=sm_35 -lcudadevrt -rdc=true dynamic.cu

#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>
#include <iostream> 

using namespace std;

__device__ int v = 0;

__global__ void child_k(void)
{
	printf("v = %d\n", v);
}

/*__global__ void parent_k(int* data)*/
__global__ void parent_k()
{
	/*int d_data = 3;*/
	/*cudaMemcpy(data, &d_data, sizeof(int), cudaMemcpyDeviceToHost);*/
	printf("Hello, World!\n");
	v = 1;
	child_k<<<1,1>>>();
	v = 2; //race condition
	cudaDeviceSynchronize();
}

int main(int argc, char **argv)
{
    int deviceCount;
    cudaGetDeviceCount(&deviceCount);
    if (deviceCount == 0) {
        fprintf(stderr, "error: no devices supporting CUDA.\n");
        exit(EXIT_FAILURE);
    }
    int dev = 0;
    cudaSetDevice(dev);

	//NOTE: 48KB shared memory per block, 1024 threads per block, 28 SMs
    cudaDeviceProp devProps;
    if (cudaGetDeviceProperties(&devProps, dev) == 0)
    {
        printf("Using device %d:\n", dev);
        printf("%s; global mem: %dB; compute v%d.%d; clock: %d kHz; shared mem: %dB; block threads: %d; SM count: %d\n",
               devProps.name, (int)devProps.totalGlobalMem, 
               (int)devProps.major, (int)devProps.minor, 
               (int)devProps.clockRate,
			   devProps.sharedMemPerBlock, devProps.maxThreadsPerBlock, devProps.multiProcessorCount);
    }

	/*int data;*/
	/*parent_k<<<1,1>>>(&data);*/
	/*cout<<"data: "<<data<<endl;*/
	parent_k<<<1,1>>>();
        
    return 0;
}
