#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h> //for random seed
#include <math.h> //need to compile with -m
#include <string.h>
//being explicit here to make code more readable
#define ROOT_NODE 0
//

void randomize_vector(int *vec, int size){
	for (int p = 0; p < size; p++)
	{
		vec[p] = (int) rand()%20 + 1;
	}
	return;
}


int CompareInts(const void * a, const void * b) {
   return ( *(int*)a - *(int*)b );
}
//Use this in your MPI Sorting Code
void PrintArray(int *array, int asize)
{
    for (int i =0; i < asize; i++)
        printf(" %d ", array[i]);
    printf("\n");
    return;

}

//Use this in your MPI Sorting Code
void SortMySlice(int *slice, int slicesize)
{
    qsort(slice,slicesize,sizeof(int),CompareInts);
    return;
}

//swap two integers
void Swap(int *a, int *b)
{
                int tmp = *a;
                *a=*b;
                *b = tmp;
                return;

}

void MergeSlicesKeepSmallerBetter(int *myslice, int mysize, int *otherslice, int othersize)
{

	int * smallest = malloc(mysize*sizeof(int));
	int smallindex = 0;
	int myindex = 0;
	int otherindex = 0;
	while (smallindex < mysize)
	{
		int mine = myslice[myindex];
		int others = otherslice[otherindex];
		if (mine <= others)
		{
			smallest[smallindex] = mine;
			myindex++;
		}
		else{
			smallest[smallindex] = others;
			otherindex++;
		}
		smallindex++;
	}

	memcpy(myslice,smallest,mysize*sizeof(int));
	free(smallest);
	return;
}

//same as above, but keep the largest mysize elements
void MergeSlicesKeepBiggerBetter(int *myslice, int mysize, int *otherslice, int othersize)
{

	int * biggest= malloc(mysize*sizeof(int));
	int bigindex = mysize-1;
	int myindex = mysize-1;
	int otherindex = mysize - 1;

	while (bigindex >= 0)
	{
		int mine = myslice[myindex];
		int others = otherslice[otherindex];
		if (mine >= others)
		{
			biggest[bigindex] = mine;
			myindex--;
		}
		else{
			biggest[bigindex] = others;
			otherindex--;
		}
		bigindex--;
	}

	memcpy(myslice,biggest,mysize*sizeof(int));
	free(biggest);
	return;

}


//Merges to equally sized arrays of integers
// only caring to keep the smallest items across the two arrays
// in myslice
void MergeSlicesKeepSmaller(int *myslice, int mysize, int *otherslice, int othersize)
{
    //it's less fun to do recursively than you might imagine.
    for (int i = 0; i < mysize; i++)
    {
        for (int j = 0; j <= i; j++){
            if (otherslice[j] < myslice[i]) {
                Swap(myslice+i,otherslice+j);
            }
        }
    }
    return;

}

void MergeSlicesKeepBigger(int *myslice, int mysize, int *otherslice, int othersize)
{
    //it's less fun to do recursively than you might imagine.
    for (int i = mysize-1; 0 <= i; i--)
    {
        for (int j = mysize-1; i <= j; j--){
            if (otherslice[j] > myslice[i]) {
                Swap(myslice+i,otherslice+j);
            }
        }
    }
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
	if(SIZE%comm_sz != 0){
		printf("Vector size must be a multiple of comm_sz\n");
		exit(1);
	}
	
	//Every good C program needs an i
 	int i;
 	int s = SIZE/comm_sz;
	//Vectors everyone should know about
	int * v_result;
	int * v_start;
	int * local_v = malloc(s*sizeof(int));
	int * other_v = malloc(s*sizeof(int));
	double startTime, endTime;
	
	
	if(my_rank == 0){
		v_result = malloc(SIZE*sizeof(int));
		v_start = malloc(SIZE*sizeof(int));
		randomize_vector(v_start,SIZE);
		startTime = MPI_Wtime();			
	}
	
	MPI_Scatter(v_start,s,MPI_INT,local_v,s,MPI_INT,0,MPI_COMM_WORLD);
	
	SortMySlice(local_v,s);
	for(i = 0; i < comm_sz; i++){
		if(i%2 == 0){
			if((my_rank%2 == 0) && ((my_rank + 1) < comm_sz)){
				MPI_Sendrecv(local_v,s,MPI_INT,my_rank+1,0,
				other_v,s,MPI_INT,my_rank+1,0,MPI_COMM_WORLD,MPI_STATUS_IGNORE);
				MergeSlicesKeepSmallerBetter(local_v, s, other_v, s);	
			}else if((my_rank%2 == 1) &&((my_rank - 1) >= 0)){
				MPI_Sendrecv(local_v,s,MPI_INT,my_rank-1,0,
				other_v,s,MPI_INT,my_rank-1,0,MPI_COMM_WORLD,MPI_STATUS_IGNORE);
				MergeSlicesKeepBiggerBetter(local_v, s, other_v, s);
			}
		}else{
			if((my_rank%2 == 1) && ((my_rank + 1) < comm_sz)){
				MPI_Sendrecv(local_v,s,MPI_INT,my_rank+1,0,
				other_v,s,MPI_INT,my_rank+1,0,MPI_COMM_WORLD,MPI_STATUS_IGNORE);
				MergeSlicesKeepSmallerBetter(local_v, s, other_v, s);
			}else if((my_rank%2 == 0) &&((my_rank - 1) > 0)){
				MPI_Sendrecv(local_v,s,MPI_INT,my_rank-1,0,
				other_v,s,MPI_INT,my_rank-1,0,MPI_COMM_WORLD,MPI_STATUS_IGNORE);	
				MergeSlicesKeepBiggerBetter(local_v, s, other_v, s);
			}
		}		
	}
	
	MPI_Gather(local_v,s,MPI_INT,v_result,s,MPI_INT,0,MPI_COMM_WORLD);
	
	free(local_v);
	free(other_v);
	if(my_rank == 0){
		endTime = MPI_Wtime();
		printf("%f\n",(endTime - startTime));
	/*
		printf("Start: ");
		PrintArray(v_start,SIZE);
		printf("End: ");
		PrintArray(v_result,SIZE);
	*/
	}
	MPI_Finalize();
	return 0;
}
