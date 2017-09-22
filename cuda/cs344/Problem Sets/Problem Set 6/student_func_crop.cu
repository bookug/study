//Udacity HW 6
//Poisson Blending

/* Background
   ==========

   The goal for this assignment is to take one image (the source) and
   paste it into another image (the destination) attempting to match the
   two images so that the pasting is non-obvious. This is
   known as a "seamless clone".

   The basic ideas are as follows:

   1) Figure out the interior and border of the source image
   2) Use the values of the border pixels in the destination image 
      as boundary conditions for solving a Poisson equation that tells
      us how to blend the images.
   
      No pixels from the destination except pixels on the border
      are used to compute the match.

   Solving the Poisson Equation
   ============================

   There are multiple ways to solve this equation - we choose an iterative
   method - specifically the Jacobi method. Iterative methods start with
   a guess of the solution and then iterate to try and improve the guess
   until it stops changing.  If the problem was well-suited for the method
   then it will stop and where it stops will be the solution.

   The Jacobi method is the simplest iterative method and converges slowly - 
   that is we need a lot of iterations to get to the answer, but it is the
   easiest method to write.

   Jacobi Iterations
   =================

   Our initial guess is going to be the source image itself.  This is a pretty
   good guess for what the blended image will look like and it means that
   we won't have to do as many iterations compared to if we had started far
   from the final solution.

   ImageGuess_prev (Floating point)
   ImageGuess_next (Floating point)

   DestinationImg
   SourceImg

   Follow these steps to implement one iteration:

   1) For every pixel p in the interior, compute two sums over the four neighboring pixels:
      Sum1: If the neighbor is in the interior then += ImageGuess_prev[neighbor]
             else if the neighbor in on the border then += DestinationImg[neighbor]

      Sum2: += SourceImg[p] - SourceImg[neighbor]   (for all four neighbors)

   2) Calculate the new pixel value:
      float newVal= (Sum1 + Sum2) / 4.f  <------ Notice that the result is FLOATING POINT
      ImageGuess_next[p] = min(255, max(0, newVal)); //clamp to [0, 255]


    In this assignment we will do 800 iterations.
   */



#include "utils.h"
#include <thrust/host_vector.h>

//NOTICE: there are two ways to end the iterations:
//1. set a tiny threshold, and stop when difference between the previous and the current is smaller than it
//2. set a limit of iteration num
#define LIMIT 800

//ANALYSIS: the source image is really sparse, so we must compress it to be placed in a block's shared memory(<= 48KB)
//However, this sparse graph is very special, and CSR is not fit here due to its complexity
//(and maybe not so efficient due to its separated visits to memory)
//In the source graph, only the small part of center is useful, so we can use offset and a small matrix to represent
//(which is more simple, and can help save more memory)
//In fact, CSR is just like place an adjacent list in an array
typedef unsigned char uchar;
typedef struct ImageMask
{
	//BETTER: use bitwise
	//0:white 1:interior 2:border
	uchar* value;
	unsigned start_x, start_y;
	unsigned size_x, size_y;
}Mask;
unsigned countMask(Mask* mask)
{
	return sizeof(bool) * mask->size_x * mask->size_y;
}
//we assume that x and y is valid
int checkMask(Mask* mask, unsigned x, unsigned y)
{
	//0:white  1:interior  2:border
	unsigned end_x = mask->start_x + mask->size_x - 1;
	unsigned end_y = mask->start_y + mask->size_y - 1;
	if(x < mask->start_x || y < mask->start_y || x > end_x || y > end_y)
	{
		return 0;
	}
	unsigned pos = y * mask->size_x + x;
	return mask->value[pos];
}
void freeMask(Mask* d_mask)
{
	checkCudaErrors(cudaFree(d_mask->value));
	checkCudaErrors(cudaFree(d_mask));
	d_mask = NULL;
}

void computeMask(const uchar4* const d_sourceImg, Mask* const d_mask, const size_t numRows, const size_t numCols)
{
	//TODO: alloc and build the mask
	cudaDeviceSynchronize(); checkCudaErrors(cudaGetLastError());
	//TODO: compute the border(value is true) and interior(value is false)
}

void Jacobi(float* d_color_blended1, float* d_color_blended2, const float* const d_color_pre, const uchar* const d_color_dst, const Mask* const d_mask)
{
	//TODO
	/*float *d_bufin, *d_bufout;*/
	/*const size_t numPixels = numRows * numCols;*/
	/*checkCudaErrors(cudaMalloc(&d_bufin, sizeof(float) * numPixels));*/
	/*checkCudaErrors(cudaMalloc(&d_bufout, sizeof(float) * numPixels));*/
	/*checkCudaErrors(cudaMemcpy(d_bufin, d_color, sizeof(float) * numPixels, cudaMemcpyDeviceToDevice));*/

	//Jacobi  800 iterations
	//TODO: final result in d_color_blended1
}

//crop the source graph and only use the core part
void splitChannel(const uchar4* const d_img, uchar*& d_red, uchar*& d_blue, uchar*& d_green, const size_t numRows, const size_t numCols, float* d_red_blended1 = NULL, float* d_blue_blended1 = NULL, float* d_green_blended1 = NULL)
{
	const size_t numPixels = numRows * numCols;
	checkCudaErrors(cudaMalloc(&d_red, sizeof(float) * numPixels));
	checkCudaErrors(cudaMalloc(&d_green, sizeof(float) * numPixels));
	checkCudaErrors(cudaMalloc(&d_blue, sizeof(float) * numPixels));
	//TODO: split kernel, uchar to float (not double!)
	//TODO: for source img, copy result to blended1(uchar to float)

  /*for (int i = 0; i < srcSize; ++i) {*/
    /*red_src[i]   = h_sourceImg[i].x;*/
    /*blue_src[i]  = h_sourceImg[i].y;*/
    /*green_src[i] = h_sourceImg[i].z;*/
  /*}*/
}

__global__
void map_kernel(float* d_red, float* d_blue, float* d_green, uchar4* d_blendedImg, const Mask* d_mask)
{
	extern __shared__ bool mask[];
	unsigned start_x = d_mask->start_x, start_y = d_mask->start_y, size_x = d_mask->size_x, size_y = d_mask->size_y;
	unsigned end_x = start_x + size_x - 1, end_y = start_y + size_y - 1;
	int xpos = threadIdx.x + blockIdx.x * blockDim.x + 1;
	int ypos = threadIdx.y + blockIdx.y * blockDim.y + 1;
	if(xpos > size_x || ypos > size_y)
	{
		return; 
	}
	mask[ypos][xpos] = d_mask[ypos*size_x + xpos];
	__syncthreads();
}

void getResult(float* d_red, float* d_blue, float* d_green, uchar4* d_blendedImg, const Mask* const d_mask, const size_t numRows_mask, const size_t numCols_mask)
{
	//if true and interior in mask, then copy from buffer
	//NOTICE: assume the mask is 0~N, so the interior is just possible in 1~N-1
	unsigned shared_size = sizeof(bool) * numRows_mask * numCols_mask;
	int xsize = 64, ysize = 16;
	const dim3 threads(xsize, ysize, 1);
	const dim3 blocks((numCols_mask-2+xsize-1)/xsize, (numRows_mask-2+ysize-1)/ysize, 1);
	//cache a part of the mask in shared memory(including the border), how about the final blocks?
	map_kernel<<<blocks, threads, shared_size>>>(d_red, d_blue, d_green, d_blendedImg, d_mask);
	cudaDeviceSynchronize(); checkCudaErrors(cudaGetLastError());
}

void your_blend(const uchar4* const h_sourceImg,  //IN
                const size_t numRowsSource, const size_t numColsSource,
                const uchar4* const h_destImg, //IN
                uchar4* const h_blendedImg) //OUT
{

  /* To Recap here are the steps you need to implement
  
     1) Compute a mask of the pixels from the source image to be copied
        The pixels that shouldn't be copied are completely white, they
        have R=255, G=255, B=255.  Any other pixels SHOULD be copied.

     2) Compute the interior and border regions of the mask.  An interior
        pixel has all 4 neighbors also inside the mask.  A border pixel is
        in the mask itself, but has at least one neighbor that isn't.

     3) Separate out the incoming image into three separate channels

     4) Create two float(!) buffers for each color channel that will
        act as our guesses.  Initialize them to the respective color
        channel of the source image since that will act as our intial guess.

     5) For each color channel perform the Jacobi iteration described 
        above 800 times.

     6) Create the output image by replacing all the interior pixels
        in the destination image with the result of the Jacobi iterations.
        Just cast the floating point values to unsigned chars since we have
        already made sure to clamp them to the correct range.

      Since this is final assignment we provide little boilerplate code to
      help you.  Notice that all the input/output pointers are HOST pointers.

      You will have to allocate all of your own GPU memory and perform your own
      memcopies to get data in and out of the GPU memory.

      Remember to wrap all of your calls with checkCudaErrors() to catch any
      thing that might go wrong.  After each kernel call do:

      cudaDeviceSynchronize(); checkCudaErrors(cudaGetLastError());

      to catch any errors that happened while executing the kernel.
  */

	//NOTICE: the source image's size is the same as the target image
	printf("numRowsSource: %lu   numColsSource: %lu\n", numRowsSource, numColsSource); //500x333
	uchar4 *d_sourceImg, *d_destImg, *d_blendedImg;
	size_t numPixels = numRowsSource * numColsSource;
	checkCudaErrors(cudaMalloc(&d_sourceImg, sizeof(uchar4) * numPixels));
	checkCudaErrors(cudaMalloc(&d_destImg, sizeof(uchar4) * numPixels));
	checkCudaErrors(cudaMalloc(&d_blendedImg, sizeof(uchar4) * numPixels));
	checkCudaErrors(cudaMemcpy(d_sourceImg, h_sourceImg, sizeof(uchar4) * numPixels, cudaMemcpyHostToDevice));
	checkCudaErrors(cudaMemcpy(d_destImg, h_destImg, sizeof(uchar4) * numPixels, cudaMemcpyHostToDevice));

	//NOTICE: we believe that the useful part in source image is very small, and 
	//the border line is smaller than the interior
	Mask* d_mask;
	checkCudaErrors(cudaMalloc(&d_mask, sizeof(Mask)));
	//find the border of the source image, compressed in CSR and can be placed in a block's shared memory
	computeMask(d_sourceImg, d_mask, numRowsSource, numColsSource);

	//TODO: crop the source image by mask, in splitChannel
	size_t numRows_mask = 0, numCols_mask = 0;
	checkCudaErrors(cudaMemcpy(&numRows_mask, &(d_mask->size_y), sizeof(unsigned), cudaMemcpyDeviceToHost));
	checkCudaErrors(cudaMemcpy(&numCols_mask, &(d_mask->size_x), sizeof(unsigned), cudaMemcpyDeviceToHost));
	size_t numPixels_mask = numRows_mask * numCols_mask;

	float *d_red_pre, *d_blue_pre, *d_green_pre;
	checkCudaErrors(cudaMalloc(&d_red_pre, sizeof(float) * numPixels_mask));
	checkCudaErrors(cudaMalloc(&d_blue_pre, sizeof(float) * numPixels_mask));
	checkCudaErrors(cudaMalloc(&d_green_pre, sizeof(float) * numPixels_mask));
	checkCudaErrors(cudaMemset(d_red_pre, 0, sizeof(float) * numPixels_mask));
	checkCudaErrors(cudaMemset(d_blue_pre, 0, sizeof(float) * numPixels_mask));
	checkCudaErrors(cudaMemset(d_green_pre, 0, sizeof(float) * numPixels_mask));
	//TODO: pre-compute the sum of source image and neighbors

	float *d_red_blended1, *d_red_blended2, *d_blue_blended1, *d_blue_blended2, *d_green_blended1, *d_green_blended2;
	checkCudaErrors(cudaMalloc(&d_red_blended1, sizeof(float) * numPixels_mask));
	checkCudaErrors(cudaMalloc(&d_red_blended2, sizeof(float) * numPixels_mask));
	checkCudaErrors(cudaMalloc(&d_blue_blended1, sizeof(float) * numPixels_mask));
	checkCudaErrors(cudaMalloc(&d_blue_blended2, sizeof(float) * numPixels_mask));
	checkCudaErrors(cudaMalloc(&d_green_blended1, sizeof(float) * numPixels_mask));
	checkCudaErrors(cudaMalloc(&d_green_blended2, sizeof(float) * numPixels_mask));
	//separate into 3 channels, and two buffers
	uchar *d_red_src = NULL, *d_green_src = NULL, *d_blue_src = NULL;
	uchar *d_red_dst = NULL, *d_green_dst = NULL, *d_blue_dst = NULL;
	splitChannel(d_sourceImg, d_red_src, d_blue_src, d_green_src, numRows_mask, numCols_mask, d_red_blended1, d_blue_blended1, d_green_blended1);
	splitChannel(d_destImg, d_red_dst, d_blue_dst, d_green_dst, numRows_mask, numCols_mask);

	//NOTICE: iterations are very costly, so the main focus is to reduce the work in iterations
	Jacobi(d_red_blended1, d_red_blended2, d_red_pre, d_red_dst, d_mask);
	Jacobi(d_blue_blended1, d_blue_blended2, d_blue_pre, d_blue_dst, d_mask);
	Jacobi(d_green_blended1, d_green_blended2, d_green_pre, d_green_dst, d_mask);

	checkCudaErrors(cudaMemcpy(d_blendedImg, d_destImg, sizeof(uchar4) * numPixels, cudaMemcpyDeviceToDevice));
    //create the output image by replacing all the interior pixels
	getResult(d_red_blended1, d_blue_blended1, d_green_blended1, d_blendedImg, d_mask, numRows_mask, numCols_mask);

	freeMask(d_mask);
	checkCudaErrors(cudaMemcpy(h_blendedImg, d_blendedImg, sizeof(uchar4) * numPixels, cudaMemcpyDeviceToHost));
	checkCudaErrors(cudaFree(d_red_src));
	checkCudaErrors(cudaFree(d_blue_src));
	checkCudaErrors(cudaFree(d_green_src));
	checkCudaErrors(cudaFree(d_red_dst));
	checkCudaErrors(cudaFree(d_blue_dst));
	checkCudaErrors(cudaFree(d_green_dst));
	checkCudaErrors(cudaFree(d_red_pre));
	checkCudaErrors(cudaFree(d_blue_pre));
	checkCudaErrors(cudaFree(d_green_pre));
	checkCudaErrors(cudaFree(d_red_blended1));
	checkCudaErrors(cudaFree(d_blue_blended1));
	checkCudaErrors(cudaFree(d_green_blended1));
	checkCudaErrors(cudaFree(d_red_blended2));
	checkCudaErrors(cudaFree(d_blue_blended2));
	checkCudaErrors(cudaFree(d_green_blended2));
	checkCudaErrors(cudaFree(d_sourceImg));
	checkCudaErrors(cudaFree(d_destImg));
	checkCudaErrors(cudaFree(d_blendedImg));
}
