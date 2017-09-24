#include <stdio.h>
#include "gputimer.h"
/*#include "utils.h"*/

const int BLOCKSIZE	= 128;
const int NUMBLOCKS = 1000;					// set this to 1 or 2 for debugging
const int N 		= BLOCKSIZE*NUMBLOCKS;

/* 
 * TODO: modify the foo and bar kernels to use tiling: 
 * 		 - copy the input data to shared memory
 *		 - perform the computation there
 *	     - copy the result back to global memory
 *		 - assume thread blocks of 128 threads
 *		 - handle intra-block boundaries correctly
 * You can ignore boundary conditions (we ignore the first 2 and last 2 elements)
 */
__global__ void foo(float out[], float A[], float B[], float C[], float D[], float E[]){
	__shared__ float tmp[BLOCKSIZE];
	int i = threadIdx.x + blockIdx.x*blockDim.x; 
	if(i >= N)
	{
		return; 
	}
	tmp[threadIdx.x] = (A[i] + B[i] + C[i] + D[i] + E[i]) / 5.0f;
	__syncthreads();
	out[i] = tmp[threadIdx.x];
}

__global__ void bar(float out[], float in[]) 
{
	__shared__ float tmp[BLOCKSIZE+4];
	int i = threadIdx.x + blockIdx.x*blockDim.x; 
	tmp[threadIdx.x+2] = in[i];
	if(threadIdx.x == 0 && i >= 2)
	{
		tmp[0] = in[i-2];
		tmp[1] = in[i-1];
	}
	else if(threadIdx.x == BLOCKSIZE - 1 && i <= N-3)
	{
		tmp[BLOCKSIZE+2] = in[i+1];
		tmp[BLOCKSIZE+3] = in[i+2];
	}
	__syncthreads();
	if(i < 2 || i > N-3)
	{
		return; 
	}

	out[i] = (tmp[threadIdx.x] + tmp[threadIdx.x+1] + tmp[threadIdx.x+2] + tmp[threadIdx.x+3] + tmp[threadIdx.x+4]) / 5.0f;
}

void cpuFoo(float out[], float A[], float B[], float C[], float D[], float E[])
{
	for (int i=0; i<N; i++)
	{
		out[i] = (A[i] + B[i] + C[i] + D[i] + E[i]) / 5.0f;
	}
}

void cpuBar(float out[], float in[])
{
	// ignore the boundaries
	for (int i=2; i<N-2; i++)
	{
		out[i] = (in[i-2] + in[i-1] + in[i] + in[i+1] + in[i+2]) / 5.0f;
	}
}

void compareArrays(float* arr1, float* arr2, const int N)
{
	for(int i = 2; i < N-2; ++i)
	{
		if(arr1[i] != arr2[i])
		{
			printf("not matched: %d\n", i);
			return; 
		}
	}
	printf("all matched!\n");
}

int main(int argc, char **argv)
{
	// declare and fill input arrays for foo() and bar()
	float fooA[N], fooB[N], fooC[N], fooD[N], fooE[N], barIn[N];
	for (int i=0; i<N; i++) 
	{
		fooA[i] = i; 
		fooB[i] = i+1;
		fooC[i] = i+2;
		fooD[i] = i+3;
		fooE[i] = i+4;
		barIn[i] = 2*i; 
	}
	// device arrays
	int numBytes = N * sizeof(float);
	float *d_fooA;	 	cudaMalloc(&d_fooA, numBytes);
	float *d_fooB; 		cudaMalloc(&d_fooB, numBytes);
	float *d_fooC;	 	cudaMalloc(&d_fooC, numBytes);
	float *d_fooD; 		cudaMalloc(&d_fooD, numBytes);
	float *d_fooE; 		cudaMalloc(&d_fooE, numBytes);
	float *d_barIn; 	cudaMalloc(&d_barIn, numBytes);
	cudaMemcpy(d_fooA, fooA, numBytes, cudaMemcpyHostToDevice);
	cudaMemcpy(d_fooB, fooB, numBytes, cudaMemcpyHostToDevice);
	cudaMemcpy(d_fooC, fooC, numBytes, cudaMemcpyHostToDevice);
	cudaMemcpy(d_fooD, fooD, numBytes, cudaMemcpyHostToDevice);
	cudaMemcpy(d_fooE, fooE, numBytes, cudaMemcpyHostToDevice);
	cudaMemcpy(d_barIn, barIn, numBytes, cudaMemcpyHostToDevice);	

	// output arrays for host and device
	float fooOut[N], barOut[N], *d_fooOut, *d_barOut;
	cudaMalloc(&d_fooOut, numBytes);
	cudaMalloc(&d_barOut, numBytes);

	// declare and compute reference solutions
	float ref_fooOut[N], ref_barOut[N]; 
	cpuFoo(ref_fooOut, fooA, fooB, fooC, fooD, fooE);
	cpuBar(ref_barOut, barIn);

	// launch and time foo and bar
	GpuTimer fooTimer, barTimer;
	fooTimer.Start();
	foo<<<N/BLOCKSIZE, BLOCKSIZE>>>(d_fooOut, d_fooA, d_fooB, d_fooC, d_fooD, d_fooE);
	fooTimer.Stop();
	
	barTimer.Start();
	bar<<<N/BLOCKSIZE, BLOCKSIZE>>>(d_barOut, d_barIn);
	barTimer.Stop();

	cudaMemcpy(fooOut, d_fooOut, numBytes, cudaMemcpyDeviceToHost);
	cudaMemcpy(barOut, d_barOut, numBytes, cudaMemcpyDeviceToHost);
	printf("foo<<<>>>(): %g ms elapsed. Verifying solution...", fooTimer.Elapsed());
	compareArrays(ref_fooOut, fooOut, N);
	printf("bar<<<>>>(): %g ms elapsed. Verifying solution...", barTimer.Elapsed());
	compareArrays(ref_barOut, barOut, N);
}
