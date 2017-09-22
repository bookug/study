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

__global__
void mask_kernel(const uchar4* const d_sourceImg, uchar* d_mask, size_t numRows, size_t numCols)
{
	int xpos = threadIdx.x + blockIdx.x * blockDim.x;
	int ypos = threadIdx.y + blockIdx.y * blockDim.y;
	if(xpos >= numCols || ypos >= numRows)
	{
		return; 
	}
	int coord = ypos * numCols + xpos;
	uchar4 pixel = d_sourceImg[coord];
	if(pixel.x != 255 || pixel.y != 255 || pixel.z != 255)
	{
		d_mask[coord] = 1;
	}
	/*else*/
	/*{*/
		/*return;*/
	/*}*/
	/*__syncthreads();*/
	/*//WARN: maybe not all blocks synced!!!  even they are the neighbors(may not in a block)*/
	/*bool up = false, down = false, left = false, right = false;*/
	/*if(ypos > 0 && d_mask[coord-numCols] == 1)*/
	/*{*/
		/*up = true;*/
	/*}*/
	/*if(ypos < numRows-1 && d_mask[coord+numCols] == 1)*/
	/*{*/
		/*down = true;*/
	/*}*/
	/*if(xpos > 0 && d_mask[coord-1] == 1)*/
	/*{*/
		/*left = true;*/
	/*}*/
	/*if(xpos < numCols-1 && d_mask[coord+1] == 1)*/
	/*{*/
		/*right = true;*/
	/*}*/
	/*__syncthreads();*/
	/*if(!up || !down || !left || !right)*/
	/*{*/
		/*d_mask[coord] = 2;*/
	/*}*/
}
	
__global__
void border_kernel(const uchar* const d_mask, uchar* const d_mask_tmp, const size_t numRows, const size_t numCols)
{
	int xpos = threadIdx.x + blockIdx.x * blockDim.x;
	int ypos = threadIdx.y + blockIdx.y * blockDim.y;
	if(xpos >= numCols || ypos >= numRows)
	{
		return; 
	}
	int coord = ypos * numCols + xpos;
	if(d_mask[coord] == 0)
	{
		d_mask_tmp[coord] = 0;
		return; 
	}

	bool up = false, down = false, left = false, right = false;
	if(ypos > 0 && d_mask[coord-numCols] == 1)
	{
		up = true;
	}
	if(ypos < numRows-1 && d_mask[coord+numCols] == 1)
	{
		down = true;
	}
	if(xpos > 0 && d_mask[coord-1] == 1)
	{
		left = true;
	}
	if(xpos < numCols-1 && d_mask[coord+1] == 1)
	{
		right = true;
	}
	if(!up || !down || !left || !right)
	{
		d_mask_tmp[coord] = 2;
	}
	else
	{
		d_mask_tmp[coord] = 1;
	}
}

void computeMask(const uchar4* const d_sourceImg, uchar*& d_mask, const size_t numRows, const size_t numCols)
{
	size_t numPixels = numRows * numCols;
	checkCudaErrors(cudaMemset(d_mask, 0, sizeof(uchar) * numPixels));
	int xsize = 32, ysize = 32;
	const dim3 threads(xsize, ysize, 1);
	const dim3 blocks((numCols+xsize-1)/xsize, (numRows+ysize-1)/ysize, 1);
	mask_kernel<<<blocks, threads>>>(d_sourceImg, d_mask, numRows, numCols);
	cudaDeviceSynchronize(); checkCudaErrors(cudaGetLastError());
//BETTER: how about judge from d_sourceImg directly, 1+4

	//NOTICE: we can not finish this process in a round because there are many blocks and we can not synchronize them
	uchar* d_mask_tmp = NULL;
	checkCudaErrors(cudaMalloc(&d_mask_tmp, sizeof(uchar) * numRows * numCols));

	border_kernel<<<blocks, threads>>>(d_mask, d_mask_tmp, numRows, numCols);
	cudaDeviceSynchronize(); checkCudaErrors(cudaGetLastError());

	checkCudaErrors(cudaFree(d_mask));
	d_mask = d_mask_tmp;
}

__global__
void jacobi_kernel(float* d_in, float* d_out, float* d_color_pre, uchar* d_color_dst, uchar* d_mask, const size_t numRows, const size_t numCols)
{
	int xpos = threadIdx.x + blockIdx.x * blockDim.x;
	int ypos = threadIdx.y + blockIdx.y * blockDim.y;
	if(xpos >= numCols || ypos >= numRows)
	{
		return; 
	}
	int coord = ypos * numCols + xpos;
	if(d_mask[coord] != 1)
	{
		return; 
	}
    float blendedSum = 0.f;
    float borderSum  = 0.f;

	//NOTICE: interior pixel can not be in the border, so we do not need to check
    if (d_mask[coord - 1] == 1) 
	{
      blendedSum += d_in[coord - 1];
    }
    else 
	{
      borderSum += d_color_dst[coord - 1];
    }

    if (d_mask[coord + 1] == 1) 
	{
      blendedSum += d_in[coord + 1];
    }
    else 
	{
      borderSum += d_color_dst[coord + 1];
    }

    if (d_mask[coord - numCols] == 1) 
	{
      blendedSum += d_in[coord - numCols];
    }
    else 
	{
      borderSum += d_color_dst[coord - numCols];
    }

    if (d_mask[coord + numCols] == 1) 
	{
      blendedSum += d_in[coord + numCols];
    }
    else 
	{
      borderSum += d_color_dst[coord + numCols];
    }

    float f_next_val = (blendedSum + borderSum + d_color_pre[coord]) / 4.f;
    d_out[coord] = min(255.f, max(0.f, f_next_val)); //clip to [0, 255]
}

void Jacobi(float* d_color_blended1, float* d_color_blended2, float* d_color_pre, uchar* d_color_dst, uchar* d_mask, const size_t numRows, const size_t numCols)
{
	int xsize = 32, ysize = 32;
	const dim3 threads(xsize, ysize, 1);
	const dim3 blocks((numCols+xsize-1)/xsize, (numRows+ysize-1)/ysize, 1);
	float *d_in = d_color_blended1, *d_out = d_color_blended2, *d_tmp = NULL;
	for(int step = 0; step < LIMIT; ++step)
	{
		jacobi_kernel<<<blocks, threads>>>(d_in, d_out, d_color_pre, d_color_dst, d_mask, numRows, numCols);
		cudaDeviceSynchronize(); checkCudaErrors(cudaGetLastError());
		d_tmp = d_in; d_in = d_out; d_out = d_tmp;
	}
	//final result in d_in, just d_color_blended1 here
}

__global__
void split_kernel(const uchar4* const d_img, uchar* d_red, uchar* d_blue, uchar* d_green, const size_t numRows, const size_t numCols, float* d_red_blended = NULL, float* d_blue_blended = NULL, float* d_green_blended = NULL)
{
	int xpos = threadIdx.x + blockIdx.x * blockDim.x;
	int ypos = threadIdx.y + blockIdx.y * blockDim.y;
	if(xpos >= numCols || ypos >= numRows)
	{
		return; 
	}
	int coord = ypos * numCols + xpos;
	d_red[coord] = d_img[coord].x;
	d_blue[coord] = d_img[coord].y;
	d_green[coord] = d_img[coord].z;
	if(d_red_blended != NULL)
	{
		d_red_blended[coord] = static_cast<float>(d_red[coord]);
		d_blue_blended[coord] = static_cast<float>(d_blue[coord]);
		d_green_blended[coord] = static_cast<float>(d_green[coord]);
	}
}

void splitChannel(const uchar4* const d_img, uchar*& d_red, uchar*& d_blue, uchar*& d_green, const size_t numRows, const size_t numCols, float* d_red_blended = NULL, float* d_blue_blended = NULL, float* d_green_blended = NULL)
{
	const size_t numPixels = numRows * numCols;
	checkCudaErrors(cudaMalloc(&d_red, sizeof(float) * numPixels));
	checkCudaErrors(cudaMalloc(&d_green, sizeof(float) * numPixels));
	checkCudaErrors(cudaMalloc(&d_blue, sizeof(float) * numPixels));
	int xsize = 32, ysize = 32;
	const dim3 threads(xsize, ysize, 1);
	const dim3 blocks((numCols+xsize-1)/xsize, (numRows+ysize-1)/ysize, 1);
	split_kernel<<<blocks, threads>>>(d_img, d_red, d_blue, d_green, numRows, numCols, d_red_blended, d_blue_blended, d_green_blended);
	cudaDeviceSynchronize(); checkCudaErrors(cudaGetLastError());
}

__global__
void pre_kernel(uchar* d_color_src, float* d_color_pre, uchar* d_mask, size_t numRows, size_t numCols)
{
	int xpos = threadIdx.x + blockIdx.x * blockDim.x;
	int ypos = threadIdx.y + blockIdx.y * blockDim.y;
	if(xpos >= numCols || ypos >= numRows)
	{
		return; 
	}
	int coord = ypos * numCols + xpos;
	if(d_mask[coord] != 1)
	{
		return; 
	}
    float sum = 4.f * (float)d_color_src[coord];
    sum = sum - (float)d_color_src[coord - 1] - (float)d_color_src[coord + 1];
    sum = sum - (float)d_color_src[coord + numCols] - (float)d_color_src[coord - numCols];
    d_color_pre[coord] = sum;
}

void precompute(uchar* d_color_src, float* d_color_pre, uchar* d_mask, const size_t numRows, const size_t numCols)
{
	int xsize = 32, ysize = 32;
	const dim3 threads(xsize, ysize, 1);
	const dim3 blocks((numCols+xsize-1)/xsize, (numRows+ysize-1)/ysize, 1);
	pre_kernel<<<blocks, threads>>>(d_color_src, d_color_pre, d_mask, numRows, numCols);
	cudaDeviceSynchronize(); checkCudaErrors(cudaGetLastError());
}

__global__
void map_kernel(float* d_red, float* d_blue, float* d_green, uchar4* d_blendedImg, uchar* d_mask, size_t numRows, size_t numCols)
{
	int xpos = threadIdx.x + blockIdx.x * blockDim.x;
	int ypos = threadIdx.y + blockIdx.y * blockDim.y;
	if(xpos >= numCols || ypos >= numRows)
	{
		return; 
	}
	int coord = ypos * numCols + xpos;
	if(d_mask[coord] == 1)
	{
		d_blendedImg[coord].x = static_cast<uchar>(d_red[coord]);
		d_blendedImg[coord].y = static_cast<uchar>(d_blue[coord]);
		d_blendedImg[coord].z = static_cast<uchar>(d_green[coord]);
	}
}

void mapResult(float* d_red, float* d_blue, float* d_green, uchar4* d_blendedImg, uchar* d_mask, const size_t numRows, const size_t numCols)
{
	//if true and interior in mask, then copy from buffer
	//NOTICE: assume the mask is 0~N, so the interior is just possible in 1~N-1
	int xsize = 32, ysize = 32;
	const dim3 threads(xsize, ysize, 1);
	const dim3 blocks((numCols+xsize-1)/xsize, (numRows+ysize-1)/ysize, 1);
	map_kernel<<<blocks, threads>>>(d_red, d_blue, d_green, d_blendedImg, d_mask, numRows, numCols);
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

	//BETTER: we may release unnecessary memory as early as possible
	//Besides, shared memory should be utilized! 
	//And we should improve the occupancy, which means we may crop the core part of the images

	//NOTICE: we believe that the useful part in source image is very small, and 
	//the border line is smaller than the interior
	uchar* d_mask;
	checkCudaErrors(cudaMalloc(&d_mask, sizeof(uchar) * numPixels));
	//NOTICE: it is not so easy to build an interior list
	/*uint2* d_interior;*/
	/*checkCudaErrors(cudaMalloc(&d_interior, sizeof(uint2) * numPixels));*/
	//find the border of the source image
	computeMask(d_sourceImg, d_mask, numRowsSource, numColsSource);

	//check the mask
	/*uchar* h_mask = (uchar*)malloc(sizeof(uchar)*numPixels);*/
	/*checkCudaErrors(cudaMemcpy(h_mask, d_mask, sizeof(uchar)*numPixels, cudaMemcpyDeviceToHost));*/
	/*uchar* h_mask_cmp = (uchar*)malloc(sizeof(uchar)*numPixels);*/
	/*for (int i = 0; i < numPixels; ++i) */
	/*{*/
		/*h_mask_cmp[i] = (h_sourceImg[i].x + h_sourceImg[i].y + h_sourceImg[i].z < 3 * 255) ? 1 : 0;*/
	/*}*/
	/*for(int r = 1; r < numRowsSource-1; ++r)*/
	/*{*/
		/*for(int c = 1; c < numColsSource-1; ++c)*/
		/*{*/
			/*int pos = r * numColsSource + c;*/
			/*if(h_mask_cmp[pos] == 0)*/
			/*{*/
				/*continue;*/
			/*}*/
			/*if(h_mask_cmp[pos-1] == 0 || h_mask_cmp[pos+1] == 0 || h_mask_cmp[pos-numColsSource] == 0 || h_mask_cmp[pos+numColsSource] == 0)*/
			/*{*/
				/*h_mask_cmp[pos] = 2;*/
			/*}*/
		/*}*/
	/*}*/
	/*for(int i = 0; i < numPixels; ++i)*/
	/*{*/
		/*if(h_mask[i] != h_mask_cmp[i])*/
		/*{*/
			/*printf("Not matched for mask!\n");*/
			/*break;*/
		/*}*/
	/*}*/
	/*printf("check mask!\n");*/
	/*free(h_mask); free(h_mask_cmp);*/

	//TODO+DEBUG: the bug is in the border, and the mask is good

	float *d_red_blended1, *d_red_blended2, *d_blue_blended1, *d_blue_blended2, *d_green_blended1, *d_green_blended2;
	checkCudaErrors(cudaMalloc(&d_red_blended1, sizeof(float) * numPixels));
	checkCudaErrors(cudaMalloc(&d_red_blended2, sizeof(float) * numPixels));
	checkCudaErrors(cudaMalloc(&d_blue_blended1, sizeof(float) * numPixels));
	checkCudaErrors(cudaMalloc(&d_blue_blended2, sizeof(float) * numPixels));
	checkCudaErrors(cudaMalloc(&d_green_blended1, sizeof(float) * numPixels));
	checkCudaErrors(cudaMalloc(&d_green_blended2, sizeof(float) * numPixels));
	//separate into 3 channels, and two buffers
	uchar *d_red_src = NULL, *d_green_src = NULL, *d_blue_src = NULL;
	uchar *d_red_dst = NULL, *d_green_dst = NULL, *d_blue_dst = NULL;
	splitChannel(d_sourceImg, d_red_src, d_blue_src, d_green_src, numRowsSource, numColsSource, d_red_blended1, d_blue_blended1, d_green_blended1);
	splitChannel(d_destImg, d_red_dst, d_blue_dst, d_green_dst, numRowsSource, numColsSource);

	float *d_red_pre, *d_blue_pre, *d_green_pre;
	checkCudaErrors(cudaMalloc(&d_red_pre, sizeof(float) * numPixels));
	checkCudaErrors(cudaMalloc(&d_blue_pre, sizeof(float) * numPixels));
	checkCudaErrors(cudaMalloc(&d_green_pre, sizeof(float) * numPixels));
	checkCudaErrors(cudaMemset(d_red_pre, 0, sizeof(float) * numPixels));
	checkCudaErrors(cudaMemset(d_blue_pre, 0, sizeof(float) * numPixels));
	checkCudaErrors(cudaMemset(d_green_pre, 0, sizeof(float) * numPixels));
	//pre-compute the sum of source image and neighbors
	precompute(d_red_src, d_red_pre, d_mask, numRowsSource, numColsSource);
	precompute(d_blue_src, d_blue_pre, d_mask, numRowsSource, numColsSource);
	precompute(d_green_src, d_green_pre, d_mask, numRowsSource, numColsSource);

	//NOTICE: iterations are very costly, so the main focus is to reduce the work in iterations
	Jacobi(d_red_blended1, d_red_blended2, d_red_pre, d_red_dst, d_mask, numRowsSource, numColsSource);
	Jacobi(d_blue_blended1, d_blue_blended2, d_blue_pre, d_blue_dst, d_mask, numRowsSource, numColsSource);
	Jacobi(d_green_blended1, d_green_blended2, d_green_pre, d_green_dst, d_mask, numRowsSource, numColsSource);
	//BETTER: consider using cuda stream here, or async memcpy, or cudaHostRegister

	checkCudaErrors(cudaMemcpy(d_blendedImg, d_destImg, sizeof(uchar4) * numPixels, cudaMemcpyDeviceToDevice));
    //create the output image by replacing all the interior pixels
	mapResult(d_red_blended1, d_blue_blended1, d_green_blended1, d_blendedImg, d_mask, numRowsSource, numColsSource);

	checkCudaErrors(cudaMemcpy(h_blendedImg, d_blendedImg, sizeof(uchar4) * numPixels, cudaMemcpyDeviceToHost));
	checkCudaErrors(cudaFree(d_mask));
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
