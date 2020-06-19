/*
*File: 		sort_books.c
*Project:	Project 4
*Author: 	Daniel Roh
*Date:		04/09/18
*Section: 	3 
*E-mail: 	droh1@umbc.edu
*
*
* --How to compile--
* gcc -m32 -ansi - Wall -g -c sort_books.c
* nasm -f elf -g bookcmp.asm
* gcc -m32 sort_books.o bookcmp.o -o sort_books
* ./sort_books < books.dat
*/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define TITLE_LEN       32
#define AUTHOR_LEN      20
#define SUBJECT_LEN     10

struct book {
    char title[TITLE_LEN + 1];
    char author[AUTHOR_LEN + 1];    /* first author */
    char subject[SUBJECT_LEN + 1];  /* Nonfiction, Fantasy, Mystery, ... */
    unsigned int year;              /* year of e-book release */
};

/*Function Prototypes*/
extern int bookcmp(void); /*Prototype to asm function*/
void sort_books(struct book books[], int numBooks);
void print_books(struct book books[], int numBooks);

/*Global Variables*/
struct book *book1;
struct book *book2;

#define MAX_BOOKS 100

int main(int argc, char **argv) {
    struct book books[MAX_BOOKS];
    int numBooks, numFields, i;
	
    for (i = 0; i < MAX_BOOKS; i++) {
	/* Sample line: "Breaking Point, Pamela Clare, Romance, 2011" */

	/* I decided to give you the scanf() format string; note that
	 * for the string fields, it uses the conversion spec "%##[^,]",
	 * where "##" is an actual number. This says to read up to a
	 * maximum of ## characters (not counting the null terminator!),
	 * stopping at the first ','  Also note that the first field spec--
	 * the title field--specifies 80 chars.  The title field is NOT
	 * that large, so you need to read it into a temporary buffer first.
	 * All the other fields should be read directly into the struct book's
	 * members.
	 */
	 
		char tempT[80];
		int count = 0;
		
		numFields = scanf("%80[^,], %20[^,], %10[^,], %u \n", tempT, books[i].author, books[i].subject, &books[i].year);			
		
		if (numFields == EOF) { /*Check if you reach the end of the file*/
			numBooks = i;
			break;
		}
		if(numFields < 4){ /*If not every field is put int properly */
			exit(1);
		}
		

	/* Now, process the record you just read.
	 * First, confirm that you got all the fields you needed (scanf()
	 * returns the actual number of fields matched).
	 * Then, post-process title (see project spec for reason)
	 */
		for(count = 0; count < 32; count++){ /*Get the length of the input */
			if(books[i].title[count] == '0'){ /*check if a null is reached */
				break;
			}
			books[i].title[count] = tempT[count]; /*Add a char to the struct*/
		}

		books[i].title[count] = '0'; /*Add null*/
    }
	
    sort_books(books, numBooks);

    print_books(books, numBooks);

    exit(1);
}

/*
 * sort_books(): receives an array of struct book's, of length
 * numBooks.  Sorts the array in-place (i.e., actually modifies
 * the elements of the array).
 *
 * This is almost exactly what was given in the pseudocode in
 * the project spec--need to replace STUBS with real code
 */
void sort_books(struct book books[], int numBooks) {
    int i, j, min;
    int cmpResult = 0;
	struct book temp;

    for (i = 0; i < numBooks - 1; i++) { /*For the amount of books in the array*/
		min = i;
		for (j = i + 1; j < numBooks; j++) { /*Item of books*/

			book1 = &books[min]; 
			book2 = &books[j];
						
			cmpResult = bookcmp(); /*Go to bookcmp.asm function*/
			
			if(cmpResult == 1){
				min = j;
			}
		}
		
		if (min != i) { /*If a smaller book is found*/
			temp = books[i];
			books[i] = books[min];
			books[min] = temp;
		}
    }
}

void print_books(struct book books[], int numBooks) {	
	int x;
	
	for(x = 0; x < numBooks; x++){
		printf("%s, %s, %s, %d \n" ,books[x].title, books[x].author, books[x].subject, books[x].year);
	}
	
	printf("\n"); /*Formatting*/

}
