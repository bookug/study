//NOTICE: multiply can be used to compute spmm and spmv, with user-defined combine/reduce operators
//http://cusplibrary.github.io/group__matrix__algorithms.html#ga64aac53ca20d88d71aadc7e8b3317788

//NOTICE: array2d is not csr structure! 
//And GPU is not used in this file!

#include <cusp/array1d.h>
#include <cusp/array2d.h>
#include <cusp/detail/functional.h>
#include <cusp/multiply.h>
#include <cusp/print.h>
#include <cusp/csr_matrix.h>
#include <cusp/hyb_matrix.h>
#include <cusp/transpose.h> 

#include <cuda.h> 
#include <cuda_runtime.h> 
#include <iostream> 

using namespace std; 

/*#define SIZE 2*/
#define SIZE 2000

/*__global__ void*/
/*test_kernel(array1d<int,cusp::device_memory> p)*/
/*{*/
    /*p[0] = 1;*/
/*}*/

int main(void)
{
    /*cusp::detail::zero_function<int> initialize;  //C=A*B*/
    /*thrust::plus<int> combine;*/
    /*thrust::plus<int>       reduce;*/
  // Allocate storage for a 5 by 8 sparse matrix in CSR format with 12
  // nonzero entries on the host
  cusp::csr_matrix<int,float,cusp::host_memory> A(4,4,6);
    // initialize matrix entries on host
    A.row_offsets[0] = 0;  // first offset is always zero
      A.row_offsets[1] = 2;
        A.row_offsets[2] = 2;
          A.row_offsets[3] = 3;
            A.row_offsets[4] = 6; // last offset is always num_entries
            A.row_offsets[5] = 6; // last offset is always num_entries
              A.column_indices[0] = 0; A.values[0] = 10;
                A.column_indices[1] = 2; A.values[1] = 20;
                  A.column_indices[2] = 2; A.values[2] = 30;
                    A.column_indices[3] = 0; A.values[3] = 40;
                      A.column_indices[4] = 1; A.values[4] = 50;
                        A.column_indices[5] = 2; A.values[5] = 60;
                          // A now represents the following matrix
                          //    [10  0 20 0]
                          //    [ 0  0  0 0 ]
                          //    [ 0  0 30 0 ]
                          //    [40 50 60 0]
                        cusp::print(A);
                        //The output is COO format.
  cusp::csr_matrix<int,float,cusp::host_memory> At;
                        cusp::transpose(A, At);
                        cusp::print(At);

        // Transfer the matrix to the device
    cusp::csr_matrix<int,float,cusp::device_memory> dA(A);
          // Convert the matrix to HYB format on the device
          /*cusp::hyb_matrix<int,float,cusp::device_memory> csr_device(csr_device);*/
    // initialize matrix
    cusp::csr_matrix<int,float,cusp::device_memory> dB(A);
    cusp::csr_matrix<int,float,cusp::device_memory> dC(A);
    // compute C = A * B
    /*cusp::multiply(A, B, C, initialize, combine, reduce);*/
    cusp::multiply(dA, dB, dC);
    /*getchar();*/
    cusp::print(dC);
    cout<<dC.num_rows<<" "<<dC.num_cols<<" "<<dC.num_entries<<" "<<dC.row_offsets[0]<<endl;
    int* hc = new int[dC.num_rows+1];
    //NOTICE: the row_offsets is array_1d type
    /*cudaMemcpy(hc, dC.row_offsets, sizeof(int)*(dC.num_rows+1), cudaMemcpyDeviceToHost);*/
    /*test_kernel<<<1,1>>>(dC.row_offsets);*/
    //TODO: no way to transform array1d into cuda pointer, or use it in my own cuda kernels?

    return 0;
}

