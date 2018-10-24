/*=============================================================================
# Filename: memory.cu
# Author: bookug 
# Mail: bookug@qq.com
# Last Modified: 2018-10-24 01:07
# Description: 
verify the efficiency of dynamic memory allocation scheduling
=============================================================================*/

#include <stdio.h>
#include <cuda.h> 
#include <cuda_runtime.h> 
#include <cuda_runtime_api.h> 
#include <cassert>
#include <curand.h> 

#include "Util.h" 

using namespace std;

#define checkCudaErrors(val) check( (val), #val, __FILE__, __LINE__)
#define ERROR_EXIT -1
/*#define NUM_BLOCKS 1*/
#define NUM_BLOCKS 1000
#define BLOCK_WIDTH 1024
#define BASE 1000
#define LIMIT 900

template<typename T>
void check(T err, const char* const func, const char* const file, const int line) {
  if (err != cudaSuccess) {
    printf("CUDA error at: %s:%d\n", file, line);
    printf("%s %s\n", cudaGetErrorString(err), func);
    exit(1);
  }
}
/* Check the return value of CUDA Runtime API */
#define CHECK_CUDA(err) do{\
    if((err) != cudaSuccess){\
            fprintf(stderr, "CUDA Runtime API error %d at file %s line %d: %s.\n",\
                                                   (int)(err), __FILE__, __LINE__, cudaGetErrorString((err)));\
            exit(ERROR_EXIT);\
        }}while(0)

/* Check the return value of CURAND api. */
#define CHECK_CURAND(err) do{\
    if( (err) != CURAND_STATUS_SUCCESS  ){\
            fprintf(stderr, "CURAND error %d at file %s line %d.\n", (int)(err), __FILE__, __LINE__);\
        exit(ERROR_EXIT);\
        }}while(0)

extern "C"
void randomGenerator(float *dataHost, int number, unsigned long long seed)
{   
    //SEE: https://blog.csdn.net/warren912/article/details/19962823
    float *dataDev;
    CHECK_CUDA( cudaMalloc( (void **) &dataDev, number * sizeof(float)  )  );
 
    curandGenerator_t gen;
    CHECK_CURAND( curandCreateGenerator(&gen, CURAND_RNG_PSEUDO_DEFAULT)  );
    CHECK_CURAND( curandSetPseudoRandomGeneratorSeed(gen, seed)  );
    CHECK_CURAND( curandGenerateUniform(gen, dataDev, number)  );
    CHECK_CURAND( curandDestroyGenerator(gen)  );
 
    CHECK_CUDA( cudaMemcpy(dataHost, dataDev, number * sizeof(float), cudaMemcpyDeviceToHost)  );
    CHECK_CUDA( cudaFree(dataDev)  );
 
    return;
}

void initGPU(int dev)
{
    int deviceCount;
    cudaGetDeviceCount(&deviceCount);
    if (deviceCount == 0) {
        fprintf(stderr, "error: no devices supporting CUDA.\n");
        exit(EXIT_FAILURE);
    }
    cudaSetDevice(dev);
	//NOTE: 48KB shared memory per block, 1024 threads per block, 30 SMs and 128 cores per SM
    cudaDeviceProp devProps;
    if (cudaGetDeviceProperties(&devProps, dev) == 0)
    {
        printf("Using device %d:\n", dev);
        printf("%s; global mem: %luB; compute v%d.%d; clock: %d kHz; shared mem: %dB; block threads: %d; SM count: %d\n",
               devProps.name, devProps.totalGlobalMem, 
               (int)devProps.major, (int)devProps.minor, 
               (int)devProps.clockRate,
			   devProps.sharedMemPerBlock, devProps.maxThreadsPerBlock, devProps.multiProcessorCount);
    }
	cout<<"GPU selected"<<endl;
	//GPU initialization needs several seconds, so we do it first and only once
	//https://devtalk.nvidia.com/default/topic/392429/first-cudamalloc-takes-long-time-/
	int* warmup = NULL;
	/*unsigned long bigg = 0x7fffffff;*/
	/*cudaMalloc(&warmup, bigg);*/
	/*cout<<"warmup malloc"<<endl;*/
	cudaMalloc(&warmup, sizeof(int));
	cudaFree(warmup);
	cout<<"GPU warmup finished"<<endl;
	unsigned long size = 0x7fffffff;
	/*size *= 3;   //heap corruption for 3 and 4*/
	size *= 2;
    //NOTICE: it is ok to expand the heap memory capacity to 8G if using long type
    //However, it is not suggested because the remaining memory is too small
    //In fact, the program not ends if using 8G heap memory
    //Once you set the memory limit, then you will see the limit occupation if using nvidia-smi command to see, but it not really occupy so much at once
    /*size *= 2;*/
	//NOTICE: the memory alloced by cudaMalloc is different from the GPU heap(for new/malloc in kernel functions)
	cudaDeviceSetLimit(cudaLimitMallocHeapSize, size);
	cudaDeviceGetLimit(&size, cudaLimitMallocHeapSize);
	cout<<"check heap limit: "<<size<<endl;

	// Runtime API
	// cudaFuncCachePreferShared: shared memory is 48 KB
	// cudaFuncCachePreferEqual: shared memory is 32 KB
	// cudaFuncCachePreferL1: shared memory is 16 KB
	// cudaFuncCachePreferNone: no preference
	/*cudaFuncSetCacheConfig(MyKernel, cudaFuncCachePreferShared)*/
	//The initial configuration is 48 KB of shared memory and 16 KB of L1 cache
	//The maximum L2 cache size is 3 MB.
	//also 48 KB read-only cache: if accessed via texture/surface memory, also called texture cache;
	//or use _ldg() or const __restrict__
	//64KB constant memory, ? KB texture memory. cache size?
	//CPU的L1 cache是根据时间和空间局部性做出的优化，但是GPU的L1仅仅被设计成针对空间局部性而不包括时间局部性。频繁的获取L1不会导致某些数据驻留在cache中，只要下次用不到，直接删。
	//L1 cache line 128B, L2 cache line 32B, notice that load is cached while store not
	//mmeory read/write is in unit of a cache line
	//the word size of GPU is 32 bits
}


//Dynamic memory allocation in the kernel function of GPU
//https://docs.nvidia.com/cuda/cuda-c-programming-guide/index.html#dynamic-global-memory-allocation-and-operations
//very slow, dozens of times slower than pre-assigned memory

__global__ void apply1_kernel(float* d_data)
{
    unsigned size = BASE * d_data[threadIdx.x];
    unsigned* ptr = (unsigned*)malloc(size * sizeof(unsigned));
    /*printf("check: thread %d apply %u\n", threadIdx.x, size);*/
}

__global__ void apply2_kernel(float* d_data)
{
    //BETTER: the block size and shared memory usage can be adjusted according to the architecture of GPU

    /*__shared__ int vote;*/
    /*vote = threadIdx.x;*/
    /*__syncthreads();*/
    /*printf("thread %d control the warp %d", vote, threadIdx.x >> 5);*/

    //NOTICE: here we use warp reduce and apply for heap memory as a warp/block
    //if warp_reduce() is extracted to be a device function, then volatile is needed
    //https://blog.csdn.net/q583956932/article/details/81608798
    __shared__ unsigned size[1024];
    size[threadIdx.x] = BASE * d_data[threadIdx.x];
    //here each warp is synchronized
    /*int warp = threadIdx.x >> 5;*/
    int idx = threadIdx.x & 0x1f;
    for(int i = 1; i < 32; i <<= 1)
    {
        int k = 32 - i;
        if(idx < k)
        {
            size[threadIdx.x] += size[threadIdx.x+i];
        }
    }
    if(idx == 0)
    {
        unsigned* ptr = (unsigned*)malloc(size[threadIdx.x] * sizeof(unsigned));
        /*printf("check: warp %d apply %u\n", warp, size[threadIdx.x]);*/
    }
    //TODO: if pointers are needed, then we need to do a prefix-scan on warp, and the pointer of each thread is ptr+offset
    //or using block?  combine apply2 and apply3 because it will be more easy to load balance
}

__global__ void apply3_kernel(float* d_data)
{
    unsigned size = BASE * d_data[threadIdx.x];
    if(size > LIMIT)
    {
        //BETTER: utilizing the original array space, and use the final 3*4 bytes to place flag and pointer of linked list
        unsigned* ptr = (unsigned*)malloc(size * sizeof(unsigned));
    }
}

void apply3(float* d_data)
{
    unsigned* d_result = NULL;
    CHECK_CUDA( cudaMalloc( (void **) &d_result, LIMIT * BLOCK_WIDTH * NUM_BLOCKS * sizeof(unsigned)  )  );
    apply3_kernel<<<NUM_BLOCKS, BLOCK_WIDTH>>>(d_data);
}

int main(int argc, const char* argv[])
{
	int dev = 0;
	if(argc == 2)
	{
		dev = atoi(argv[1]);
	}
    initGPU(dev);

    //BETTER: using srand()
    //ULL is a suffix to indicate the type(in case of overflow)
    unsigned long long seed = 1234ULL;
    float* h_data = (float*)malloc(BLOCK_WIDTH * sizeof(float));
    randomGenerator(h_data, BLOCK_WIDTH, seed);
    float* d_data = NULL;
    CHECK_CUDA( cudaMalloc( (void **) &d_data, BLOCK_WIDTH * sizeof(float)  )  );
    CHECK_CUDA( cudaMemcpy(d_data, h_data, BLOCK_WIDTH * sizeof(float), cudaMemcpyHostToDevice)  );
    xfree(h_data);

    long t1 = Util::get_cur_time();

    //RESULT: apply1 uses 45s, apply2 uses 30ms, apply3 uses 1s (512), 16ms(1000), 88ms(900)
    /*apply1_kernel<<<NUM_BLOCKS, BLOCK_WIDTH>>>(d_data);*/
    /*apply2_kernel<<<NUM_BLOCKS, BLOCK_WIDTH>>>(d_data);*/
    apply3(d_data);
	//Below checks if the kernel launches successfully
	checkCudaErrors(cudaGetLastError());

	//force the printf()s to flush
	cudaDeviceSynchronize();
	//Below checks if the kernel runs and ends successfully
	checkCudaErrors(cudaGetLastError());

    long t2 = Util::get_cur_time();
    printf("apply used %lu ms\n", t2 - t1);

    //NOTICE: if we do not release the memory dynamically allocated in kernel functions, they will be resident on GPU mmeory and can be used by later kernel functions(cudaDeviceSynchronize does not collect the memory)
    //however, if the whole program exits, these mmeory will also be recycled by GPU
    getchar();
    //stop here to see memory cost using nvidia-smi

    CHECK_CUDA(cudaFree(d_data));
    d_data = NULL;

	printf("That's all!\n");

	return 0;
}

