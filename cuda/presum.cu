#include "device_functions.h"
#include "device_launch_parameters.h"
#include "stdio.h"
#include "stdlib.h"
#include "math.h"
#include "cuda_runtime.h"
#include "time.h"

#define MAXN 33554432
#define DELTA 1e-6
#define BN 512

int ori_arr[MAXN], ori_arr2[MAXN * 2]; 
int arr1[MAXN * 2], arr2[MAXN * 2]; 

void simple_cpu_presum(const int n, int* a1, int* a2) 
{
	int tmp = 0;
	for (int i = 0; i < n; ++i)
	{   
		a2[i] = a1[i] + tmp;
		tmp += a1[i];
	}								       
}

__global__ void gpu_presum_up(int* a, int l, int r)
{
	int thid = threadIdx.x;
	int i = l + blockIdx.x * blockDim.x + thid;		
	if (i < r)
		a[i] = a[i * 2] + a[i * 2 + 1]; 
}

__global__ void gpu_presum_down(int* a, int l, int r)
{
	int thid = threadIdx.x;
	int i = l + blockIdx.x * blockDim.x + thid;
	if (i < r)
	{
		a[i * 2 + 1] = a[2 * i] + a[i];
		a[2 * i] = a[i];
	}
}

__global__ void gpu_presum_floor(int* a, int l, int r)
{
	int thid = threadIdx.x;
	int i = l + blockIdx.x * blockDim.x + thid;
	if (i < r)
	{
		a[i * 2 + 1] += a[2 * i] + a[i];
		a[2 * i] += a[i];
	}
}

bool check(const int n, int* a1, int* a2)
{
	for (int i = 0; i < MAXN; ++i)
	{
		if (a1[i] != a2[i + MAXN]) 
			return false;
	}
	return true;
}

int main()
{
	srand(time(0));
	for (int i = 0; i < MAXN; ++i)
	{
		ori_arr[i] = rand();
		ori_arr2[i] = 0;
		ori_arr2[i + MAXN] = ori_arr[i];
	}

	int start_cpu_time = clock();
	simple_cpu_presum(MAXN, ori_arr, arr1);
	int end_cpu_time = clock();
	float cpu_cost_time = (float)(end_cpu_time - start_cpu_time) / CLOCKS_PER_SEC * 1000;
	printf("CPU cost %.3lf ms.\n", cpu_cost_time);							
								
	int *arrd1;
	if (cudaMalloc((void**)&arrd1, 2*MAXN * sizeof(int)) != cudaSuccess)
		printf("cuda malloc failed!\n");
	if (cudaMemcpy(arrd1, ori_arr2, 2*MAXN * sizeof(int), cudaMemcpyHostToDevice) != cudaSuccess)
		printf("cuda memcpy failed!\n");
											
	cudaEvent_t start_gpu, end_gpu;
	cudaEventCreate(&start_gpu);
	cudaEventCreate(&end_gpu);
	cudaEventRecord(start_gpu, 0);
															
	int left = MAXN / 2, right = MAXN;
	while (left != 1)
	{
		dim3 dimBlock(BN);
		int block_num = (right - left) / BN;
		if ((right - left) & (BN-1))
			++block_num;
		dim3 dimGrid(block_num);
		gpu_presum_up << <dimGrid, dimBlock >> > (arrd1, left, right);
		left /= 2;
		right /= 2;
	}

    left = 1;
	right = 2;
	while (left != MAXN)
	{
		dim3 dimBlock(BN);
		int block_num = (right - left) / BN;
		if ((right - left) & (BN-1))
			++block_num;
		dim3 dimGrid(block_num);
		if (left*2 != MAXN)
			gpu_presum_down << <dimGrid, dimBlock >> > (arrd1, left, right);
		else
			gpu_presum_floor << <dimGrid, dimBlock >> > (arrd1, left, right);

		left *= 2;
		right *= 2;
	}

	cudaEventRecord(end_gpu, 0);
	cudaEventSynchronize(end_gpu);

	float gpu_cost_time;
	cudaEventElapsedTime(&gpu_cost_time, start_gpu, end_gpu);
	printf("GPU cost %.3lf ms.\n", gpu_cost_time);
	cudaEventDestroy(start_gpu);
	cudaEventDestroy(end_gpu);
    if (cudaMemcpy(arr2, arrd1,2 * MAXN * sizeof(int), cudaMemcpyDeviceToHost) != cudaSuccess)
		printf("cuda memcpy failed!\n");
	if (check(MAXN, arr1, arr2))
		printf("check passed.\n");
	else
		printf("check failed.\n");
	cudaFree(arrd1);
	return 0;
}

