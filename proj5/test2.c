/*
*File: 		test2.c
*Project:	Project 5
*Author: 	Daniel Roh
*Date:		04/18/18
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
   fraction *fp1;

   init_heap();
	
	/*Add one value*/
   fp1 = new_frac();
   fp1->sign = -1;
   fp1->numerator = 2;
   fp1->denominator = 3;

   dump_heap();
   
   /*Attempt to double free item*/
   printf("Testing double freeing\n");
   del_frac(fp1);
   del_frac(fp1);
   dump_heap();
   
   /*Check try adding an item back in*/
   fp1 = init_frac(1, 1, 19);
   dump_heap();
   
   return 0 ;
}