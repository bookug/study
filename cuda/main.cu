//HELP: http://blog.csdn.net/augusdi/article/details/12833235
//QUERY: how to assign a specific or several GPUs?
//Shared Memory: http://tech.it168.com/a2011/0708/1215/000001215209_1.shtml
//WARP and BANK: http://blog.163.com/wujiaxing009@126/blog/static/71988399201712735436357/
//cudaDeviceSynchronize: http://blog.csdn.net/mathgeophysics/article/details/19905935

//performance optimization
//http://blog.csdn.net/litdaguang/article/details/50520549

#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <cuda.h>
#include <cuda_runtime_api.h>
#include <cassert>
#include <cmath>
#include <iostream>

using namespace std;

#define checkCudaErrors(val) check( (val), #val, __FILE__, __LINE__)

template<typename T>
void check(T err, const char* const func, const char* const file, const int line) {
  if (err != cudaSuccess) {
    std::cerr << "CUDA error at: " << file << ":" << line << std::endl;
    std::cerr << cudaGetErrorString(err) << " " << func << std::endl;
    exit(1);
  }
}

#include <stdio.h>

cudaError_t addWithCuda(int *c, const int *a, const int *b, size_t size);

__global__ void addKernel(int *c, const int *a, const int *b)
{
    int i = threadIdx.x;
    c[i] = a[i] + b[i];
}

__global__ void checkWarp_kernel()
{
	__shared__ unsigned s_val;
	if(threadIdx.x > 31)
	{
		return; 
	}
	if(threadIdx.x == 0)
	{
		s_val = 0;
	}
	atomicAdd(&s_val,1);
	/*s_val++;*/
	/*printf("block: %u thread: %u\n", blockIdx.x, threadIdx.x);*/
	if(threadIdx.x == 0)
	{
		printf("check warp: %u\n", s_val);
	}
}

__global__ void
memory_kernel(int** d_m)
{
	/*d_m[0] = new int[2];*/
	d_m[0][0] = 1;
	printf("gpu pointer: %lu\n", d_m[0]);
}

int main()
{
	int **d_m;
	cudaMalloc(&d_m, sizeof(int*));
  checkCudaErrors(cudaGetLastError());
  int** h_m = new int*[1];
	cudaMalloc(&h_m[0], sizeof(int));
  checkCudaErrors(cudaGetLastError());
	cudaMemcpy(d_m, h_m, sizeof(int*), cudaMemcpyHostToDevice);
  checkCudaErrors(cudaGetLastError());
	printf("check pointer: %lu\n", h_m[0]);
	memory_kernel<<<1,1>>>(d_m);
  cudaDeviceSynchronize(); 
  checkCudaErrors(cudaGetLastError());
	cudaFree(h_m[0]);
  checkCudaErrors(cudaGetLastError());
	cudaFree(d_m);
  checkCudaErrors(cudaGetLastError());
	cudaFree(d_m);
  checkCudaErrors(cudaGetLastError());

	//check the output: 32 threads in a warp add 1 to the same variable
	checkWarp_kernel<<<1, 32>>>();
	
    const int arraySize = 5;
    const int a[arraySize] = { 1, 2, 3, 4, 5 };
    const int b[arraySize] = { 10, 20, 30, 40, 50 };
    int c[arraySize] = { 0 };

    // Add vectors in parallel.
    cudaError_t cudaStatus = addWithCuda(c, a, b, arraySize);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "addWithCuda failed!");
        return 1;
    }

    printf("{1,2,3,4,5} + {10,20,30,40,50} = {%d,%d,%d,%d,%d}\n",
        c[0], c[1], c[2], c[3], c[4]);

    // cudaThreadExit must be called before exiting in order for profiling and
    // tracing tools such as Nsight and Visual Profiler to show complete traces.
    cudaStatus = cudaThreadExit();
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaThreadExit failed!");
        return 1;
    }

    return 0;
}

// Helper function for using CUDA to add vectors in parallel.
cudaError_t addWithCuda(int *c, const int *a, const int *b, size_t size)
{
    int *dev_a = 0;
    int *dev_b = 0;
    int *dev_c = 0;
    cudaError_t cudaStatus;

    // Choose which GPU to run on, change this on a multi-GPU system.
    cudaStatus = cudaSetDevice(0);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaSetDevice failed!  Do you have a CUDA-capable GPU installed?");
        goto Error;
    }

    // Allocate GPU buffers for three vectors (two input, one output)    .
    cudaStatus = cudaMalloc((void**)&dev_c, size * sizeof(int));
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed!");
        goto Error;
    }

    cudaStatus = cudaMalloc((void**)&dev_a, size * sizeof(int));
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed!");
        goto Error;
    }

    cudaStatus = cudaMalloc((void**)&dev_b, size * sizeof(int));
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed!");
        goto Error;
    }

    // Copy input vectors from host memory to GPU buffers.
    cudaStatus = cudaMemcpy(dev_a, a, size * sizeof(int), cudaMemcpyHostToDevice);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMemcpy failed!");
        goto Error;
    }

    cudaStatus = cudaMemcpy(dev_b, b, size * sizeof(int), cudaMemcpyHostToDevice);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMemcpy failed!");
        goto Error;
    }

    // Launch a kernel on the GPU with one thread for each element.
    addKernel<<<1, size>>>(dev_c, dev_a, dev_b);

    // cudaThreadSynchronize waits for the kernel to finish, and returns
    // any errors encountered during the launch.
    cudaStatus = cudaThreadSynchronize();
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaThreadSynchronize returned error code %d after launching addKernel!\n", cudaStatus);
        goto Error;
    }

    // Copy output vector from GPU buffer to host memory.
    cudaStatus = cudaMemcpy(c, dev_c, size * sizeof(int), cudaMemcpyDeviceToHost);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMemcpy failed!");
        goto Error;
    }

Error:
    cudaFree(dev_c);
    cudaFree(dev_a);
    cudaFree(dev_b);
    
    return cudaStatus;
}
