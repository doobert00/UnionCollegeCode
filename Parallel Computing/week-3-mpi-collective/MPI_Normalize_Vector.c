#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h> //for random seed
#include <math.h> //need to compile with -m

//being explicit here to make code more readable
#define ROOT_NODE 0
//

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
	srand(time(NULL));  
	MPI_Init(&argc, &argv); 
	MPI_Comm_size(MPI_COMM_WORLD, &comm_sz);
	MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);
	
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
	
	//Every good C program needs an i
 	int i;
 	//Timing data is useful too
 	double t_start,t_end;
	//Vectors everyone should at least know exist
	double * v_result;
	double * v_start;
	double * local_v;

	//Normalizer info	
	double * partial_sums; //Array of partial sums
	double partial_sum;	//Local sum
	double normalizer;	//Normalizer value
	
	//Info for ScatterV-ing
	int r = SIZE%comm_sz;	
	int k = (SIZE-r)/comm_sz;
	
	//Make parameters for ScatterV here so everyone knows how big their slice is.
	int * sendcounts = malloc(comm_sz*sizeof(int));
	int * displs = malloc(comm_sz*sizeof(int));
	//Now fill them
	int curdisp = 0;
	for(i = 0; i < comm_sz; i++){
		if(r == 0){
			sendcounts[i] = k;
		}else{
			sendcounts[i] = k + 1;
			r--; 
		}
		displs[i] = curdisp;
		curdisp += sendcounts[i];
	}
		
	local_v = malloc(sendcounts[my_rank]*sizeof(double));
		
	if (my_rank == 0)
	{	
		t_start = MPI_Wtime();				//Start the clock
		v_result = malloc(SIZE*sizeof(double));
		v_start = malloc(SIZE*sizeof(double));
		v_start = randomize_vector(v_start,SIZE);	//Randomize the vector
		partial_sums =  malloc(comm_sz*sizeof(double)); //Need this to collect partial sums
	}			
	//Scatter vector sizes knowing exactly how many items you're receiving
	MPI_Scatterv(v_start, sendcounts, displs, MPI_DOUBLE, local_v, sendcounts[my_rank],MPI_DOUBLE,0,MPI_COMM_WORLD);
			
	//Compute local sum of squares
	for(i = 0; i < sendcounts[my_rank]; i++){
		partial_sum += (local_v[i]*local_v[i]); 
	}
	
	
	MPI_Gather(&partial_sum, 1, MPI_DOUBLE, partial_sums, 1, MPI_DOUBLE, 0, MPI_COMM_WORLD);
	
	if(my_rank == 0){
		//Sum the partial sums
		for(i = 0; i < comm_sz; i++){
			normalizer += partial_sums[i];
		}
		//Take the square root of the partial sums
		normalizer = sqrt(normalizer);	
	}
	
	//Send the normalizer
	MPI_Bcast(&normalizer,1,MPI_DOUBLE,0,MPI_COMM_WORLD);
			
			
	//Compute local norm
	for(i = 0; i < sendcounts[my_rank]; i++){
		local_v[i] /= normalizer;
	}
	//Collect all normed sub-vecotrs knowing exactly how big yours is
	MPI_Gatherv(local_v,sendcounts[my_rank],MPI_DOUBLE,v_result,sendcounts,displs,MPI_DOUBLE,0,MPI_COMM_WORLD);
	
	if(my_rank == 0){
		t_end = MPI_Wtime();
		printf("%f\n",(t_end-t_start)*1000);
		/*
		printf("The normalizing factor is: %f\n",normalizer);
		printf("The original vector is: ");
		print_vector(v_start,SIZE);
		printf("The normed vector is: ");
		print_vector(v_result,SIZE);
		*/	
	}	
	
	
	MPI_Finalize();
	return 0;
}
