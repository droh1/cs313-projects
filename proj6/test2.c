/*
*File: 		test2.c
*Project:	Project 6
*Author: 	Daniel Roh
*Date:		04/25/18
*Section: 	3 
*E-mail: 	droh1@umbc.edu
*
*
* --How to compile--
* gcc -m32 -ansi - Wall -g -c test2.c frac_heap.c
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
   fraction *fp1, *fp2, *fp3, *fp4, *fp5, *fp6, *fp7, *fp8, *fp9, *fp10, *fp11, *fp12, *fp13, *fp14,
			*fp15, *fp16, *fp17, *fp18, *fp19, *fp20, *fp21, *fp22, *fp23;

   init_heap();
	
   /*Attempt to add alot of items*/
   printf("Testing allocating alot of items\n");

   
   /*Check try adding an item back in*/
   fp1 = init_frac(1, 1, 12);
   fp2 = init_frac(-1, 3, 9);
   fp3 = init_frac(-1, 6, 2);
   fp4 = init_frac(-1, 5, 2);
   fp5 = init_frac(1, 4, 2);
   fp6 = init_frac(1, 1, 2);
   fp7 = add_frac(fp6, fp4);
   fp8 = add_frac(fp1, fp4);
   fp9 = add_frac(fp4, fp3);
   fp10 = add_frac(fp8, fp9);
   dump_heap();
   
   fp11 = add_frac(fp1, fp4);
   fp12 = add_frac(fp5, fp4);
   fp13 = add_frac(fp6, fp3);
   fp14 = add_frac(fp7, fp5);
   fp15 = add_frac(fp6, fp6);
   fp16 = add_frac(fp6, fp7);
   fp17 = add_frac(fp11, fp8);
   fp18 = add_frac(fp12, fp9);
   fp19 = add_frac(fp13, fp10);
   fp20 = add_frac(fp16, fp14);
   fp21 = init_frac(1, 1, 1);
   fp22 = init_frac(1, 2, 2);
   fp23 = init_frac(1, 3, 3);
   dump_heap();
   
   return 0 ;
}