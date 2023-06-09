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
	
	double *v1;
	double *v2;
	double *v3;
	
	if (my_rank != 0) {
		int size,i;	
		MPI_Recv(&size, 1,MPI_INT,0,0,MPI_COMM_WORLD,MPI_STATUS_IGNORE);
		//Receiving data and allocating the arrays.
		v1 = calloc(size,sizeof(double));
		v2 = calloc(size,sizeof(double));
		v3 = calloc(size,sizeof(double));
		MPI_Recv(v1,size,MPI_DOUBLE,0,0,MPI_COMM_WORLD, MPI_STATUS_IGNORE);
		MPI_Recv(v2,size,MPI_DOUBLE,0,0,MPI_COMM_WORLD, MPI_STATUS_IGNORE);
		
		for(i = 0; i < size; i++){
			v3[i] = v1[i] + v2[i];
		}
		MPI_Send(&size,1,MPI_INT,0,0,MPI_COMM_WORLD);
		MPI_Send(v3,size,MPI_DOUBLE,0,0,MPI_COMM_WORLD);
	}
	else
	{
		//Command line size arguments
		int SIZE = 0;
		if ((argc < 2) || (argc > 3)){
			printf("usage: vectors <size> or vectors <size> <seed>\n ");
			exit(1);
		}
		else {
			SIZE = atoi(argv[1]); //atoi converts a string to an int
		     //	printf("size: %d\n",SIZE);
		     	if (argc == 3){srand(atoi(argv[2]));
		     	}else{srand(time(NULL));};
		}
		//Array allocation	
		v1 = calloc(SIZE,sizeof(double));
		v2 = calloc(SIZE,sizeof(double));
		v3 = calloc(SIZE,sizeof(double));		
		//Randomize & Print the vectors
	/*
		randomize_vector(v1,SIZE);
		randomize_vector(v2,SIZE);
		printf("Vector 1: \n");
		print_vector(v1,SIZE);
		printf("Vector 2: \n");
		print_vector(v2,SIZE);
	*/	
		int q,f,l,size;
		double sub_product = 0;
		double global_product = 0;
		
		double startTime, endTime;
		startTime = MPI_Wtime();
		for (q = 1; q < comm_sz; q++)
		{	
			//Algorithm to find block indices from MPI_array_sum.c
			f = ((q-1) * (SIZE-(SIZE%(comm_sz-1))))/(comm_sz-1);
			l = (SIZE - (SIZE%(comm_sz-1)))/(comm_sz-1);
			if((SIZE%(comm_sz-1) <= (q-1))||(SIZE%(comm_sz-1) == 0)){
				f+=(SIZE%(comm_sz-1));
				l+=f;
			}else{
				f += (q-1);
				l += (f+1);
			}
			size = l-f;	
			MPI_Send(&size,1,MPI_INT,q,0,MPI_COMM_WORLD);
			MPI_Send(v1,size,MPI_DOUBLE,q, 0,MPI_COMM_WORLD);
			MPI_Send(v2,size,MPI_DOUBLE,q, 0,MPI_COMM_WORLD);
			v1+=size;
			v2+=size;
				
		}
		v1 -= SIZE;
		v2 -= SIZE;
		l = 0;
		for (q = 1; q < comm_sz; q++)
		{
			MPI_Recv(&size,1,MPI_INT,q,0,MPI_COMM_WORLD,MPI_STATUS_IGNORE);
			MPI_Recv(v1,size,MPI_DOUBLE,q,0,MPI_COMM_WORLD,MPI_STATUS_IGNORE);
			for(f = 0; f < size; f++){
				v3[f+l] = v1[f];
			}
			l += size;
		}
		
		
		endTime = MPI_Wtime();
		printf("| %d | %d | %f ms\n",comm_sz,SIZE,endTime-startTime);
		//printf("The resulting vector is: ");
		//print_vector(v3,SIZE);
		
	}
	
	//free(v1);
	//free(v2);
	//free(v3);
	MPI_Finalize();
	//please no MPI stuff after this line
	return 0;
}
