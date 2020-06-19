/*
*	File: 	bookcmp.asm
*	Project:	Project 7
*	Author: 	Daniel Roh
*	Date:		04/29/18
*	Section: 	3 
*	E-mail: 	droh1@umbc.edu
*
*--How to compile--
* nasm -f elf -g bookcmp.asm
* gcc -m32 -ansi -Wall -g -c sort_books.c
* gcc -m32 -ansi -g main7.o sort_books.o bookcmp.o -o sort_books
* ./sort_books < books.dat
*/

#include "book.h"
#include <stdio.h>
#include <stdlib.h>

/*Function Prototypes*/
extern int bookcmp(const struct book *, const struct book *); /*Prototype to asm function*/
/*Function will sort books by calling the asm file of qsort().
* Note - You need to pass parameters using c cdecl convention 
*/
void sort_books(struct book books[], int numBooks){
	qsort(books, numBooks, sizeof(struct book), (int(*)(const void*, const void*))bookcmp);
	/*qsort(location of data, amount of data, size of each data, function to compare)*/
}
