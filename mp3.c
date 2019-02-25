/* MP-3 : Program to print a row of Pascal's Triangle 
   We compute the nth cofficient in mth row using nCm formula
   Name : Shamith Achanta (shamith2) 
   Partners: ahossa5, bryanfk2 */

#include <stdio.h>
#include <stdlib.h>

int main()
{
  int row, m = 0; // m is row index
  unsigned long int i; // i is the incrementing 'i' in nCm formula

  printf("Enter a row index: ");
  scanf("%d", &row);

  for(m = 0; m <= row; m++)
  {	
	// n is the binomial coefficient
	unsigned long int n = 1 ;

	// loop for computing coefficient
	for(i = 1; i <= m; i++)
  	{
      		n = n * (row + 1 - i) / i ;
  	}
	// print coefficient
	printf("%lu ", n);
  }

  // print new line
  printf("\n") ;

  return 0;
}
