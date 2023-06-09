#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <omp.h>

double est_pi(double N,int nthreads){
	double sum = 0;
	double dx = 1/N;
	double xval = 0;
	int n = (int) N;
	#pragma omp parallel for num_threads(nthreads) reduction(+:sum)
	for(int i = 1; i < n; i++){
		xval = i * dx;
		sum += sqrt(1-(xval*xval));
	}
	double pi = 4*sum*dx;
	return pi;
}

int main(int argc, char *argv[])
{
  int nthreads = 1;
  int n = 100;
  if (argc > 4){
    printf("usage: vectors <procs> <size> or vectors <procs> <size> <seed>\n ");
    exit(1);
  }
  else {
      if (argc > 1)
        nthreads = strtol(argv[1],NULL,10); 
      if (argc > 2)
        n = atoi(argv[2]); //atoi converts a string to an int
      if (argc > 3)
        srand48(atoi(argv[3]));
      else
        srand48(time(NULL));
  }
  /*
  double e,s;
  for(int i = 1; i <= 10; i++){
  for(int j = 1000000; j < 1000000000; j= j*10){			
	s = omp_get_wtime();
	est_pi(n,nthreads);
	e = omp_get_wtime();
	printf("|\t %d \t|\t %d | %f \t|\n",i,j,e-s);
	} 
  }*/
  
  double start,end,N;
  for(int j = 100000; j < 10000001; j = j *10) {
  	for(int i = 1; i < 7; i++){
		N = (double)j;
		start = omp_get_wtime();
		est_pi(N,i);
		end = omp_get_wtime();
		printf("|\t%d\t|\t%f\t|\t%f\t|\n",i,N,end-start);
	}
  }
  
}
