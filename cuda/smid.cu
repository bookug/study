//https://gist.github.com/allanmac/4751080
//https://codeday.me/bug/20190709/1417531.html
//compile: nvcc smid.cu -o smid
//QUESTION: a SM may have several blocks at the same moment.
//and, if only 3 block (we ensure the shared memory usage of each block, then 1 SM can only run 1 SM), they may  not be scheduled to run on SM 0-2?
//NOTICE: if we want to perform scalability test wrt the number of SMs, we do not need to care if SM 0-2 are used, we only need to ensure only 3 Sms are used.
//However, each block run a large portion of tasks, this may be severely imbalanced. The original strategy is to issue many blocks and let GPU schedule them freely.
//A better strategy of our case, will be to extract tasks from a queue iteratively. (But the maintainence of queue may bring an observable cost)
//
//STRATEGY: it seems that even without the restriction of shared memory, when the block num <= SM num, they will be scheduled to let only one block run on one SM.
//(It is understandable because the resource of one SM is limited, so one block a SM will deliver the best performance, when SMs are enough.)

#include <stdio.h>

#define DEVICE_INTRINSIC_QUALIFIERS   __device__ __forceinline__

DEVICE_INTRINSIC_QUALIFIERS
unsigned int
smid()
{
  unsigned int r;
  asm("mov.u32 %0, %%smid;" : "=r"(r));
  return r;
}

DEVICE_INTRINSIC_QUALIFIERS
unsigned int
nsmid()
{
#if (__CUDA_ARCH__ >= 200)
  unsigned int r;
  asm("mov.u32 %0, %%nsmid;" : "=r"(r));
  return r;
#else
  return 30;
#endif
}

__device__ int g_nsmid[1];
__device__ int g_smid[64] = {
  -1, -1, -1, -1, -1, -1, -1, -1,
  -1, -1, -1, -1, -1, -1, -1, -1,
  -1, -1, -1, -1, -1, -1, -1, -1,
  -1, -1, -1, -1, -1, -1, -1, -1,
  -1, -1, -1, -1, -1, -1, -1, -1,
  -1, -1, -1, -1, -1, -1, -1, -1,
  -1, -1, -1, -1, -1, -1, -1, -1,
  -1, -1, -1, -1, -1, -1, -1, -1
};

__global__
void
smidTest()
{
    /*__shared__ int s_pool[1024];*/
    /*__shared__ int s_pool[12*1024];*/
    /*s_pool[0] = 10;*/
    /*s_pool[0] += 2;*/
    //NOTICE: the applied dynamic shared memory is not explicitly used, but they are really allocated.

  const int n = nsmid();
  const int s = smid();

  //NOTICE: if below is commented, no -1 generated
    /*if(blockIdx.x > 20)*/
    /*{*/
        /*printf("found: %d\n", s);*/
    /*}*/

  g_nsmid[0] = n;
  int x = n;
  x *= n;
  if(g_smid[s] == -1)
  g_smid[s]  = s;
  else
      g_smid[s] = -1;

  if(threadIdx.x == 0)
  {
      printf("sm %d\n", s);
  }
}

int main(int argc, char **argv)
{
  cudaError_t err;
  int         device = (argc == 1) ? 0 : atoi(argv[1]);

  cudaDeviceProp props;
  err = cudaGetDeviceProperties(&props,device);

  if (err) 
    return -1;

  // if (props.major < 2) {
  //   printf("%s = sm_%d%d\n",props.name,props.major,props.minor);
  //   return -1;
  // }

  cudaSetDevice(device);
                            
  //
  // LAUNCH KERNEL
  //
  
  //NOTICE: the setting of shared memory usage is to ensure only one block reside in each SM.
  /*smidTest<<<props.multiProcessorCount,1,props.sharedMemPerBlock-384>>>();*/
  smidTest<<<props.multiProcessorCount,1>>>();
  /*smidTest<<<props.multiProcessorCount,1024>>>();*/
  /*smidTest<<<props.multiProcessorCount+3,1>>>();*/
  /*smidTest<<<props.multiProcessorCount*2,1>>>();*/
  /*smidTest<<<3,1>>>();*/
  cudaDeviceSynchronize();

  //
  // LOOK AT RESULTS
  //

  int h_nsmid[1];
  int h_smid[48];

  cudaMemcpyFromSymbol(h_nsmid,g_nsmid,sizeof(h_nsmid));
  cudaMemcpyFromSymbol(h_smid, g_smid, sizeof(h_smid));

  printf("%s (%2d) [ %2d",
         props.name,
         (h_nsmid[0] == 30) ? props.multiProcessorCount : h_nsmid[0],
         h_smid[0]);

  int last = 0;
  
  for (int ii=1; ii<h_nsmid[0]; ii++)
    {
      if (h_smid[ii] != -1)
        last = ii;
    }

  for (int ii=1; ii<=last; ii++)
    {
      const int s = h_smid[ii];
      if (s == -1)
        printf(", --");
      else
        printf(", %2d",s);
    }

  printf(" ]\n");

  return 0;
}

