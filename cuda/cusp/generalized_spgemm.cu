//not works

#include <cusp/coo_matrix.h>
#include <cusp/detail/functional.h>
#include <cusp/multiply.h>
#include <cusp/print.h>
#include <cusp/gallery/poisson.h>
int main(void)
{
    // define multiply functors
    thrust::identity<float>   identity;
    cusp::detail::zero_function<float> zero;
    thrust::multiplies<float> combine;
    thrust::plus<float>       reduce;
    // initialize matrix
    cusp::coo_matrix<int,float,cusp::host_memory> A;
    cusp::gallery::poisson5pt(A, 3, 3);
    // allocate output matrices and initialize output nonzeros
    cusp::coo_matrix<int, float, cusp::host_memory> B(A);
    cusp::coo_matrix<int, float, cusp::host_memory> C(A);
    // compute B = A * A
    cusp::generalized_spgemm(A, A, B, zero, combine, reduce);
    // compute C += A * A
    cusp::generalized_spgemm(A, A, C, identity, combine, reduce);
    // print output matrices
    cusp::print(B);
    cusp::print(C);
    return 0;
}

