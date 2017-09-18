#include "cuda_runtime.h"			//CUDA运行时API
#include "device_launch_parameters.h"	
#include <stdio.h>
cudaError_t addWithCuda(int *c, const int *a, const int *b, size_t size);
__global__ void addKernel(int *c, const int *a, const int *b)
{
    int i = threadIdx.x;
    c[i] = a[i] + b[i];
}
int main()
{
    const int arraySize = 5;
    const int a[arraySize] = { 1, 2, 3, 4, 5 };
    const int b[arraySize] = { 10, 20, 30, 40, 50 };
    int c[arraySize] = { 0 };
    // Add vectors in parallel.
    cudaError_t cudaStatus;
	int num = 0;
	cudaDeviceProp prop;
	cudaStatus = cudaGetDeviceCount(&num);
	for(int i = 0;i<num;i++)
	{
		cudaGetDeviceProperties(&prop,i);
	}
	cudaStatus = addWithCuda(c, a, b, arraySize);
    if (cudaStatus != cudaSuccess) 
	{
        fprintf(stderr, "addWithCuda failed!");
        return 1;
    }
    printf("{1,2,3,4,5} + {10,20,30,40,50} = {%d,%d,%d,%d,%d}\n",c[0],c[1],c[2],c[3],c[4]);
    // cudaThreadExit must be called before exiting in order for profiling and
    // tracing tools such as Nsight and Visual Profiler to show complete traces.
    cudaStatus = cudaThreadExit();
    if (cudaStatus != cudaSuccess) 
	{
        fprintf(stderr, "cudaThreadExit failed!");
        return 1;
    }
    return 0;
}
// 重点理解这个函数
cudaError_t addWithCuda(int *c, const int *a, const int *b, size_t size)
{
    int *dev_a = 0;	//GPU设备端数据指针
    int *dev_b = 0;
    int *dev_c = 0;
    cudaError_t cudaStatus;		//状态指示

    // Choose which GPU to run on, change this on a multi-GPU system.
    cudaStatus = cudaSetDevice(0);	//选择运行平台
    if (cudaStatus != cudaSuccess) 
	{
        fprintf(stderr, "cudaSetDevice failed!  Do you have a CUDA-capable GPU installed?");
        goto Error;
    }
    // 分配GPU设备端内存
    cudaStatus = cudaMalloc((void**)&dev_c, size * sizeof(int));
    if (cudaStatus != cudaSuccess) 
	{
        fprintf(stderr, "cudaMalloc failed!");
        goto Error;
    }
    cudaStatus = cudaMalloc((void**)&dev_a, size * sizeof(int));
    if (cudaStatus != cudaSuccess) 
	{
        fprintf(stderr, "cudaMalloc failed!");
        goto Error;
    }
    cudaStatus = cudaMalloc((void**)&dev_b, size * sizeof(int));
    if (cudaStatus != cudaSuccess) 
	{
        fprintf(stderr, "cudaMalloc failed!");
        goto Error;
    }
    // 拷贝数据到GPU
    cudaStatus = cudaMemcpy(dev_a, a, size * sizeof(int), cudaMemcpyHostToDevice);
    if (cudaStatus != cudaSuccess) 
	{
        fprintf(stderr, "cudaMemcpy failed!");
        goto Error;
    }
    cudaStatus = cudaMemcpy(dev_b, b, size * sizeof(int), cudaMemcpyHostToDevice);
    if (cudaStatus != cudaSuccess) 
	{
        fprintf(stderr, "cudaMemcpy failed!");
        goto Error;
    }
    // 运行核函数
	addKernel<<<1, size>>>(dev_c, dev_a, dev_b);
	// cudaThreadSynchronize waits for the kernel to finish, and returns
    // any errors encountered during the launch.
    cudaStatus = cudaThreadSynchronize();	//同步线程
    if (cudaStatus != cudaSuccess) 
	{
        fprintf(stderr, "cudaThreadSynchronize returned error code %d after launching addKernel!\n", cudaStatus);
        goto Error;
    }
    // Copy output vector from GPU buffer to host memory.
    cudaStatus = cudaMemcpy(c, dev_c, size * sizeof(int), cudaMemcpyDeviceToHost);		//拷贝结果回主机
    if (cudaStatus != cudaSuccess) 
	{
        fprintf(stderr, "cudaMemcpy failed!");
        goto Error;
    }
Error:
    cudaFree(dev_c);	//释放GPU设备端内存
    cudaFree(dev_a);
    cudaFree(dev_b);    
    return cudaStatus;
}
