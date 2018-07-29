/*=============================================================================
# Filename: test.cu
# Author: Bookug Lobert 
# Mail: zengli-bookug@pku.edu.cn
# Last Modified: 2018-07-29 20:28
# Description: 
https://blog.csdn.net/dreampursue/article/details/6256426#
=============================================================================*/

/*
 * Copyright 1993-2011 NVIDIA Corporation.  All rights reserved.
 *
 * Please refer to the NVIDIA end user license agreement (EULA) associated
 * with this source code for terms and conditions that govern your use of
 * this software. Any use, reproduction, disclosure, or distribution of
 * this software and related documentation outside the terms of the EULA
 * is strictly prohibited.
 *
 */
/*
 * This sample demonstrates a combination of Peer-to-Peer (P2P) and Unified
 * Virtual Address Space (UVA) features new to SDK 4.0
 */
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <cutil_inline.h>
#include <cuda_runtime_api.h>
const char *sSDKsample = "simpleP2P";
__global__ void SimpleKernel(float *src, float *dst)
{
    // Just a dummy kernel, doing enough for us to verify that everything
    // worked
    const int idx = blockIdx.x * blockDim.x + threadIdx.x;
    dst[idx] = src[idx] * 2.0f;
}
int main(int argc, char **argv)
{
    printf("[%s] starting.../n", sSDKsample);
    // Number of GPUs
    printf("Checking for multiple GPUs.../n");
    int gpu_n;
    cutilSafeCall(cudaGetDeviceCount(&gpu_n));
    printf("CUDA-capable device count: %i/n", gpu_n);
    if (gpu_n < 2)
    {
        printf("Two or more Tesla(s) with (SM 2.0) class GPUs are required for %s./n", sSDKsample);
        printf("Waiving test./n");
        printf("PASSED/n");
        exit(EXIT_SUCCESS);
    }
    // Query device properties
    cudaDeviceProp prop_0, prop_1;
    cutilSafeCall(cudaGetDeviceProperties(∝_0, 0));
    cutilSafeCall(cudaGetDeviceProperties(∝_1, 1));
    // Check for TCC
#ifdef _WIN32
    if (prop_0.tccDriver == 0 || prop_1.tccDriver == 0)
    {
        printf("Need to have both GPUs running under TCC driver to use P2P / UVA functionality./n");
        printf("PASSED/n");
        exit(EXIT_SUCCESS);
    }
#endif // WIN32
    // Check possibility for peer access
    printf("Checking for peer access.../n");
    int can_access_peer_0_1, can_access_peer_1_0;
    cutilSafeCall(cudaDeviceCanAccessPeer(&can_access_peer_0_1, 0, 1));
    cutilSafeCall(cudaDeviceCanAccessPeer(&can_access_peer_1_0, 1, 0));
    if (can_access_peer_0_1 == 0 || can_access_peer_1_0 == 0)
    {
        printf("Two or more Tesla(s) with (SM 2.0) class GPUs are required for %s./n", sSDKsample);
        printf("Peer access is not available between GPU0 <-> GPU1, waiving test./n");
        printf("PASSED/n");
        exit(EXIT_SUCCESS);
    }
    // Enable peer access
    printf("Enabling peer access.../n");
    cutilSafeCall(cudaSetDevice(0));
    cutilSafeCall(cudaDeviceEnablePeerAccess(1, 0));
    cutilSafeCall(cudaSetDevice(1));
    cutilSafeCall(cudaDeviceEnablePeerAccess(0, 0));
    // Check that we got UVA on both devices
    printf("Checking for UVA.../n");
    const bool has_uva = prop_0.unifiedAddressing && prop_1.unifiedAddressing;
    if (has_uva == false)
    {
        printf("At least one of the two GPUs has no UVA support/n");
    }
    // Allocate buffers
    const size_t buf_size = 1024 * 1024 * 16 * sizeof(float);
    printf("Allocating buffers (%iMB on GPU0, GPU1 and Host).../n", int(buf_size / 1024 / 1024));
    cutilSafeCall(cudaSetDevice(0));
    float* g0;
    cutilSafeCall(cudaMalloc(&g0, buf_size));
    cutilSafeCall(cudaSetDevice(1));
    float* g1;
    cutilSafeCall(cudaMalloc(&g1, buf_size));
    float* h0;
    if (has_uva)
        cutilSafeCall(cudaMallocHost(&h0, buf_size)); // Automatically portable with UVA
    else
        cutilSafeCall(cudaHostAlloc(&h0, buf_size, cudaHostAllocPortable));
    float *g0_peer, *g1_peer;
    if (has_uva == false)
    {
        // Need explicit mapping without UVA
        cutilSafeCall(cudaSetDevice(0));
        cutilSafeCall(cudaPeerRegister(g1, 1, cudaPeerRegisterMapped));
        cutilSafeCall(cudaPeerGetDevicePointer((void **) &g1_peer, g1, 1, 0));
        cutilSafeCall(cudaSetDevice(1));
        cutilSafeCall(cudaPeerRegister(g0, 0, cudaPeerRegisterMapped));
        cutilSafeCall(cudaPeerGetDevicePointer((void **) &g0_peer, g0, 0, 0));
    }
    // Create CUDA event handles
    printf("Creating event handles.../n");
    cudaEvent_t start_event, stop_event;
    float time_memcpy;
    int eventflags = cudaEventBlockingSync;
    cutilSafeCall(cudaEventCreateWithFlags(&start_event, eventflags));
    cutilSafeCall(cudaEventCreateWithFlags(&stop_event, eventflags));
    // P2P memcopy() benchmark
    cutilSafeCall(cudaEventRecord(start_event, 0));
    for (int i=0; i<100; i++)
    {
        // With UVA we don't need to specify source and target devices, the
        // runtime figures this out by itself from the pointers
        if (has_uva)
        {
            // Ping-pong copy between GPUs
            if (i % 2 == 0)
                cutilSafeCall(cudaMemcpy(g1, g0, buf_size, cudaMemcpyDefault));
            else
                cutilSafeCall(cudaMemcpy(g0, g1, buf_size, cudaMemcpyDefault));
        }
        else
        {
            // Ping-pong copy between GPUs
            if (i % 2 == 0)
                cutilSafeCall(cudaMemcpyPeer(g1, 1, g0, 0, buf_size));
            else
                cutilSafeCall(cudaMemcpyPeer(g0, 0, g1, 1, buf_size));
        }
    }
    cutilSafeCall(cudaEventRecord(stop_event, 0));
    cutilSafeCall(cudaEventSynchronize(stop_event));
    cutilSafeCall(cudaEventElapsedTime(&time_memcpy, start_event, stop_event));
    printf("cudaMemcpyPeer / cudaMemcpy between GPU0 and GPU1: %.2fGB/s/n",
        (1.0f / (time_memcpy / 1000.0f)) * ((100.0f * buf_size)) / 1024.0f / 1024.0f / 1024.0f);
 
    // Prepare host buffer and copy to GPU 0
    printf("Preparing host buffer and memcpy to GPU0.../n");
    for (int i=0; i<buf_size / sizeof(float); i++)
    {
        h0[i] = float(i % 4096);
    }
    cutilSafeCall(cudaSetDevice(0));
    if (has_uva)
        cutilSafeCall(cudaMemcpy(g0, h0, buf_size, cudaMemcpyDefault));
    else
        cutilSafeCall(cudaMemcpy(g0, h0, buf_size, cudaMemcpyHostToDevice));
    // Kernel launch configuration
    const dim3 threads(512, 1);
    const dim3 blocks((buf_size / sizeof(float)) / threads.x, 1);
 
    // Run kernel on GPU 1, reading input from the GPU 0 buffer, writing
    // output to the GPU 1 buffer
    printf("Run kernel on GPU1, taking source data from GPU0 and writing to GPU1.../n");
    cutilSafeCall(cudaSetDevice(1));
    if (has_uva)
        SimpleKernel<<<blocks, threads>>> (g0, g1);
    else
        SimpleKernel<<<blocks, threads>>> (g0_peer, g1);
    // Run kernel on GPU 0, reading input from the GPU 1 buffer, writing
    // output to the GPU 0 buffer
    printf("Run kernel on GPU0, taking source data from GPU1 and writing to GPU0.../n");
    cutilSafeCall(cudaSetDevice(0));
    if (has_uva)
        SimpleKernel<<<blocks, threads>>> (g1, g0);
    else
        SimpleKernel<<<blocks, threads>>> (g1_peer, g0);
 
    // Copy data back to host and verify
    printf("Copy data back to host from GPU0 and verify.../n");
    if (has_uva)
        cutilSafeCall(cudaMemcpy(h0, g0, buf_size, cudaMemcpyDefault));
    else
        cutilSafeCall(cudaMemcpy(h0, g0, buf_size, cudaMemcpyHostToDevice));
    int error_count = 0;
    for (int i=0; i<buf_size / sizeof(float); i++)
    {
        // Re-generate input data and apply 2x '* 2.0f' computation of both
        // kernel runs
        if (h0[i] != float(i % 4096) * 2.0f * 2.0f)
        {
            printf("Verification error, element %i/n", i);
            if (error_count++ > 10)
                break;
        }
    }
    printf((error_count == 0) ? "PASSED/n" : "FAILED/n");
    // Disable peer access (also unregisters memory for non-UVA cases)
    printf("Enabling peer access.../n");
    cutilSafeCall(cudaSetDevice(0));
    cutilSafeCall(cudaDeviceDisablePeerAccess(1));
    cutilSafeCall(cudaSetDevice(1));
    cutilSafeCall(cudaDeviceDisablePeerAccess(0));
    // Cleanup and shutdown
    printf("Shutting down.../n");
    cutilSafeCall(cudaEventDestroy(start_event));
    cutilSafeCall(cudaEventDestroy(stop_event));
    cutilSafeCall(cudaSetDevice(0));
    cutilSafeCall(cudaFree(g0));
    cutilSafeCall(cudaSetDevice(1));
    cutilSafeCall(cudaFree(g1));
    cutilSafeCall(cudaFreeHost(h0));
    cudaDeviceReset();
    cutilExit(argc, argv);
}

