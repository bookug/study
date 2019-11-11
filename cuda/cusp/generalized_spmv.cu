//Not works

#include <cusp/array1d.h>
#include <cusp/array2d.h>
#include <cusp/multiply.h>
#include <cusp/print.h>
int main(void)
{
    // define multiply functors
    thrust::multiplies<float>          combine;
    thrust::plus<float>                reduce;
    // initialize matrix
    cusp::array2d<float, cusp::host_memory> A(2,2);
    A(0,0) = 10;  A(0,1) = 20;
    A(1,0) = 40;  A(1,1) = 50;
    // initialize input vector
    cusp::array1d<float, cusp::host_memory> x(2);
    x[0] = 1;
    x[1] = 2;
    // initial RHS filled with 2's
    cusp::constant_array<float> y(2, 2);
    // allocate output vector
    cusp::array1d<float, cusp::host_memory> z(2);
    // compute z = y + (A * x)
    cusp::generalized_spmv(A, x, y, z, combine, reduce);
    // print z
    cusp::print(z);
    return 0;
}

