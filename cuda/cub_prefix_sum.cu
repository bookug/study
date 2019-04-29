// or equivalently <cub/device/device_scan.cuh>
#include <cub/cub.cuh> 
#include <stdio.h>

using namespace std; 

//http://nvlabs.github.io/cub/structcub_1_1_device_scan.html#details
//self-defined operator

int main()
{
    // Declare, allocate, and initialize device-accessible pointers for input and output
    int  num_items = 7;
    unsigned h_in[] = {8,6,7,5,3,0,9};
    unsigned h_out[8];

    unsigned  *d_in = NULL;
    cudaMalloc(&d_in, sizeof(unsigned)*7);
    cudaMemcpy(d_in, h_in, sizeof(unsigned)*7, cudaMemcpyHostToDevice);

    //NOTICE: they can be the same!
    unsigned *d_out = d_in;

    // Determine temporary device storage requirements
    void     *d_temp_storage = NULL;
    size_t   temp_storage_bytes = 0;
    cub::DeviceScan::ExclusiveSum(d_temp_storage, temp_storage_bytes, d_in, d_out, num_items);
    // Allocate temporary storage
    cudaMalloc(&d_temp_storage, temp_storage_bytes);
    // Run exclusive prefix sum
    cub::DeviceScan::ExclusiveSum(d_temp_storage, temp_storage_bytes, d_in, d_out, num_items);
    // d_out s<-- [0, 8, 14, 21, 26, 29, 29]

    cudaMemcpy(h_out, d_out, sizeof(unsigned)*7, cudaMemcpyDeviceToHost);
    for(int i = 0; i < 7; ++i)
    {
        cout<<h_out[i]<<" ";
    }cout<<endl;

    cudaFree(d_in);
    //d_out is same as d_in and the same area should not be freed twice
    /*cudaFree(d_out);*/
    //NOTICE: this is valid
    cudaFree(NULL);
    //this is needed
    cudaFree(d_temp_storage);

    return 0;
}

