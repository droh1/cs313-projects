/*
*	sort_book.c
*
*
*/

#include "book.h"
#include <stdio.h>
#include <stdlib.h>

/*Function Prototypes*/
extern int bookcmp(const struct book *, const struct book *); /*Prototype to asm function*/

/*Function will sort books by calling the asm file of qsort().
* Note - You need to pass parameters using c cdecl and update code via stack
*/
void sort_books(struct book books[], int numBooks){
	
	qsort(books, numBooks, sizeof(books), bookcmp);
	/*qsort(First location of data, amount of data, size of each data, function to compare)*/
}
