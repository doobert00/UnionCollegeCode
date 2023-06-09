#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

double pi(int n, int nthreads){
	double x;
	double curr_pi = 1/((double)n);
	double sum = 0;
	#pragma omp parallel for num_threads(nthreads) reduction(+:sum)
	for(int i = 0; i < n; i++){
		x = (((double)i)+0.5)*curr_pi;
		sum = sum + 4.0/(1.0+(x*x));
	}
	curr_pi *= sum;
	return curr_pi;
}

int main(int argc, char *argv[])
{
  static long num_steps = 1000000;
  int nthreads = 1;
  int n = 1;
  if (argc > 1)
	 n = strtol(argv[1],NULL,10);
  if (argc > 2)
	 nthreads = strtol(argv[2],NULL,10);


  printf("pi: %f\n",pi(n,nthreads));

}
