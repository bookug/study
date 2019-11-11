//NOTICE: multiply can be used to compute spmm and spmv, with user-defined combine/reduce operators
//http://cusplibrary.github.io/group__matrix__algorithms.html#ga64aac53ca20d88d71aadc7e8b3317788

//NOTICE: array2d is not csr structure! 
//And GPU is not used in this file!

#include <cusp/array1d.h>
#include <cusp/array2d.h>
#include <cusp/detail/functional.h>
#include <cusp/multiply.h>
#include <cusp/print.h>

/*#define SIZE 2*/
#define SIZE 2000

int main(void)
{
    // define multiply functors
    thrust::identity<int> identity;  //C+=A*B
    cusp::detail::zero_function<int> initialize;  //C=A*B
    /*cusp::detail::absolute<int> initialize;*/
    /*thrust::plus<int> combine;*/
    /*thrust::multiplies<int>       reduce;*/
    thrust::plus<int> combine;
    thrust::plus<int>       reduce;
    // initialize matrix
    cusp::array2d<int, cusp::host_memory> A(SIZE,SIZE);
    A(0,0) = 10;  A(0,1) = 20;
    A(1,0) = 40;  A(1,1) = 50;
    // initialize input matrix
    cusp::array2d<int, cusp::host_memory> B(SIZE,SIZE);
    B(0,0) = 11;  B(0,1) = 21;
    B(1,0) = 41;  B(1,1) = 51;
    // allocate output matrix
    cusp::array2d<int, cusp::host_memory> C(SIZE,SIZE);
    // compute C = A * B
    /*cusp::multiply(A, B, C, initialize, combine, reduce);*/
    cusp::multiply(A, B, C);
    /*getchar();*/
    /*cusp::print(C);*/
    return 0;
}

