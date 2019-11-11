#include <cusp/array1d.h>
#include <cusp/array2d.h>
#include <cusp/functional.h>
#include <cusp/multiply.h>
#include <cusp/print.h>
#include <cusp/complex.h>

/* struct mixed_complex : public thrust::binary_function<cusp::complex<float>,float,float> */
struct mixed_combine : public thrust::binary_function<float,cusp::complex<float>,float>
{
 __host__ __device__
 float operator()(float x, cusp::complex<float> y) { return x * y.real(); }
};

struct mixed_reduce : public thrust::binary_function<float,cusp::complex<float>,float>
{
 __host__ __device__
 float operator()(cusp::complex<float> x, float y) { return x.real() + y; }
};

int main(void)
{
    cusp::constant_functor< cusp::complex<float> > initialize;
    mixed_combine                 combine;
    mixed_reduce                  reduce;

    // initialize matrix
    cusp::array2d<float, cusp::host_memory> A(2,2);
    A(0,0) = 10;  A(0,1) = 20; 
    A(1,0) = 40;  A(1,1) = 50; 
    // initialize input vector
    cusp::array1d<cusp::complex<float>, cusp::host_memory> x(2);
    x[0] = 1;
    x[1] = 2;
    // allocate output vector
    cusp::array1d<cusp::complex<float>, cusp::host_memory> y(2);
    // compute y = A * x
    cusp::multiply(A, x, y, initialize, combine, reduce);
    // print y
    cusp::print(y);
    return 0;
}

