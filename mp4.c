/* 					MP-4 : Printing Semi-Primes. 
A semiprime is a positive integer that is a product of two prime numbers.
k is called semiprime if k is a prime factor of n (a<=b) and (n/k) is also a prime number.
NAME : SHAMITH ACHANTA (shamith2)
DATE : 2/23/2019
PARTNERS: ahossa5, bryanfk2    */

#include <stdlib.h>
#include <stdio.h>

// function declarations
int is_prime(int number);           
int print_semiprimes(int a, int b);


int main()
{   
	int a, b, i;
	printf("Input two numbers: ");
	scanf("%d %d", &a, &b);       // take inputs
	if( a <= 0 || b <= 0 )
	{
 		printf("Inputs should be positive integers\n"); // range check
     		return 1;
	}

   	if( a > b )
	{
     		printf("The first number should be smaller than or equal to the second number\n");     			
		return 1;  // range check
   	}

   // TODO: call the print_semiprimes function to print semiprimes in [a,b] (including a and b)   	
	
	for( i = a; i<= b; i++)
	{
		if(print_semiprimes(i,i) == 1)
		{
			printf("%d\t",i);     // printing semiprimes
		}
	}
	printf("\n");      // printing new line
	return 0;
		
}


/*
 * TODO: implement this function to check the number is prime or not.
 * Input    : a number
 * Return   : 0 if the number is not prime, else 1
 */
int is_prime(int number)
{
	int i;	
	for( i = 2; i < number; i++ )
	{
		if( number % i == 0 )    // if number divisible by any number
		{			 // other than 1 and itself,
			return 0;        // then number is prime and return 0
		}
	}

	return 1;                       // else return 1
}


/*
 * TODO: implement this function to print all semiprimes in [a,b] (including a, b).
 * Input   : a, b (a should be smaller than or equal to b)
 * Return  : 0 if there is no semiprime in [a,b], else 1
 */
int print_semiprimes(int a, int b)
{
	int i, k;
	int total = 0;	
	if(a <= b)
	{
		for( i = a; i <= b; i++ )
		{
			for( k = 2; k <= (i - 1); k++ )
			{
					// check for semiprimes
				if( (is_prime(k) == 1 && (i % k == 0)) && is_prime(i/k) == 1 ) 	
				{							 					 			
                		        total += 1;
				}
			}
		}
	}
	if( total != 0 )
	{
		return 1;     // if semi-primes printed, return 1 
	}
	else
	{
		return 0;      // else return 0
	}
}



