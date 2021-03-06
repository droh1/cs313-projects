/*
*File: 		test1.c
*Project:	Project 5
*Author: 	Daniel Roh
*Date:		04/18/18
*Section: 	3 
*E-mail: 	droh1@umbc.edu
*
*
* --How to compile--
* gcc -m32 -ansi - Wall -g -c test1.c frac_heap.c
 */

#include <stdio.h>
#include <stdlib.h>
#include "frac_heap.h"

/*
 * Compute the greatest common divisor using Euclid's algorithm
 */
unsigned int gcd ( unsigned int a, unsigned int b) {

   if (b == 0) return a ;

   return gcd (b, a % b) ;
}

/*
 * Print a fraction out nicely
 */
void print_frac (fraction *fptr) {

   if (fptr->sign < 0) printf("-") ;

   printf("%d/%d", fptr->numerator, fptr->denominator) ;

}

/*
 * Initialize a fraction
 */
fraction *init_frac (signed char s, unsigned int n, unsigned int d) {
   
   fraction *fp ;

   fp = new_frac() ;
   fp->sign = s ;
   fp->numerator = n ;
   fp->denominator = d ;

   return fp ;
}

/*
 * Add two fractions
 * Return value is a pointer to allocated space.
 * This must be deallocated using del_frac().
 */
fraction *add_frac(fraction *fptr1, fraction *fptr2) {
   unsigned int lcm, div, g, m1, m2  ;
   fraction *answer ;


   g = gcd(fptr1->denominator, fptr2->denominator) ;
   lcm = (fptr1->denominator / g) * fptr2->denominator ;

   m1 = (fptr1->denominator / g) ;
   m2 = (fptr2->denominator / g) ;
   lcm = m1 * fptr2->denominator ;

   answer = new_frac() ;
   answer->denominator = lcm ;

   if (fptr1->sign == fptr2->sign) {

      answer->sign = fptr1->sign ;
      answer->numerator = fptr1->numerator * m2 + fptr2->numerator * m1 ;

   } else if (fptr1->numerator >= fptr2->numerator) {

      answer->sign = fptr1->sign ;
      answer->numerator = fptr1->numerator * m2 - fptr2->numerator * m1 ;

   } else {

      answer->sign = fptr2->sign ;
      answer->numerator = fptr2->numerator * m2 - fptr1->numerator * m1 ;

   }

   div = gcd(answer->numerator, answer->denominator) ;
   answer->numerator /= div ;
   answer->denominator /= div ;

   return answer ;

}


int main() {
   fraction *fp1, *fp2, *fp3, *fp4, *fp5, *fp6, *fp7, *fp8, *fp9, *fp10, *fp11,
			*fp12, *fp13, *fp14, *fp15, *fp16, *fp17, *fp18, *fp19, *fp20, *fp21;

   init_heap();
	
   fp1 = new_frac();
   fp1->sign = -1;
   fp1->numerator = 2;
   fp1->denominator = 3;

   fp2 = new_frac();
   fp2->sign = 1;
   fp2->numerator = 1;
   fp2->denominator = 4;
	
	/*Fill up the heap to max*/
   fp3 = init_frac(-1, 4, 2);
   fp4 = init_frac(-1, 6, 9);
   fp5 = init_frac(1, 3, 2);
   fp6 = init_frac(1, 1, 2);
   fp7 = init_frac(1, 4, 5);
   fp8 = init_frac(-1, 14, 2);
   fp9 = init_frac(-1, 11, 2);
   fp10 = init_frac(-1, 10, 33);
   fp11 = init_frac(-1, 3, 2);
   fp12 = init_frac(-1, 4, 45);
   fp13 = init_frac(1, 4, 4);
   fp14 = init_frac(-1, 4, 12);
   fp15 = init_frac(-1, 4, 21);
   fp16 = init_frac(1, 4, 23);
   fp17 = init_frac(-1, 42, 2);
   fp18 = init_frac(-1, 43, 42);
   fp19 = init_frac(1, 41, 2);
   fp20 = init_frac(1, 2, 19);
   
   printf("Test for filled heap operations\n");
   dump_heap();
   
   printf("\n\nAttempting to add more then spaces allowed\n");
 
	/*Try to add another item on the full heap*/
   fp21 = new_frac();
   if(fp21 == NULL){
		printf("\n\nERROR: Heap is full\n");
		dump_heap();
		return 0;
   }else{
		fp20->sign = 1;
		fp20->numerator = 10;
		fp20->denominator = 2;
   }

   return 0 ;
}