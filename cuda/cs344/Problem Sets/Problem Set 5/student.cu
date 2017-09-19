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

/*#define DEBUG_OPEN 1*/

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
	/*if(coarse_key > 1)*/
	/*printf("coarse key: %d\n", coarse_key);*/
	int myId = tid + blockDim.x * blockIdx.x;
	/*printf("main key: %d\n", myId);*/
	if(myId >= numVals)
	{
		return;
	}
	/*printf("threadIdx.x: %d  threadIdx.y: %d blockIdx.x: %d blockIdx.y: %d blockDim.x: %d blockDim.y: %d\n", threadIdx.x, threadIdx.y, blockIdx.x, blockIdx.y, blockDim.x, blockDim.y);*/
	unsigned key = vals[myId];
	unsigned key2 = key / span;
	/*printf("main coarse key: %d\n", key2);*/
	/*printf("key2: %u coarse_key: %u\n", key2, coarse_key);*/

	//NOTICE: if not equal, can not return directly here, otherwise the if(tid==0) below may not work if the 0-th thread already returns
	if(key2 == coarse_key)
	{
		atomicAdd(&tmph[key%span], 1);
		//this block finishes the computation
		__syncthreads();
	}
	/*printf("check: %u %u\n", tmph[0], tmph[1]);*/
	/*if(key == 1 && coarse_key == 0)*/
	/*{*/
		/*printf("check 1 bin: %u\n", tmph[1]);*/
	/*}*/
	
	//write this block's result to global memory
	if(tid == 0)
	{
		/*printf("to write coarse_key %d\n", coarse_key);*/
		/*if(coarse_key == 0)*/
			/*printf("check %u bin: %u\n", coarse_key*span, tmph[0]);*/
		for(int i = 0; i < span; ++i)
		{
/*#ifdef DEBUG_OPEN*/
			/*if(coarse_key==0)*/
			/*{*/
				/*printf("check 0 bin %d : %u\n", i, tmph[i]);*/
			/*}*/
/*#endif*/
			atomicAdd(&histo[coarse_key*span+i], tmph[i]);
		}
		/*if(coarse_key == 0)*/
			/*printf("check 0 bin: %u\n", histo[0]);*/
	}
}

void myHistogram(const unsigned int* const d_vals, //INPUT
                      unsigned int* const d_histo,      //OUTPUT
                      const unsigned int numBins,
                      const unsigned int numElems)
{
	//the num of eles is 10240000, the num of bins is 1024, the range of value is 0~999, normal distribution
	/*printf("numBins: %u numElems: %u\n", numBins, numElems);*/
	/*unsigned* h_vals = (unsigned*)malloc(sizeof(unsigned) * numElems);*/
	/*checkCudaErrors(cudaMemcpy(h_vals, d_vals, sizeof(unsigned) * numElems, cudaMemcpyDeviceToHost));*/
	/*unsigned* h_histo = (unsigned*)malloc(sizeof(unsigned) * numBins);*/
	/*memset(h_histo, 0, sizeof(unsigned) * numBins);*/
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
	
	//TODO: use coarse bins for optimization
	//NOTICE: the key point is to keep all SMs busy
	//BETTER: consider not divide evenly, utilize the normally distribution
	//TODO+DEBUG: when numCoarse is 1 or 2, the program is right, but not more efficient
	//However, when numCoarse>=4, the answer is not right!

	//the num of coarse bins
	int numCoarse = 32;
	/*int numCoarse = 16;*/
	//TODO; adjust the num of coarse bins, if 1, then store all bins in each block
	int span = numBins / numCoarse;
/*#ifdef DEBUG_OPEN*/
	/*printf("span: %u\n", span);*/
/*#endif*/
	int size = 1024;
	const dim3 threads(size, 1, 1);
	const dim3 blocks((numElems+size-1)/size, numCoarse, 1);
	checkCudaErrors(cudaMemset(d_histo, 0, sizeof(unsigned) * numBins));
	//the size in <<<>>> shoukd be number of bytes
	yourHisto<<<blocks, threads, sizeof(unsigned) * span>>>(d_vals, d_histo, numElems, span);

	/*checkCudaErrors(cudaMemcpy(h_histo, d_histo, sizeof(unsigned) * numBins, cudaMemcpyDeviceToHost));*/
	/*for(int i = 0; i < numBins; ++i)*/
	/*{*/
		/*printf("%u\n", h_histo[i]);*/
	/*}*/
	/*free(h_histo);*/
}

void computeHistogram(const unsigned int* const d_vals, //INPUT
                      unsigned int* const d_histo,      //OUTPUT
                      const unsigned int numBins,
                      const unsigned int numElems)
{
  //TODO Launch the yourHisto kernel

  //if you want to use/launch more than one kernel,
  //feel free

	//NOTICE: thsi si a simple check program
/*#ifdef DEBUG_OPEN*/
	/*unsigned numBins2 = 4, numElems2 = 8;*/
	/*unsigned h_vals2[] = {3, 1, 0, 2, 0, 1, 2, 3};*/
	/*unsigned *d_vals2, *d_histo2;*/
	/*checkCudaErrors(cudaMalloc(&d_vals2, sizeof(unsigned) * numElems2));*/
	/*checkCudaErrors(cudaMalloc(&d_histo2, sizeof(unsigned) * numBins2));*/
	/*checkCudaErrors(cudaMemcpy(d_vals2, h_vals2, sizeof(unsigned) * numElems2, cudaMemcpyHostToDevice));*/
	/*myHistogram(d_vals2, d_histo2, numBins2, numElems2);*/
	/*unsigned h_histo2[4];*/
	/*checkCudaErrors(cudaMemcpy(h_histo2, d_histo2, sizeof(unsigned) * numBins2, cudaMemcpyDeviceToHost));*/
	/*for(int i = 0; i < 4; ++i)*/
	/*{*/
		/*printf("%u\n", h_histo2[i]);*/
	/*}*/
	/*checkCudaErrors(cudaFree(d_vals2));*/
	/*checkCudaErrors(cudaFree(d_histo2));*/
/*#endif*/

	myHistogram(d_vals, d_histo, numBins, numElems);

	cudaDeviceSynchronize(); 
	checkCudaErrors(cudaGetLastError());
}
