/* Udacity HW5
   Histogramming for Speed

   The goal of this assignment is compute a histogram
   as fast as possible.  We have simplified the problem as much as
   possible to allow you to focus solely on the histogramming algorithm.

   The input values that you need to histogram are already the exact
   bins that need to be updated.  This is unlike in HW3 where you needed
   to compute the range of the data and then do:
   bin = (val - valMin) / valRange to determine the bin.

   Here the bin is just:
   bin = val

   so the serial histogram calculation looks like:
   for (i = 0; i < numElems; ++i)
     histo[val[i]]++;

   That's it!  Your job is to make it run as fast as possible!

   The values are normally distributed - you may take
   advantage of this fact in your implementation.

*/


#include "utils.h"
#include <stdio.h>

__global__
void yourHisto(const unsigned int* const vals, //INPUT
               unsigned int* const histo,      //OUPUT
               int numVals, int span)
{
  //TODO fill in this kernel to calculate the histogram
  //as quickly as possible

  //Although we provide only one kernel skeleton,
  //feel free to use more if it will help you
  //write faster code

	extern __shared__ unsigned tmph[];
	int tid = threadIdx.x;
	if(tid < span)
	{
		tmph[tid] = 0;
	}
	/*printf("tid: %d\n", tid);*/
	__syncthreads();

	int coarse_key = blockIdx.y;
	/*printf("coarse key: %d\n", coarse_key);*/
	int myId = tid + blockDim.x * blockIdx.x;
	/*printf("main key: %d\n", myId);*/
	if(myId >= numVals)
	{
		return;
	}
	unsigned key = vals[myId];
	unsigned key2 = key / span;
	/*printf("main coarse key: %d\n", key2);*/
	if(key2 != coarse_key)
	{
		return;
	}
	atomicAdd(&tmph[key%span], 1);
	//this block finishes the computation
	__syncthreads();
	//write this block's result to global memory
	if(tid == 0)
	{
		for(int i = 0; i < span; ++i)
		{
			atomicAdd(&histo[coarse_key*span+i], tmph[i]);
		}
	}
}

void computeHistogram(const unsigned int* const d_vals, //INPUT
                      unsigned int* const d_histo,      //OUTPUT
                      const unsigned int numBins,
                      const unsigned int numElems)
{
  //TODO Launch the yourHisto kernel

  //if you want to use/launch more than one kernel,
  //feel free

	//the num of eles is 10240000, the num of bins is 1024, the range of value is 0~999, normal distribution
	/*printf("numBins: %u numElems: %u\n", numBins, numElems);*/
	/*unsigned* h_vals = (unsigned*)malloc(sizeof(unsigned) * numElems);*/
	/*checkCudaErrors(cudaMemcpy(h_vals, d_vals, sizeof(unsigned) * numElems, cudaMemcpyDeviceToHost));*/
	unsigned* h_histo = (unsigned*)malloc(sizeof(unsigned) * numBins);
	memset(h_histo, 0, sizeof(unsigned) * numBins);
	/*FILE* fp = fopen("data.txt", "w+");*/
	/*if(fp == NULL)*/
	/*{*/
		/*printf("error to open file!\n");*/
	/*}*/
	/*for(unsigned i = 0; i < numElems; ++i)*/
	/*{*/
		/*[>printf("%u ", h_vals[i]);<]*/
		/*[>fprintf(fp, "%u\n", h_vals[i]);<]*/
		/*h_histo[h_vals[i]]++;*/
	/*}*/
	/*for(unsigned i = 0; i < numBins; ++i)*/
	/*{*/
		/*fprintf(fp, "%u\n", h_histo[i]);*/
	/*}*/
	/*fclose(fp);*/
	/*free(h_vals);*/
	/*free(h_histo);*/
	
	//the num of coarse bins
	int numCoarse = 16;
	//TODO; adjust the num of coarse bins, if 1, then store all bins in each block
	int span = numBins / numCoarse;
	/*printf("span: %u\n", span);*/
	int size = 1024;
	const dim3 threads(size, 1, 1);
	const dim3 blocks((numElems+size-1)/size, numCoarse, 1);
	checkCudaErrors(cudaMemset(d_histo, 0, sizeof(unsigned) * numBins));
	yourHisto<<<blocks, threads, span>>>(d_vals, d_histo, numElems, span);
	//TODO: use coarse bins for optimization
	//NOTICE: the key point is to keep all SMs busy

	checkCudaErrors(cudaMemcpy(h_histo, d_histo, sizeof(unsigned) * numBins, cudaMemcpyDeviceToHost));
	for(int i = 0; i < numBins; ++i)
	{
		printf("%u\n", h_histo[i]);
	}

	cudaDeviceSynchronize(); 
	checkCudaErrors(cudaGetLastError());
}
