/*
*File: 		frac_heap.c
*Project:	Project 6
*Author: 	Daniel Roh
*Date:		04/25/18
*Section: 	3 
*E-mail: 	droh1@umbc.edu
*
*
* --How to compile--
* gcc -m32 -ansi -Wall -g -c test1.c frac_heap.c
* gcc -m32 test1.o frac_heap.o
*/

#include "frac_heap.h"
#include <stdio.h>
#include <stdlib.h>

union fraction_block_u{
	union fraction_block_u *next;
	fraction frac;
};

typedef union fraction_block_u fraction_block; /*Link union*/

/*Global Var*/
fraction_block *head; /*For memory*/
fraction_block *fList; /*For freed blocks*/
	
/*
 * init_heap():
 * must be called once by the program using your
 * functions before calls to any other functions are made. This
 * allows you to set up any housekeeping needed for your memory
 * allocator. For example, this is when you can initialize
 * your free block list.
 */
void init_heap(void){
	head = NULL; /*Set the beginning location*/
}

/*
 * new_frac():
 * must return a pointer to fractions.
 * It should be an item taken from the list of free blocks.
 * (Don't forget to remove it from the list of free blocks!)
 * If the free list is empty, you need to get more using malloc()
 * (Number of blocks to malloc each time is specified in the project
 * description)
 */
fraction *new_frac(void){
	int x;
	int size = 5 * sizeof(fraction_block);
	fraction_block *nFrac;
	fraction_block *cFrac;
	
	if(head != NULL){ /*If the list already has items*/
		nFrac = head; /*Give nFrac the current location*/
		head = head->next; /*Give the next location to head*/
		return &nFrac->frac;
	}else{ /*If the list does not have items*/
		head = (fraction_block *) malloc(size); /*Allocate memory*/
		
		if(head == NULL){ /*In the case malloc was unable to get space*/
			printf("\n\nERROR UNABLE TO ALLOCATE ENOUGH SPACE\n\n");
			printf("TERMINATING PROGRAM\n");
			exit(1);
		}
		
		printf("malloc called(%d): returned: %p\n", size, head); /*DEBUG FOR TA*/
		
		for(x = 0; x < 4; x++){ /*Set up the linked list*/
			cFrac = &head[x];
			cFrac->next = &head[x+1];
		}
		/*Set the last item to null*/
		cFrac = &head[4];
		cFrac->next = NULL;
	}
	nFrac = head;
	head = head->next;
	
	return &nFrac->frac;
}

/*
 * del_frac():
 * takes a pointer to a fraction and adds that item to the free block list.
 * The programmer using your functions promises to never use that item again,
 * unless the item is given to her/him by a subsequent call to new_frac().
 */
void del_frac(fraction *frac){
	int x;
	int size = 5 * sizeof(fraction_block);
	fraction_block *dFrac;
	dFrac = fList;
	
	if(frac == NULL){ /*If a non existent frac was deleted*/
		return;
	}
	
	if(fList == NULL){ /*If the list has nothing*/
		fList = (fraction_block *) malloc(size); /*Allocate memory to store freed*/
		
		if(fList == NULL){ /*Check for allocation*/
			printf("\n\nERROR UNABLE TO ALLOCATE ENOUGH SPACE FOR FREED\n\n");
			printf("TERMINATING PROGRAM\n");
			exit(1);
		}
		dFrac = fList; /*Set the beginning of the allocated space*/
		dFrac->frac = *frac; /*Set the first item as the deleted item*/
		
		for(x = 0; x < 4; x++){ /*Link the lists*/
			dFrac = &fList[x];
			dFrac->next = &head[x+1];
		}
		dFrac = &fList[4];
		dFrac->next = NULL;/*Go to the empty space*/
	}else{ /*If the list already has items inside of it*/
		/*while(dFrac->frac.sign != 0){ 
			if(dFrac->next == NULL){
				break;
			}
			dFrac = dFrac->next;
		}*/
		dFrac->frac = *frac; /*Store the item*/
	}
	dFrac = (fraction_block *) fList;
}

/*
 * dump_heap():
 * For debugging/diagnostic purposes.
 * It should print out the entire contents of the free list,
 * printing out the address for each item.
 */
void dump_heap(void){
	fraction_block *nFrac;
	nFrac = head; /*Set the iterator to the first position*/
	
	printf("\n**** BEGIN HEAP DUMP ****\n\n");
	
	while(nFrac != NULL){ /*While the end of the list is not reached*/
		printf("%p\n", nFrac);
		nFrac = nFrac->next;
	}
	
	printf("**** END HEAP DUMP ****\n");
}










