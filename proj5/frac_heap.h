#ifndef _FRAC_HEAP_H
#define _FRAC_HEAP_H

/*
*File: 		frac_heap.h
*Project:	Project 5
*Author: 	Daniel Roh
*Date:		04/18/18
*Section: 	3 
*E-mail: 	droh1@umbc.edu
*
*
* Header file for frac_heap.c
*/ 

#include <stdio.h>
#include <stdlib.h>


typedef struct{
	signed char sign;
	unsigned int numerator;
	unsigned int denominator;
}fraction;

/* Global Variables */
static fraction heapX[20]; /*Global Array*/
static fraction *head = heapX; /*Head of Array*/

/*Prototypes*/
void init_heap(void);
fraction* new_frac(void);
void del_frac(fraction*);
void dump_heap(void);

#endif