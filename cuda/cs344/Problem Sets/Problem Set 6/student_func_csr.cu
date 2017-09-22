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

//ANALYSIS: the source image is really sparse, so we must compress it to be placed in a block's shared memory(<= 48KB)
//However, this sparse graph is very special, and CSR is not fit here due to its complexity
//(and maybe not so efficient due to its separated visits to memory)
//In the source graph, only the small part of center is useful, so we can use skew and a small matrix to represent
//(which is more simple, and can help save more memory)
//In fact, CSR is just like place an adjacent list in an array
typedef struct ImageMask
{
	//BETTER: use bitwise
	//false: interior    true: border
	bool* value;
	//BETTER: use unsigned short if not exceeding 65534
	unsigned* index;
	//-1 if all zeros in this row
	int* rowptr;
	unsigned num;  //edges' number
}Mask;
unsigned countMask(Mask* mask, const size_t numRows, const size_t numCols)
{
	return sizeof(bool) * mask->num + sizeof(unsigned) * mask->num + sizeof(int) * numRows;
}
//we assume that x and y is valid
int checkMask(Mask* mask, unsigned x, unsigned y, const size_t numRows, const size_t numCols)
{
	//0:white  1:interior  2:border
	int row = mask->rowptr[y];
	if(row < 0)
	{
		return 0;
	}
	int begin = row, end = y+1;
	while(end < numRows && mask->rowptr[end] < 0)
	{
		end++;
	}
	if(end == numRows)
	{
		end = mask->num;
	}
	else
	{
		end = mask->rowptr[end];
	}
	//search in [begin, end) for x, if not found then return 0
	//BETTER: binary search
	for(int i = begin; i < end; ++i)
	{
		if(mask->index[i] == x)
		{
			if(mask->value[i])
			{
				return 2;
			}
			else
			{
				return 1;
			}
		}
	}
	return 0;
}
void freeMask(Mask* d_mask)
{
	checkCudaErrors(cudaFree(d_mask->value));
	checkCudaErrors(cudaFree(d_mask->index));
	checkCudaErrors(cudaFree(d_mask->rowptr));
	checkCudaErrors(cudaFree(d_mask));
	d_mask = NULL;
}

void computeMask(const uchar4* const d_sourceImg, Mask* const d_mask, const size_t numRows, const size_t numCols)
{
	//TODO: alloc and build the mask
	cudaDeviceSynchronize(); checkCudaErrors(cudaGetLastError());
	//TODO: compute the border(value is true) and interior(value is false)
}

void Jacobi(float* d_color, const size_t numRows, const size_t numCols)
{
	//TODO
	float *d_bufin, *d_bufout;
	const size_t numPixels = numRows * numCols;
	checkCudaErrors(cudaMalloc(&d_bufin, sizeof(float) * numPixels));
	checkCudaErrors(cudaMalloc(&d_bufout, sizeof(float) * numPixels));
	checkCudaErrors(cudaMemcpy(d_bufin, d_color, sizeof(float) * numPixels, cudaMemcpyDeviceToDevice));

	//Jacobi  800 iterations
	//TODO: free buffers and store result in d_color
}

void splitChannel(const uchar4* const d_sourceImg, float* d_red, float* d_green, float* d_blue, const size_t numRows, const size_t numCols)
{
	const size_t numPixels = numRows * numCols;
	checkCudaErrors(cudaMalloc(&d_red, sizeof(float) * numPixels));
	checkCudaErrors(cudaMalloc(&d_green, sizeof(float) * numPixels));
	checkCudaErrors(cudaMalloc(&d_blue, sizeof(float) * numPixels));
	//TODO: split kernel, uchar to float (not double!)

	Jacobi(d_red, numRows, numCols);
	Jacobi(d_green, numRows, numCols);
	Jacobi(d_blue, numRows, numCols);
}

void getResult(const uchar4* const d_destImg, float* d_red, float* d_green, float* d_blue, uchar4* d_blendedImg, const size_t numRows, const size_t numCols)
{
	//TODO
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

	//separate into 3 channels, and two buffers
	float *d_red = NULL, *d_green = NULL, *d_blue = NULL;
	splitChannel(d_sourceImg, d_red, d_green, d_blue, numRowsSource, numColsSource);

    //create the output image by replacing all the interior pixels
	getResult(d_destImg, d_red, d_green, d_blue, d_blendedImg, numRowsSource, numColsSource);

	freeMask(d_mask);
	checkCudaErrors(cudaMemcpy(h_blendedImg, d_blendedImg, sizeof(uchar4) * numPixels, cudaMemcpyDeviceToHost));
	checkCudaErrors(cudaFree(d_red));
	checkCudaErrors(cudaFree(d_green));
	checkCudaErrors(cudaFree(d_blue));
	checkCudaErrors(cudaFree(d_sourceImg));
	checkCudaErrors(cudaFree(d_destImg));
	checkCudaErrors(cudaFree(d_blendedImg));
}
