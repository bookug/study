/*************************************************************************
  > File Name: transpose_zengli.c
  > Author: syzz 
  > Mail: 1181955272@qq.com 
  > Last Modified: 2015年04月26日 星期日 19时45分11秒
 ************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <string.h>
#include <time.h>
#include <sys/time.h>

#define N 16 * 1024         //the size of square-matrix
#define M 10000             //max float number
#define BLOCK_SIZE 32

float A[N][N];

int block_x[N*N/BLOCK_SIZE/2], block_y[N*N/BLOCK_SIZE/2];

void simple_transpose(float A[N][N])
{
	printf("logic threads num: %d\n",omp_get_num_procs() );
#pragma omp parallel for
	for(int i = 0; i < N; i++)
		for(int j = 0; j < i; j++)
		{
			const float tmp = A[i][j];
			A[i][j] = A[j][i];
			A[j][i] = tmp;
		}
}


void advanced_transpose(float A[N*N], const int block_x[], const int block_y[])
{
	int blocks = N / BLOCK_SIZE;
	int block_tot_num = blocks * blocks;
	int block_tot_trans_num = blocks * (blocks - 1) / 2;
	int line_size = BLOCK_SIZE * sizeof(float);
#pragma omp parallel
	{
#pragma omp for
		for(int i = 0; i < block_tot_num; i++)
		{
			const int base_x = i / blocks * BLOCK_SIZE;
			const int base_y = i % blocks * BLOCK_SIZE;
			float tmp[BLOCK_SIZE*BLOCK_SIZE];
			for(int x = base_x; x < base_x + BLOCK_SIZE; x++)
#pragma simd
				for(int y = base_y; y < base_y + BLOCK_SIZE; y++)
					tmp[(y-base_y)*BLOCK_SIZE + x-base_x] = A[x*N+y];
			float* DA = &A[base_x*N + base_y];
			float* SA = tmp;
			for(int x = 0; x <  BLOCK_SIZE; x++)
			{

#pragma simd
				for(int i = 0; i < BLOCK_SIZE; i++)
					DA[i] = SA[i];
				DA += N;
				SA += BLOCK_SIZE;
			}
		}
#pragma omp for
		for(int block_id = 0; block_id < block_tot_trans_num; block_id++)
		{
			const int base_x = block_x[block_id];
			const int base_y = block_y[block_id];
			float tmp[BLOCK_SIZE];
			float *A1 = &A[base_x*N+base_y];
			float *A2 = &A[base_y*N+base_x];
			for(int i = 0; i < BLOCK_SIZE; i++)
			{
#pragma simd
				for(int i = 0; i < BLOCK_SIZE; i++)
					tmp[i] = A1[i];
#pragma simd
				for(int i = 0; i< BLOCK_SIZE; i++)
					A1[i] = A2[i];
#pragma simd
				for(int i = 0; i< BLOCK_SIZE; i++)
					A2[i] = tmp[i];
				A1 += N;
				A2 += N;
			}
		}
	}
}

int main(int argc, char const *argv[])
{
	int x, y, i, j;
	struct timeval t1, t2;
	double timeuse;
	clock_t begin, end;
	srand(time(0));

	for(i = 0; i < N; i++)
		for(j = 0; j < N; j ++)
			A[i][j] = rand()/(double)(RAND_MAX/M);

	//simple transpose part
	gettimeofday(&t1,NULL);
	simple_transpose(A);
	gettimeofday(&t2, NULL);
	timeuse = t2.tv_sec - t1.tv_sec + (t2.tv_usec - t1.tv_usec)/1000000.0;
	printf("time of simple transpose: %fs\n", timeuse);

	//advanced transpose part
	x = BLOCK_SIZE;
	y = 0;
	i = 0;
	while(x < N)
	{
		block_x[i] = x;
		block_y[i] = y;
		i += 1;
		y += BLOCK_SIZE;
		if (y >= x)
		{
			x += BLOCK_SIZE;
			y = 0;
		}
	}
	gettimeofday(&t1,NULL);
	advanced_transpose((float*)A, block_x, block_y);
	gettimeofday(&t2,NULL);
	timeuse = t2.tv_sec - t1.tv_sec + (t2.tv_usec - t1.tv_usec)/1000000.0;
	printf("time of advanced transpose: %fs\n", timeuse);

	return 0;
}	

