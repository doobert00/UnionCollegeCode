#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

/*
vectors.c for week 1 bootcamp
author: John Rieffel

*/

//argc is the argument count from the commandline
//argc is always at least 1, because the excutable
//is an argument
//
//each argument is held in a separate string.
//argv is an *array* of strings

double * vector_dot_product(double *vec1, double *vec2, int size){
	double * new_vec =  calloc(size,sizeof(double));
	double * vec_end = vec1 + size;
	double * q = new_vec;
	double * p;
	for (p = vec1; p < vec_end; p++){
		*q = *p;
		q++;
	}
	q = new_vec;
	vec_end = vec2 + size;
	for (p = vec2; p < vec_end; p++){
		*q *= *p;
		q++;
	}
	return new_vec;
}

double * vector_addition(double *vec1, double *vec2, int size){
	double * new_vec =  calloc(size,sizeof(double));
	double * vec_end = vec1 + size;
	double * q = new_vec;
	double * p;
	for (p = vec1; p < vec_end; p++){
		*q = *p;
		q++;
	}
	q = new_vec;
	vec_end = vec2 + size;
	for (p = vec2; p < vec_end; p++){
		*q += *p;
		q++;
	}
	return new_vec;
}
//Useful for testing vector operations
double * derandomize_vector(double *vec, int size){
	
	for (int i = 0; i < size; i++)
	{
		vec[i] = i;
	}
	return vec;
}

double * randomize_vector_p(double *vec, int size){
	double * p;
	double * vec_end = vec + size;
	for (p = vec; p < vec_end; p++)
	{
		*p = drand48();
	}
	return vec;
}

double * randomize_vector(double *vec, int size)
{
  int index;
  for (index= 0; index< size; index++ ) {
   vec[index] = drand48();
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

void print_vector_p(double *vec, int size)
{
  double *p;
  double * vec_end = vec+size;
  for (p = vec; p < vec_end; p++)
  {
    printf("%f ", *p);
  }
  printf("\n");
}
int main(int argc, char *argv[])
{
  int SIZE = 0;

  if ((argc < 2) || (argc > 3)){
    printf("usage: vectors <size> or vectors <size> <seed>\n ");
    exit(1);
  }
  else {
      SIZE = atoi(argv[1]); //atoi converts a string to an int
      printf("size: %d\n",SIZE);
      if (argc == 3)
        srand48(atoi(argv[2]));
      else
        srand48(time(NULL));
  }


//calloc, unlike malloc, zeros the allocated memory
  double * vector1 =  calloc(SIZE,sizeof(double));
  double * vector2 =  calloc(SIZE,sizeof(double));
 
  vector1 = randomize_vector_p(vector1, SIZE);
  vector2 = randomize_vector_p(vector2, SIZE);
  print_vector_p(vector1,SIZE);
  print_vector_p(vector2,SIZE);
 	
  vector1 = derandomize_vector(vector1, SIZE);
  vector2 = derandomize_vector(vector2, SIZE);

  clock_t startTime = clock();	  
  double * vector3 = vector_addition(vector1,vector2,SIZE);
  clock_t endTime = clock();
  print_vector(vector3, SIZE);
  printf("It took %f ms to perform vector addition.\n",(double)(endTime - startTime)*1000.0/CLOCKS_PER_SEC); 
  
  startTime = clock();
  double * vector4 = vector_dot_product(vector3,vector2,SIZE);
  endTime = clock();
  print_vector(vector4,SIZE);
  printf("It took %f ms to perform the dot product operation.\n",(double)(endTime - startTime)*1000.0/CLOCKS_PER_SEC);
}	
