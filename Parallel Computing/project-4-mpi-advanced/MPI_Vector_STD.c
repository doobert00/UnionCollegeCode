#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h> //for random seed
#include <math.h> //need to compile with -m

//being explicit here to make code more readable
#define ROOT_NODE 0
//

void randomize_vector(double *vec, int size){
	for (int p = 0; p < size; p++)
	{
		vec[p] = (double) (rand()%20 + 1);
	}
	return;
}


void PrintArray(double *array, int asize)
{
    for (int i =0; i < asize; i++)
        printf(" %f ", array[i]);
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
	     	if (argc == 3){srand(my_rank*atoi(argv[2]));
	     	}else{srand(my_rank);};
	}if(SIZE%comm_sz != 0){
		printf("Total vector size must be a multiple of comm_sz!\n");
		exit(1);
	}
	
	
	
	double * local_v = malloc((SIZE/comm_sz)*sizeof(double)); 
	randomize_vector(local_v,(SIZE/comm_sz));
	double local_sum = 0;
	double mean = 0;
	double sum_squares_diff = 0;
	double res;
	int i;
	double startTime, endTime;
	
	if(my_rank == 0){startTime = MPI_Wtime();}
	
	
	for(i = 0; i < (SIZE/comm_sz); i++){local_sum += local_v[i];}
	
	MPI_Allreduce(&local_sum, &mean, 1, MPI_DOUBLE, MPI_SUM, MPI_COMM_WORLD);
	
	mean = mean / (SIZE);
	
	for(i = 0; i < (SIZE/comm_sz); i++){sum_squares_diff += ((local_v[i]- mean)*(local_v[i]- mean));}
	
	MPI_Reduce(&sum_squares_diff, &res, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);
	
	if(my_rank == 0){
		res = sqrt(res/SIZE);
		endTime = MPI_Wtime();
		printf(" %f\n", endTime-startTime);
	}
	
	
	

	
	MPI_Finalize();
	return 0;
}
