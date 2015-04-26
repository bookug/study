#include "device_launch_parameters.h"
#include "stdio.h"
#include "stdlib.h"
#include "math.h"
#include "cuda_runtime.h"
#include "device_functions.h"
#include "time.h"
#define MAXN 8192
#define MAX_SIZE MAXN*MAXN
#define DELTA 1e-6
			
float ori_mx[MAX_SIZE];
float mx1[MAX_SIZE], mx2[MAX_SIZE], mx3[MAX_SIZE];
 
void simple_cpu_trans(const int n, float* m1, float* m2)
{
     for (int i = 0; i < n; ++i)
	     for (int j = 0; j < n; ++j)
	         m2[i * n + j] = m1[j * n + i];
}
 
__global__ void simple_gpu_trans(const int n, float* m1, float* m2)
{
     int i = blockIdx.x * blockDim.x + threadIdx.x;
     int j = blockIdx.y * blockDim.y + threadIdx.y;
     m2[i * n + j] = m1[j * n + i];
}
 
__global__ void advanced_gpu_trans(const int n, float* m1, float* m2)
{
     int i = threadIdx.x;
     int j = threadIdx.y;
     int i_ = blockIdx.x * blockDim.x + i;
     int j_ = blockIdx.y * blockDim.y + j;
     int i__ = blockIdx.x * blockDim.x + j;
     int j__ = blockIdx.y * blockDim.y + i;
     __shared__ float mems[16 * 16];
	mems[i * 16 + j] = m1[j_ * n + i_];
    __syncthreads();
   m2[i__ * n + j__] = mems[j * 16 + i];
}
	 
bool check(const int n, float* m1, float* m2)
{
	for (int i = 0; i < n * n; ++i)
		if (abs(m1[i]-m2[i]) > DELTA) return false;
		   return true;
}
			  
int main()
{
	srand(time(0));
	for (int i = 0; i < MAX_SIZE; ++i)
		ori_mx[i] = rand();
		 
	int start_cpu_time = clock();
	simple_cpu_trans(MAXN, ori_mx, mx1);
	int end_cpu_time = clock();
	double cpu_cost_time = (double)(end_cpu_time - start_cpu_time) / CLOCKS_PER_SEC * 1000;
	printf("CPU cost %.3lf ms.\n", cpu_cost_time);
				
	float *mxd1, *mxd2;
	if(cudaMalloc((void**)&mxd1, MAX_SIZE * sizeof(float)) != cudaSuccess)
			printf("cuda malloc failed!\n");
	if (cudaMalloc((void**)&mxd2, MAX_SIZE * sizeof(float)) != cudaSuccess)
			printf("cuda malloc failed!\n");
	if (cudaMemcpy(mxd1, ori_mx, MAX_SIZE * sizeof(float), cudaMemcpyHostToDevice))
			printf("cuda memcpy successfully!\n");
					
	cudaEvent_t start_gpu, end_gpu;
	cudaEventCreate(&start_gpu);
	cudaEventCreate(&end_gpu);
	cudaEventRecord(start_gpu, 0);

	dim3 dimBlock(16, 16);
	dim3 dimGrid(MAXN / 16, MAXN / 16); //here requires: MAXN % 16 == 0

	simple_gpu_trans << <dimGrid, dimBlock >> > (MAXN, mxd1, mxd2);
    cudaEventRecord(end_gpu, 0);
	cudaEventSynchronize(end_gpu);
	
	float gpu_cost_time;
	cudaEventElapsedTime(&gpu_cost_time, start_gpu, end_gpu);
	printf("GPU cost %.3lf ms.\n", gpu_cost_time);
	cudaEventDestroy(start_gpu);
	cudaEventDestroy(end_gpu);
	
	if (cudaMemcpy(mx2, mxd2, MAX_SIZE * sizeof(float), cudaMemcpyDeviceToHost) != cudaSuccess)
		printf("cuda memcpy failed!\n");
		
	if (check(MAXN, mx1, mx2))
		printf("check passed.\n");
	else
		printf("check failed.\n");
			   
	cudaEventCreate(&start_gpu);
	cudaEventCreate(&end_gpu);
	cudaEventRecord(start_gpu, 0);
			
	advanced_gpu_trans << <dimGrid, dimBlock >> > (MAXN, mxd1, mxd2);
	cudaEventRecord(end_gpu, 0);
	cudaEventSynchronize(end_gpu);
			   
	cudaEventElapsedTime(&gpu_cost_time, start_gpu, end_gpu);
	printf("GPU cost %.3lf ms.\n", gpu_cost_time);
	cudaEventDestroy(start_gpu);
	cudaEventDestroy(end_gpu);

    if (cudaMemcpy(mx3, mxd2, MAX_SIZE * sizeof(float), cudaMemcpyDeviceToHost) != cudaSuccess)
	    printf("cuda memcpy failed!\n");
    if (check(MAXN, mx1, mx3))
		printf("check passed.\n");
	else
		printf("check failed.\n");
	cudaFree(mxd1);
	cudaFree(mxd2);
	return 0;
}

