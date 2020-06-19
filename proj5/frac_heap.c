/*
*File: 		frac_heap.c
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

#include "frac_heap.h"

/*
*	Initialize the Heap
*/
void init_heap(){
	int x;
	fraction *fptr;
	fptr = head;
	
	/* Initialize the array */
	for(x = 0; x < 20; x++){ /*Check this for out of bounds*/
		fptr->sign = 0;
		fptr->numerator = 0;
		fptr->denominator = (x+1);
		fptr++;
	}
	
	/* Initialize the "21" spot */
	fptr->sign = 0;
	fptr->numerator = 0;
	fptr->denominator = 999; /* -1 denotes the last spot of the array */
}


/*
*	Put in a new fraction
*/
fraction* new_frac(){
	fraction *fptr;
	fptr = head;
	
	while(fptr->denominator != 999){ /*While the last item in the array is not hit*/
		if(fptr->sign == 0 && fptr->numerator == 0){ /*If the array slot is not used*/
			return fptr; 
		}
		fptr++;
	}
	/*In the case the array is full*/
	return NULL;
}

/*
*	Delete the item in the array location
*/
void del_frac(fraction *fptr){
	fptr->sign = 0;
	fptr->numerator = 0;
	fptr->denominator = ((new_frac()- 1)->denominator); /*Get the next free location*/	
}

/*
*	Print out the items in the array
*/
void dump_heap(){
	int x;
	fraction *fptr;
	fptr = head;
	fraction *free;
	free = new_frac(); /*Get the next free location*/
	printf("\n======= HEAP DUMP =======\n");
	
	if((free) == NULL){
		printf("-No More Free: HEAP FULL\n\n"); /* In the case the heap is full */
	}else if(free->denominator == 0){ /* In the case the first item is the free element */
		printf("-First Free: 0\n\n");
	}else{
		printf("-First Free: %d\n\n", free->denominator - 1); /*Print the next open spot */
	}
	/* Print all the items */
	for(x = 0; x < 20; x++){
		printf("%d: %d\t%u\t%u\n", x, fptr->sign, fptr->numerator, fptr->denominator);
		fptr++; /* Move to the next item */
	}
	
	printf("------- END DUMP --------\n");
}