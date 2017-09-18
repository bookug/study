//Udacity HW 4
//Radix Sorting

#include "utils.h"
#include <thrust/host_vector.h>

/* Red Eye Removal
   ===============
   
   For this assignment we are implementing red eye removal.  This is
   accomplished by first creating a score for every pixel that tells us how
   likely it is to be a red eye pixel.  We have already done this for you - you
   are receiving the scores and need to sort them in ascending order so that we
   know which pixels to alter to remove the red eye.

   Note: ascending order == smallest to largest

   Each score is associated with a position, when you sort the scores, you must
   also move the positions accordingly.

   Implementing Parallel Radix Sort with CUDA
   ==========================================

   The basic idea is to construct a histogram on each pass of how many of each
   "digit" there are.   Then we scan this histogram so that we know where to put
   the output of each digit.  For example, the first 1 must come after all the
   0s so we have to know how many 0s there are to be able to start moving 1s
   into the correct position.

   1) Histogram of the number of occurrences of each digit
   2) Exclusive Prefix Sum of Histogram
   3) Determine relative offset of each digit
        For example [0 0 1 1 0 0 1]
                ->  [0 1 0 1 2 3 2]
   4) Combine the results of steps 2 & 3 to determine the final
      output location for each element and move it there

   LSB Radix sort is an out-of-place sort and you will need to ping-pong values
   between the input and output buffers we have provided.  Make sure the final
   sorted results end up in the output buffer!  Hint: You may need to do a copy
   at the end.

 */

__global__ void
histogram_kernel(const unsigned int* const d_inputVals, const size_t numElems, unsigned bitBase, unsigned* const d_count, unsigned int* const d_outputVals, unsigned int* const d_outputPos)
{
	__shared__ unsigned s_cnt;
	s_cnt = 0;
	__syncthreads();

	int tid = threadIdx.x;
	int myId = tid + blockDim.x * blockIdx.x;
	if(myId >= numElems)
	{
		return;
	}
	//NOTICE: the result of & should not be compared with 1!
	/*unsigned ret = d_inputVals[myId] & bitBase;*/
	/*if(ret != 0)*/
	//NOTICE: we must use () for bitwise operations, otherwise error will come(priority of != is higher than &)
	/*if(d_inputVals[myId] & bitBase != 0)*/
	if((d_inputVals[myId] & bitBase) != 0)
	{
		d_outputPos[myId] = 1;
		d_outputVals[myId] = 0;
	}
	else
	{
		d_outputPos[myId] = 0;
		d_outputVals[myId] = 1;
		atomicAdd(&s_cnt, 1);
	}
	__syncthreads();

	if(tid == 0)  //the end
	{
		atomicAdd(&d_count[0], s_cnt);
	}
}

void histogram(const unsigned int* const d_inputVals, const size_t numElems, const unsigned bitBase, unsigned* const d_count, unsigned int* const d_outputVals, unsigned int* const d_outputPos)
{
	/*printf("here is histogram!\n");*/
	int size = 1024;
	const dim3 threads(size, 1, 1);
	const dim3 blocks((numElems+size-1)/size, 1, 1);
	//Only use the 0-th position
	checkCudaErrors(cudaMemset(d_count, 0, sizeof(unsigned)));
	histogram_kernel<<<blocks, threads>>>(d_inputVals, numElems, bitBase, d_count, d_outputVals, d_outputPos);
	cudaDeviceSynchronize(); checkCudaErrors(cudaGetLastError());
	/*unsigned ret;*/
	/*checkCudaErrors(cudaMemcpy(&ret, &d_count[1], sizeof(unsigned), cudaMemcpyDeviceToHost));*/
	/*return ret;*/
}

//NOTICE: the minium unit of executing threads is WARP(a group of 16 or 32 threads)
//If the if-else or loops in a kernel --> too many threads do nop operations in a warp! then the performance will be bad
//http://www.myexception.cn/cuda/1931284.html

//METHOD: to sync between Blocks
//1. construct a lock variable in global memory, and use barrier for each thread
//http://bbs.csdn.net/topics/330255319
//2. divide into different kernels, and do each kernel a time
//3. http://bbs.csdn.net/topics/390828048  http://blog.csdn.net/groundhappy/article/details/54173387

__global__ void
presum_kernel(unsigned* const d_in, unsigned* const d_out, const size_t numElems, const unsigned span)
{
	int tid = threadIdx.x;
	int myId = tid + blockDim.x * blockIdx.x;
	if(myId >= numElems)
	{
		return;
	}

	/*for(unsigned span = 1; span < numElems; span <<= 1)*/
	if(myId < span)
	{
		d_out[myId] = d_in[myId];
	}
	else
	{
		d_out[myId] = d_in[myId] + d_in[myId-span];
	}
}

__global__ void
combine_kernel(const unsigned int* d_inputVals, unsigned int* const d_outputVals, unsigned int* const d_outputPos, unsigned int* const d_buffer, const size_t numElems, const unsigned bitBase, const unsigned* const d_count)
{
	__shared__ unsigned d_base;
	d_base = d_count[0];
	__syncthreads();

	int tid = threadIdx.x;
	int myId = tid + blockDim.x * blockIdx.x;
	if(myId >= numElems)
	{
		return;
	}
	//set d_out by exclusive presum
	unsigned ret = d_inputVals[myId] & bitBase;
	if(myId == 0)
	{
		if(ret != 0)
		{
			d_buffer[0] = d_base;
		}
		else
		{
			d_buffer[0] = 0;
		}
		return;
	}
	if(ret != 0)
	{
		d_buffer[myId] = d_outputPos[myId-1] + d_base;
	}
	else
	{
		d_buffer[myId] = d_outputVals[myId-1];
	}
}

void presum(const unsigned int* d_inputVals, unsigned int* const d_outputVals, unsigned int* const d_outputPos, const size_t numElems, unsigned* const d_buffer, const unsigned bitBase, const unsigned* const d_count)
{
	/*printf("here is histogram!\n");*/
	int size = 1024;
	const dim3 threads(size, 1, 1);
	const dim3 blocks((numElems+size-1)/size, 1, 1);
	//NOTICE: the threads can not be played in a single block, so the __syncthreads not works for all threads
	//As a result, we can not do this prefix-sum in-place, which means we need another array for help
	unsigned* d_ptr[2]; d_ptr[0] = d_outputVals, d_ptr[1] = d_outputPos;

	for(unsigned idx = 0; idx < 2; ++idx)
	{
		unsigned *d_out = d_ptr[idx], *d_in = d_buffer, *d_tmp;
		//BETTER: when there are only a few additions for a large span, no need for so many threads
		for(unsigned span = 1; span < numElems; span <<= 1)
		{
			d_tmp = d_in; d_in = d_out; d_out = d_tmp;
			presum_kernel<<<blocks, threads>>>(d_in, d_out, numElems, span);
			cudaDeviceSynchronize(); checkCudaErrors(cudaGetLastError());
		}
		if(d_out != d_ptr[idx])
		{
			checkCudaErrors(cudaMemcpy(d_ptr[idx], d_out, sizeof(unsigned) * numElems, cudaMemcpyDeviceToDevice));
		}
	}

	/*unsigned xxx[7];*/
		/*checkCudaErrors(cudaMemcpy(xxx, d_outputVals, sizeof(unsigned) * 7, cudaMemcpyDeviceToHost));*/
		/*printf("check index before combine: %u %u %u %u %u %u %u\n", xxx[0], xxx[1], xxx[2], xxx[3], xxx[4], xxx[5], xxx[6]);*/
		/*checkCudaErrors(cudaMemcpy(xxx, d_outputPos, sizeof(unsigned) * 7, cudaMemcpyDeviceToHost));*/
		/*printf("check index before combine: %u %u %u %u %u %u %u\n", xxx[0], xxx[1], xxx[2], xxx[3], xxx[4], xxx[5], xxx[6]);*/

	//combine two position arrays, and place in d_buffer
	combine_kernel<<<blocks, threads>>>(d_inputVals, d_outputVals, d_outputPos, d_buffer, numElems, bitBase, d_count);
	cudaDeviceSynchronize(); checkCudaErrors(cudaGetLastError());
}

__global__ void
scatter_kernel(const unsigned int* const d_inputVals, const unsigned int* d_inputPos, unsigned int* const d_outputVals, unsigned int* const d_outputPos, const size_t numElems, unsigned* const d_buffer)
{
	int tid = threadIdx.x;
	int myId = tid + blockDim.x * blockIdx.x;
	if(myId >= numElems)
	{
		return;
	}
	int key = d_buffer[myId];
	d_outputVals[key] = d_inputVals[myId];
	d_outputPos[key] = d_inputPos[myId];
}

void scatter(unsigned int* const d_inputVals, unsigned int* const d_inputPos, unsigned int* const d_outputVals, unsigned int* const d_outputPos, const size_t numElems, unsigned* const d_buffer)
{
	/*printf("here is histogram!\n");*/
	int size = 1024;
	const dim3 threads(size, 1, 1);
	const dim3 blocks((numElems+size-1)/size, 1, 1);
	scatter_kernel<<<blocks, threads>>>(d_inputVals, d_inputPos, d_outputVals, d_outputPos, numElems, d_buffer);
	cudaDeviceSynchronize(); checkCudaErrors(cudaGetLastError());
}

__global__ void
reduce_kernel(unsigned* const d_out, unsigned* const d_in, const size_t curlen)
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
			unsigned tmp1 = d_in[myId], tmp2 = d_in[myId+s];
			d_in[myId] = max(tmp1, tmp2);
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

//find the maxium number
unsigned reduce(const unsigned* const d_inputVals, const size_t numlen)
{
	/*printf("here is reduce!\n");*/
	int limit = log(numlen)/log(2) + 1;
	int size = 1024;
	const dim3 threads(size, 1, 1);
	int curlen = numlen;
	unsigned*  d_in;
	unsigned* d_mid;
	checkCudaErrors(cudaMalloc((void**)&d_in, sizeof(unsigned) * numlen));
	checkCudaErrors(cudaMemcpy(d_in, d_inputVals, sizeof(unsigned) * numlen, cudaMemcpyDeviceToDevice));

	/*printf("begin while loop!\n");*/
	while(limit--)
	{
		/*printf("loop loop\n");*/
		int num_blocks = curlen / size;
		if(curlen % size != 0)
		{
			num_blocks ++;
		}
		checkCudaErrors(cudaMalloc((void**)&d_mid, sizeof(unsigned) * num_blocks));

		const dim3 blocks(num_blocks, 1, 1);
		reduce_kernel<<<blocks, threads>>>(d_mid, d_in, curlen);
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

	unsigned ret;
	//the result is in d_mid
	checkCudaErrors(cudaMemcpy(&ret, &d_mid[0], sizeof(unsigned), cudaMemcpyDeviceToHost));
	//NOTICE: below is error, device memory can not be copied directly in the host code
	//while in kernel code, device memory can be used directly
	/**d_border = d_mid[0];*/
	checkCudaErrors(cudaFree(d_mid));
	return ret;
}

void radix_sort(unsigned int* const d_inputVals,
               unsigned int* const d_inputPos,
               unsigned int* const d_outputVals,
               unsigned int* const d_outputPos,
               const size_t numElems)
{ 
	//NOTICE: there can be duplicates in an array to be sorted
	/*printf("numElems: %lu\n", numElems);  //220480*/
	//inputVals is the key and inputPos is the value
	int size = 1024;
	const dim3 threads(size, 1, 1);
	const dim3 blocks((numElems+size-1)/size, 1, 1);
	//NOTICE: Radix Sort can use many kinds of Hash Function, we use 2 as the base here
	unsigned hashBase = 2;
	unsigned bitBase = 1;  //use << bitwise operation to change in each loop
	unsigned *d_count;
	checkCudaErrors(cudaMalloc((void**)&d_count, sizeof(unsigned) * hashBase));
	unsigned *d_buffer;
	checkCudaErrors(cudaMalloc((void**)&d_buffer, sizeof(unsigned) * numElems));
	unsigned addBase = 0;
	unsigned *d_in1 = d_inputVals, *d_in2 = d_inputPos, *d_out1 = d_outputVals, *d_out2 = d_outputPos, *d_tmp;
	unsigned step = 0;
	unsigned limit = 32;
	/*unsigned limit = reduce(d_inputVals, numElems);*/
	/*limit = log(limit)/log(2) + 1;*/
	/*if(limit > 32) limit = 32;*/
	/*printf("limit: %u\n", limit);*/
	
	cudaEvent_t start ,stop;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	while(step < limit)  //32 is the limit of bits of unsigned type
	{
		cudaEventRecord(start, 0);
		/*printf("this is the %d-th step\n", step);*/
		/*unsigned xxx[7]; checkCudaErrors(cudaMemcpy(xxx, d_in1, sizeof(unsigned) * 7, cudaMemcpyDeviceToHost));*/
		/*printf("check: %u %u %u %u %u %u %u\n", xxx[0], xxx[1], xxx[2], xxx[3], xxx[4], xxx[5], xxx[6]);*/
		/*printf("check: %u %u %u\n", xxx[0] & bitBase, xxx[1] & bitBase, xxx[2] & bitBase);*/

		//base1 is for digit 0, while base2 is for digit 1
		//NOTICE: we needn't count the num of 1, just count the num of 0 is ok
		histogram(d_in1, numElems, bitBase, d_count, d_out1, d_out2);
		/*printf("histogram finished\n");*/
		step++;

		/*checkCudaErrors(cudaMemcpy(&addBase, &d_count[0], sizeof(unsigned), cudaMemcpyDeviceToHost));*/
		/*printf("addBase: %u bitBase: %u\n", addBase, bitBase);*/
		/*checkCudaErrors(cudaMemcpy(xxx, d_out1, sizeof(unsigned) * 7, cudaMemcpyDeviceToHost));*/
		/*printf("check out1: %u %u %u %u %u %u %u\n", xxx[0], xxx[1], xxx[2], xxx[3], xxx[4], xxx[5], xxx[6]);*/
		/*checkCudaErrors(cudaMemcpy(xxx, d_out2, sizeof(unsigned) * 7, cudaMemcpyDeviceToHost));*/
		/*printf("check out2: %u %u %u %u %u %u %u\n", xxx[0], xxx[1], xxx[2], xxx[3], xxx[4], xxx[5], xxx[6]);*/
		/*getchar();*/

		if(addBase == numElems)
		{
			/*printf("needless loop\n");*/
			bitBase <<= 1;
			//NOTICE: we can not break directly here, because it is ok for all numbers to be 0 at the i-th digit
			continue;
		}

		//use d_count as addBase in shared memory
		presum(d_in1, d_out1, d_out2, numElems, d_buffer, bitBase, d_count);
		/*printf("presum finished\n");*/

		/*checkCudaErrors(cudaMemcpy(xxx, d_buffer, sizeof(unsigned) * 3, cudaMemcpyDeviceToHost));*/
		/*printf("check index: %u %u %u\n", xxx[0], xxx[1], xxx[2]);*/

		//scatter: both key and value to output according to mapping in d_buffer
		scatter(d_in1, d_in2, d_out1, d_out2, numElems, d_buffer);
		/*printf("scatter finished\n");*/
		bitBase <<= 1;
		d_tmp = d_in1; d_in1 = d_out1; d_out1 = d_tmp;
		d_tmp = d_in2; d_in2 = d_out2; d_out2 = d_tmp;

		cudaEventRecord(stop, 0);
		cudaEventSynchronize(stop);
		float elapsedTime;
		cudaEventElapsedTime(&elapsedTime, start, stop);
		/*elapsedTime /= 100.0f;*/
		printf("average time elapsed: %fms\n", elapsedTime);
	}

	if(d_in1 != d_outputVals)
	{
		//NOTICE: we believe device-to-device copy is very fast, so do not use multithreading to copy by myself
		checkCudaErrors(cudaMemcpy(d_outputVals, d_in1, sizeof(unsigned) * numElems, cudaMemcpyDeviceToDevice));
		checkCudaErrors(cudaMemcpy(d_outputPos, d_in2, sizeof(unsigned) * numElems, cudaMemcpyDeviceToDevice));
	}

	checkCudaErrors(cudaFree(d_count));
	checkCudaErrors(cudaFree(d_buffer));
}

void your_sort(unsigned int* const d_inputVals,
               unsigned int* const d_inputPos,
               unsigned int* const d_outputVals,
               unsigned int* const d_outputPos,
               const size_t numElems)
{ 
  //TODO
  //PUT YOUR SORT HERE

	/*unsigned arr[] = {6, 0, 3, 1, 4, 2, 5};*/
	/*unsigned *d_in1, *d_in2, *d_out1, *d_out2, num = 7;*/
	/*checkCudaErrors(cudaMalloc((void**)&d_in1, sizeof(unsigned) * num));*/
	/*checkCudaErrors(cudaMalloc((void**)&d_in2, sizeof(unsigned) * num));*/
	/*checkCudaErrors(cudaMalloc((void**)&d_out1, sizeof(unsigned) * num));*/
	/*checkCudaErrors(cudaMalloc((void**)&d_out2, sizeof(unsigned) * num));*/
	/*checkCudaErrors(cudaMemcpy(d_in1, arr, sizeof(unsigned) * num, cudaMemcpyHostToDevice));*/
	/*checkCudaErrors(cudaMemcpy(d_in2, arr, sizeof(unsigned) * num, cudaMemcpyHostToDevice));*/
	/*radix_sort(d_in1, d_in2, d_out1, d_out2, num);*/
	/*checkCudaErrors(cudaFree(d_in1));*/
	/*checkCudaErrors(cudaFree(d_in2));*/
	/*checkCudaErrors(cudaFree(d_out1));*/
	/*checkCudaErrors(cudaFree(d_out2));*/

	cudaSetDevice(0);
	radix_sort(d_inputVals, d_inputPos, d_outputVals, d_outputPos, numElems);
}

