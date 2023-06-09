#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <omp.h>

void print_mat(double*A,int N){
	for (int row = 0; row < N; row++ ) {
	  for (int col = 0; col < N; col++) {
	      printf("%f ",A[row*N + col]);
	  }
	  printf("\n");
	}
	printf("\n");
}


void mat_trasnp_OMP(double * A, int n, int nthreads){
	double t = 0.0;
	for(int i = 0; i < n; i++){
		#pragma omp parallel for num_threads(nthreads) schedule(static,100)
		for(int j = i+1; j < n; j++){
			t = A[i*n + j];
			A[i*n + j] = A[j*n + i];
			A[j*n + i] = t;
		}
	}	
}
void mat_transp(double * A, int n){
	double t = 0.0;
	for(int i = 0; i < n; i++){
		for(int j = i+1; j < n; j++){
			t = A[i*n + j];
			A[i*n + j] = A[j*n + i];
			A[j*n + i] = t;
		}
	}
}


void mat_add_OMP(double * A, double * B, double * res,int n, int nthreads){
	#pragma omp parallel for num_threads(nthreads) schedule(static,100)
	for(int i = 0; i < n; i++){
		for(int j = 0; j < n; j++){
			res[i*n + j] = A[i*n + j] + B[i*n + j];
		}
	}
	
}
void mat_add(double * A, double * B, double * C,int n){
	for(int i = 0; i < n; i++){
		for(int j = 0; j < n; j++){
			C[i*n + j] = A[i*n + j] + B[i*n + j];
		}
	}
	
}

int main(int argc, char *argv[])
{

  int N = 0;
  // THIS WILL BE YOUR RANDOM SEED
  // YES IT IS NON-RANDOM - Read the lab!
  unsigned short xi[3] = {1,9,99};
  double somenum = erand48(xi);

/* Not needed if collecting timing data.
  if (argc != 2){
    printf("usage: matrices <rows> <cols>\n ");
    exit(1);
  }
  else{
      N = atoi(argv[1]);
      printf("Rows: %d, Cols: %d\n",N,N);
  }
*/

//For pretty printing the timing tables.
int p[5] = {1,2,4,8,12};
int n[4] = {100,500,1000,2000};
double start, end;
for(int i = 0; i < 5; i++) {
	printf("|%d\t",p[i]);
	for(int j = 0; j < 4; j++){
  		double * A = calloc(n[j]*n[j],sizeof(double));
		double * B = calloc(n[j]*n[j],sizeof(double));
		double * C = calloc(n[j]*n[j],sizeof(double));
		int row,col;
		for (row = 0; row < n[j]; row++ ) {
		  for (col = 0; col < n[j]; col++) {
		      A[row*n[j] + col] = 1.0;
		      B[row*n[j] + col] = 2.0;
		      C[row*n[j] + col] = 0.0;
		  }
		}
		start = omp_get_wtime();
		mat_add_OMP(A,B,C,n[j],p[i]);
		end = omp_get_wtime();
		printf("|%f\t",end-start);
		free(A);
		free(B);
		free(C);
	}
	printf("|\n");
  }

 //free(MAT); //don't FREE! C99 takes care of it if allocated like this
 //(instead of via malloc)
}
