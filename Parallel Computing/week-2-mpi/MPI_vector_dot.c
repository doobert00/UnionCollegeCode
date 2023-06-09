#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
//to compile: mpicc -std=c99 -Wall MPI_blank_template.c -o MPI_blank
//to run (simple): mpirun ./MPI_blank

double * randomize_vector(double *vec, int size){
	double * p;
	double * vec_end = vec + size;
	for (p = vec; p < vec_end; p++)
	{
		*p = rand()%20 + 1;
	}
	return vec;
}

void print_vector(double *vec, int size)
{
	int index;
	for (index= 0; index< size; index++ ) {
	printf("%f ", vec[index]);
	}
	printf("\n");
	return;
}

int main(int argc, char *argv[]){


	int        comm_sz;               /* Number of processes    */
	int        my_rank;               /* My process rank        */
	//Don't put any MPI stuff before this line

	
	MPI_Init(&argc, &argv);  //sets up the MPI. Always this line!
	
	
	/* Get the number of processes */
	MPI_Comm_size(MPI_COMM_WORLD, &comm_sz);

	/* Get my rank among all the processes */
	MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);

	//Command line size arguments
	int SIZE = 0;
	if ((argc < 2) || (argc > 3)){
		printf("usage: vectors <size> or vectors <size> <seed>\n ");
		exit(1);
	}
	else {
		SIZE = atoi(argv[1]); //atoi converts a string to an int
	     	if (argc == 3){srand(atoi(argv[2]));
	     	}else{srand(time(NULL));};
	}
	//Array allocation	
	double * v1 = calloc(SIZE,sizeof(double));
	double * v2 = calloc(SIZE,sizeof(double));

	if (my_rank != 0) {	
		//Receiving all data and allocating the arrays.
		MPI_Recv(v1,SIZE,MPI_DOUBLE,0,0,MPI_COMM_WORLD, MPI_STATUS_IGNORE);
		MPI_Recv(v2,SIZE,MPI_DOUBLE,0,0,MPI_COMM_WORLD, MPI_STATUS_IGNORE);
		
		//Algorithm to find block indices from MPI_array_sum.c
		int f = ((my_rank-1) * (SIZE-(SIZE%(comm_sz-1))))/(comm_sz-1);
		int l = (SIZE - (SIZE%(comm_sz-1)))/(comm_sz-1);
		if((SIZE%(comm_sz-1) <= (my_rank-1))||(SIZE%(comm_sz-1) == 0)){
			f+=(SIZE%(comm_sz-1));
			l+=f;
		}else{
			f += (my_rank-1);
			l += (f+1);
		}
		
		//Computing the partial dot product
		double partial_product = 0;
		v1 += f;
		v2 += f;
		for(int i = f; i < l; i++){
			partial_product += ((*v1) * (*v2));
			v1++;
			v2++;
		}
		MPI_Send(&partial_product,1,MPI_DOUBLE,0,0,MPI_COMM_WORLD);
	}
	else
	{	
		//printf("size: %d\n",SIZE);
		//Randomize & Print the vectors
		randomize_vector(v1,SIZE);
		randomize_vector(v2,SIZE);
		
		//printf("Vector 1: ");
		//print_vector(v1,SIZE);
		//printf("Vector 2: ");
		//print_vector(v2,SIZE);	
		
		
		int q;
		double sub_product = 0;
		double global_product = 0;
		double startTime, endTime;
		startTime = MPI_Wtime();
		
		for (q = 1; q < comm_sz; q++)
		{	
			MPI_Send(v1,SIZE,MPI_DOUBLE,q, 0,MPI_COMM_WORLD);
			MPI_Send(v2,SIZE,MPI_DOUBLE,q, 0,MPI_COMM_WORLD);
				
		}
		for (q = 1; q < comm_sz; q++)
		{
			MPI_Recv(&sub_product,1,MPI_DOUBLE,q,0,MPI_COMM_WORLD,MPI_STATUS_IGNORE);	
			global_product += sub_product;
		}
		endTime = MPI_Wtime();
  		double elapsed =  (double)(endTime - startTime) * 1000.0 / CLOCKS_PER_SEC;
		printf("| %d | %d | %f \n",comm_sz,SIZE,elapsed);
		//printf("The dot product is: %f\n", global_product);
	}


	MPI_Finalize();
	//please no MPI stuff after this line
	return 0;
}
