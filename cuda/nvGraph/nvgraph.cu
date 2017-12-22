//HELP: http://blog.csdn.net/augusdi/article/details/12833235
//BETTER: 
//1. when use float, we had better add f like 0.1f (otherwise will use double, which consumes 64 bits)
//2. cudaHostMalloc,  cudaHostRegister    cudaMemcpyAsync
//3. use stream for efficiency, but take care of safety


//nvGraph: http://docs.nvidia.com/cuda/nvgraph/index.html
//nvcc -lnvgraph 

#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>
#include <nvgraph.h>

__global__ void global_reduce_kernel(float * d_out, float * d_in)
{
    int myId = threadIdx.x + blockDim.x * blockIdx.x;
    int tid  = threadIdx.x;

    // do reduction in global mem
    for (unsigned int s = blockDim.x / 2; s > 0; s >>= 1)
    {
        if (tid < s)
        {
            d_in[myId] += d_in[myId + s];
        }
        __syncthreads();        // make sure all adds at one stage are done!
    }

    // only thread 0 writes result for this block back to global mem
    if (tid == 0)
    {
        d_out[blockIdx.x] = d_in[myId];
    }
}

__global__ void shmem_reduce_kernel(float * d_out, const float * d_in)
{
    // sdata is allocated in the kernel call: 3rd arg to <<<b, t, shmem>>>
    extern __shared__ float sdata[];

    int myId = threadIdx.x + blockDim.x * blockIdx.x;
    int tid  = threadIdx.x;

    // load shared mem from global mem
    sdata[tid] = d_in[myId];
    __syncthreads();            // make sure entire block is loaded!

    // do reduction in shared mem
    for (unsigned int s = blockDim.x / 2; s > 0; s >>= 1)
    {
        if (tid < s)
        {
            sdata[tid] += sdata[tid + s];
        }
        __syncthreads();        // make sure all adds at one stage are done!
    }

    // only thread 0 writes result for this block back to global mem
    if (tid == 0)
    {
        d_out[blockIdx.x] = sdata[0];
    }
}

void reduce(float * d_out, float * d_intermediate, float * d_in, 
            int size, bool usesSharedMemory)
{
    // assumes that size is not greater than maxThreadsPerBlock^2
    // and that size is a multiple of maxThreadsPerBlock
    const int maxThreadsPerBlock = 1024;
    int threads = maxThreadsPerBlock;
    int blocks = size / maxThreadsPerBlock;
    if (usesSharedMemory)
    {
        shmem_reduce_kernel<<<blocks, threads, threads * sizeof(float)>>>
            (d_intermediate, d_in);
    }
    else
    {
        global_reduce_kernel<<<blocks, threads>>>
            (d_intermediate, d_in);
    }
    // now we're down to one block left, so reduce it
    threads = blocks; // launch one thread for each block in prev step
    blocks = 1;
    if (usesSharedMemory)
    {
        shmem_reduce_kernel<<<blocks, threads, threads * sizeof(float)>>>
            (d_out, d_intermediate);
    }
    else
    {
        global_reduce_kernel<<<blocks, threads>>>
            (d_out, d_intermediate);
    }
}

int main(int argc, char **argv)
{
    int deviceCount;
    cudaGetDeviceCount(&deviceCount);
    if (deviceCount == 0) {
        fprintf(stderr, "error: no devices supporting CUDA.\n");
        exit(EXIT_FAILURE);
    }
    int dev = 0;
    cudaSetDevice(dev);

	nvgraphHandle_t gg;
	nvgraphStatus_t ret = nvgraphCreate(&gg);
	nvgraphDestroy(gg);

	//NOTE: 48KB shared memory per block, 1024 threads per block, 28 SMs
    cudaDeviceProp devProps;
    if (cudaGetDeviceProperties(&devProps, dev) == 0)
    {
        printf("Using device %d:\n", dev);
        printf("%s; global mem: %dB; compute v%d.%d; clock: %d kHz; shared mem: %dB; block threads: %d; SM count: %d\n",
               devProps.name, (int)devProps.totalGlobalMem, 
               (int)devProps.major, (int)devProps.minor, 
               (int)devProps.clockRate,
			   devProps.sharedMemPerBlock, devProps.maxThreadsPerBlock, devProps.multiProcessorCount);
    }

    const int ARRAY_SIZE = 1 << 20;
    const int ARRAY_BYTES = ARRAY_SIZE * sizeof(float);

    // generate the input array on the host
    float h_in[ARRAY_SIZE];
    float sum = 0.0f;
    for(int i = 0; i < ARRAY_SIZE; i++) {
        // generate random float in [-1.0f, 1.0f]
        h_in[i] = -1.0f + (float)random()/((float)RAND_MAX/2.0f);
        sum += h_in[i];
    }

    // declare GPU memory pointers
    float * d_in, * d_intermediate, * d_out;

    // allocate GPU memory
    cudaMalloc((void **) &d_in, ARRAY_BYTES);
    cudaMalloc((void **) &d_intermediate, ARRAY_BYTES); // overallocated
    cudaMalloc((void **) &d_out, sizeof(float));

    // transfer the input array to the GPU
    cudaMemcpy(d_in, h_in, ARRAY_BYTES, cudaMemcpyHostToDevice); 

    int whichKernel = 0;
    if (argc == 2) {
        whichKernel = atoi(argv[1]);
    }
        
    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    // launch the kernel
    switch(whichKernel) {
    case 0:
        printf("Running global reduce\n");
        cudaEventRecord(start, 0);
        for (int i = 0; i < 100; i++)
        {
            reduce(d_out, d_intermediate, d_in, ARRAY_SIZE, false);
        }
        cudaEventRecord(stop, 0);
        break;
    case 1:
        printf("Running reduce with shared mem\n");
        cudaEventRecord(start, 0);
        for (int i = 0; i < 100; i++)
        {
            reduce(d_out, d_intermediate, d_in, ARRAY_SIZE, true);
        }
        cudaEventRecord(stop, 0);
        break;
    default:
        fprintf(stderr, "error: ran no kernel\n");
        exit(EXIT_FAILURE);
    }
	//NOTICE: when we launch a kernel, the kernel is runned asynchronily
	//In order to compute the time of cudaMemcpy(not including the time of running kernel function), cuda event should be used!
    cudaEventSynchronize(stop);
    float elapsedTime;
    cudaEventElapsedTime(&elapsedTime, start, stop);    
    elapsedTime /= 100.0f;      // 100 trials

    // copy back the sum from GPU
    float h_out;
    cudaMemcpy(&h_out, d_out, sizeof(float), cudaMemcpyDeviceToHost);

    printf("average time elapsed: %f\n", elapsedTime);

    // free GPU memory allocation
    cudaFree(d_in);
    cudaFree(d_intermediate);
    cudaFree(d_out);
        
    return 0;
}
