//HELP: http://blog.csdn.net/suda072605/article/details/19965857

/* Udacity Homework 3
   HDR Tone-mapping

  Background HDR
  ==============

  A High Dynamic Range (HDR) image contains a wider variation of intensity
  and color than is allowed by the RGB format with 1 byte per channel that we
  have used in the previous assignment.  

  To store this extra information we use single precision floating point for
  each channel.  This allows for an extremely wide range of intensity values.

  In the image for this assignment, the inside of church with light coming in
  through stained glass windows, the raw input floating point values for the
  channels range from 0 to 275.  But the mean is .41 and 98% of the values are
  less than 3!  This means that certain areas (the windows) are extremely bright
  compared to everywhere else.  If we linearly map this [0-275] range into the
  [0-255] range that we have been using then most values will be mapped to zero!
  The only thing we will be able to see are the very brightest areas - the
  windows - everything else will appear pitch black.

  The problem is that although we have cameras capable of recording the wide
  range of intensity that exists in the real world our monitors are not capable
  of displaying them.  Our eyes are also quite capable of observing a much wider
  range of intensities than our image formats / monitors are capable of
  displaying.

  Tone-mapping is a process that transforms the intensities in the image so that
  the brightest values aren't nearly so far away from the mean.  That way when
  we transform the values into [0-255] we can actually see the entire image.
  There are many ways to perform this process and it is as much an art as a
  science - there is no single "right" answer.  In this homework we will
  implement one possible technique.

  Background Chrominance-Luminance
  ================================

  The RGB space that we have been using to represent images can be thought of as
  one possible set of axes spanning a three dimensional space of color.  We
  sometimes choose other axes to represent this space because they make certain
  operations more convenient.

  Another possible way of representing a color image is to separate the color
  information (chromaticity) from the brightness information.  There are
  multiple different methods for doing this - a common one during the analog
  television days was known as Chrominance-Luminance or YUV.

  We choose to represent the image in this way so that we can remap only the
  intensity channel and then recombine the new intensity values with the color
  information to form the final image.

  Old TV signals used to be transmitted in this way so that black & white
  televisions could display the luminance channel while color televisions would
  display all three of the channels.
  

  Tone-mapping
  ============

  In this assignment we are going to transform the luminance channel (actually
  the log of the luminance, but this is unimportant for the parts of the
  algorithm that you will be implementing) by compressing its range to [0, 1].
  To do this we need the cumulative distribution of the luminance values.

  Example
  -------

  input : [2 4 3 3 1 7 4 5 7 0 9 4 3 2]
  min / max / range: 0 / 9 / 9

  histo with 3 bins: [4 7 3]

  cdf : [4 11 14]


  Your task is to calculate this cumulative distribution by following these
  steps.

*/

#include "utils.h"
#include <stdio.h>
/*#include <iostream>*/

__global__ void
reduce_kernel(float* const d_out, float* const d_in, const size_t curlen, const bool less)
{
	int tid = threadIdx.x;
	int myId = tid + blockDim.x * blockIdx.x;
	if(myId >= curlen)
	{
		return;
	}
	//NOTICE: it is ok to be negative
	//PERORMANCE: use IO in GPU is very slow, need to transfer to cpu memory and output
	/*if(d_in[myId] < 0)*/
	/*{*/
		/*printf("error: %f!\n", d_in[myId]);*/
	/*}*/

	for(unsigned int s = blockDim.x / 2; s > 0; s >>= 1)
	{
		if(tid < s && myId + s < curlen)
		{
			float tmp1 = d_in[myId], tmp2 = d_in[myId+s];
			if(less)
			{
				d_in[myId] = min(tmp1, tmp2);
			}
			else
			{
				d_in[myId] = max(tmp1, tmp2);
			}
		}
		__syncthreads();
	}

	if(tid == 0)
	{
		d_out[blockIdx.x] = d_in[myId];
	}
	/*if(myId == 0)*/
	/*{*/
		/*float mine = d_in[0], maxe = d_in[0];*/
		/*for(unsigned i = 1; i < curlen; ++i)*/
		/*{*/
			/*mine = min(d_in[i], mine);*/
			/*maxe = max(d_in[i], maxe);*/
		/*}*/
		/*printf("check min %f max %f\n", mine, maxe);*/
	/*}*/
}

void reduce(const float* const d_logluminance, const size_t numlen, float* const d_border, const bool less)
{
	//BETTER: return min/max dierctly
	/*printf("here is reduce!\n");*/
	int limit = log(numlen)/log(2) + 1;
	int size = 1024;
	const dim3 threads(size, 1, 1);
	int curlen = numlen;
	float*  d_in;
	float *d_mid;
	checkCudaErrors(cudaMalloc((void**)&d_in, sizeof(float) * numlen));
	checkCudaErrors(cudaMemcpy(d_in, d_logluminance, sizeof(float) * numlen, cudaMemcpyDeviceToDevice));

	/*printf("begin while loop!\n");*/
	while(limit--)
	{
		/*printf("loop loop\n");*/
		int num_blocks = curlen / size;
		if(curlen % size != 0)
		{
			num_blocks ++;
		}
		checkCudaErrors(cudaMalloc((void**)&d_mid, sizeof(float) * num_blocks));

		const dim3 blocks(num_blocks, 1, 1);
		reduce_kernel<<<blocks, threads>>>(d_mid, d_in, curlen, less);
		cudaDeviceSynchronize(); checkCudaErrors(cudaGetLastError());

		/*printf("before cuda free!\n");*/
		/*printf("curlen: %d num_blocks: %d\n", curlen, num_blocks);*/
		checkCudaErrors(cudaFree(d_in));
		/*printf("after cuda free!\n");*/
		curlen = num_blocks;
		if(curlen == 1)
		{
			break;
		}
		d_in = d_mid;
	}

	//the result is in d_mid
	checkCudaErrors(cudaMemcpy(d_border, &d_mid[0], sizeof(float), cudaMemcpyDeviceToDevice));
	//NOTICE: below is error, device memory can not be copied directly in the host code
	//while in kernel code, device memory can be used directly
	/**d_border = d_mid[0];*/
	checkCudaErrors(cudaFree(d_mid));
}

__global__ void
histogram_kernel(const float* const d_in, unsigned* const d_out, const size_t numlen, const float min_logLum, const float range, const size_t numBins)
{
	int tid = threadIdx.x;
	int myId = tid + blockDim.x * blockIdx.x;
	if(myId >= numlen)
	{
		return;
	}
	unsigned key = static_cast<unsigned>((d_in[myId] - min_logLum) / range);
	if(key >= numBins)
	{
		key = numBins - 1;
	}
	/*d_out[key] += 1;*/
	atomicAdd(&d_out[key], 1);
	//just for check
	/*if(myId == 0)*/
	/*{*/
	/*}*/
}

void histogram(const float* const d_logluminance, const size_t numlen, unsigned* const d_hist, const float min_logLum, const float range, const size_t numBins)
{
	//BETTER: sum in a block first (all bins in shared memory for each block) and then scan and sum

	//NOTICE: if (x-min)/range is out of bound, bind it to largest bin
	/*printf("here is histogram!\n");*/
	int size = 1024;
	const dim3 threads(size, 1, 1);
	const dim3 blocks((numlen+size-1)/size, 1, 1);
	//NOTICE: set them to 0 first!
	checkCudaErrors(cudaMemset(d_hist, 0, sizeof(unsigned) * numBins));
	histogram_kernel<<<blocks, threads>>>(d_logluminance, d_hist, numlen, min_logLum, range, numBins);
	cudaDeviceSynchronize(); checkCudaErrors(cudaGetLastError());
}

__global__ void
presum_kernel(unsigned* const d_in, unsigned* const d_out, const size_t numBins)
{
	//NOTICE: if we do not know the size when compiling, use extern keyword and pass this parameter when launching the kernel
	extern __shared__ unsigned arr[];
	/*__shared__ unsigned* arr_out;*/
	int tid = threadIdx.x;
	int myId = tid + blockDim.x * blockIdx.x;
	if(myId >= numBins)
	{
		return;
	}
	arr[myId] = d_in[myId];
	__syncthreads();

	for(unsigned span = 1; span < numBins; span <<= 1)
	{
		if(myId < span)
		{
			//thsi can reduce the copy times
			break;
		}
		unsigned val = arr[myId-span];
		//NOTICE: only sync in each block
		__syncthreads();
		arr[myId] += val;
		__syncthreads();
	}
	//set d_out by exclusive presum
	if(myId == 0)
	{
		d_out[0] = 0;
	}
	if(myId < numBins - 1)
	{
		d_out[myId+1] = arr[myId];
	}
}

void presum(unsigned* const d_hist, const size_t numBins, unsigned int* const d_cdf)
{
	/*printf("here is presum!\n");*/
	int size = 1024;
	//NOTICE: there is only 1024 bins, so we can place them in a block! then the problem can be simplified
	//If several blocks, can compute parts in each block then add base!
	const dim3 threads(size, 1, 1);
	const dim3 blocks((numBins+size-1)/size, 1, 1);
	//NOTICE: we want to compute the exclusive scan, rather than the inclusive scan
	/*checkCudaErrors(cudaMemset(&d_cdf[0], 0, sizeof(unsigned)));*/
	presum_kernel<<<blocks, threads, sizeof(unsigned) * numBins>>>(d_hist, d_cdf, numBins);
	cudaDeviceSynchronize(); checkCudaErrors(cudaGetLastError());
}

//NOTICE: size_t is unsigned long
void your_histogram_and_prefixsum(const float* const d_logLuminance,
                                  unsigned int* const d_cdf,
                                  float &min_logLum,
                                  float &max_logLum,
                                  const size_t numRows,
                                  const size_t numCols,
                                  const size_t numBins)
{
  //TODO
  /*Here are the steps you need to implement
    1) find the minimum and maximum value in the input logLuminance channel
       store in min_logLum and max_logLum
    2) subtract them to find the range
    3) generate a histogram of all the values in the logLuminance channel using
       the formula: bin = (lum[i] - lumMin) / lumRange * numBins
    4) Perform an exclusive scan (prefix sum) on the histogram to get
       the cumulative distribution of luminance values (this should go in the
       incoming d_cdf pointer which already has been allocated for you)       */

	//NOTICE: numCols is the length of a picture, numRows is the width of a picture
	//blockSize((numCols+15)/16, (numRows+15)/16, 1) is a way to compute right blocks!

	//Be careful if overflow
	size_t numLen = numRows * numCols; 
	float *d_border, h_border;
	checkCudaErrors(cudaMalloc((void**)&d_border, sizeof(float)));
	//reduce to find the minium
	reduce(d_logLuminance, numLen, d_border, true); 
	checkCudaErrors(cudaMemcpy(&h_border, d_border, sizeof(float), cudaMemcpyDeviceToHost));

	min_logLum = h_border;
	//reduce to find the maxium
	reduce(d_logLuminance, numLen, d_border, false);  

	checkCudaErrors(cudaMemcpy(&h_border, d_border, sizeof(float), cudaMemcpyDeviceToHost));
	max_logLum = h_border;
	//free the device memory
	checkCudaErrors(cudaFree(d_border));

	//build the histogram struct
	float range = max_logLum - min_logLum;
	//NOTICE: this is the log luminance, so it can be negative, and the maximum is much smaller than 275
	/*printf("%f %lu\n", range, numBins);*/
	range = range / numBins;
	/*printf("min: %f max: %f range: %f\n", min_logLum, max_logLum, range);*/
	/*fflush(stdout);*/

	unsigned *d_hist;
	checkCudaErrors(cudaMalloc((void**)&d_hist, sizeof(unsigned) * numBins));
	histogram(d_logLuminance, numLen, d_hist, min_logLum, range, numBins); 
	cudaDeviceSynchronize(); checkCudaErrors(cudaGetLastError());

	//exclusive scan: not include hist[numBins-1]
	presum(d_hist, numBins, d_cdf);
	cudaDeviceSynchronize(); checkCudaErrors(cudaGetLastError());
	checkCudaErrors(cudaFree(d_hist));
}
