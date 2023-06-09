#include <stdio.h>
#include <time.h>
#include <math.h>
#include <limits.h>

/*

*/ 


int main(int argc, char *argv[])
{

  //printf ("sizeof unsigned long: %lu",sizeof(unsigned long));
  //printf ("sizeof unsigned long long: %lu",sizeof(unsigned long long));
  unsigned long long bignumber = 2;
  unsigned long num_divs = 0;
  unsigned long i;
  float range = sqrt(bignumber);

  clock_t startTime = clock();
  if (bignumber != 2 && (bignumber % 2) == 0)
  {
  	num_divs++;
  }
  for (i = 3; i < range; i+=2)
  {
    if ((bignumber % i) == 0)
    {
    	num_divs ++;
    }
  }
  
  clock_t endTime = clock();
  double elapsed =  (double)(endTime - startTime) * 1000.0 / CLOCKS_PER_SEC;
  printf("The given number is ");
  if (num_divs == 0) 
  {
  	printf("prime.\n");
  }else 
  {
  	printf("not prime.\n");
  }
  printf("It has %lu factor(s).\n",num_divs);
  printf("That took %f ms\n",elapsed);
}
