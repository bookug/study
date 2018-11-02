#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
//need to use mpicc, which must be added into PATH
//mpicc will finds the header file in its installation position
#include <mpi.h>
//for open mp, and -fopenmp must be added to CFLAGS before compilation
#include <omp.h>


int main(int argc, char **argv)
{
  printf("program starts\n");
  int rank, size;

  MPI_Init(&argc, &argv);

  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  MPI_Comm_size(MPI_COMM_WORLD, &size);

# pragma omp parallel
  {
	int omp_rank = omp_get_thread_num();
	int omp_size = omp_get_num_threads();
	char hostname[100];
	gethostname(hostname, 100);
	if ( omp_rank == 0 ){
	  printf("This is process %d of %d on host %s, I have %d threads.\n", rank, size, hostname, omp_size);
	}
  }

  /*to check status in each machine*/
  /*getchar();*/
  //this do not works on mpi

  MPI_Finalize();
  return 0;
}

