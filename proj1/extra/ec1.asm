;;File: 	ec1.asm
;;Project: 	CSMC 313 Extra Credit 1
;;Author: 	Daniel Roh
;;Date:		02/20/18
;;Section: 	3 
;;E-mail: 	droh1@umbc.edu
;;Project: An extra credit assignment for project 1 to make a valid isbn number given a 
;;		   partial isbn number.

;HOW TO COMPILE
;nasm -f elf32 -g -F stabs name.asm
;ld -m elf_i386 -o name name.o

;;variable declaration 
%define STDIN 0
%define STDOUT 1
%define STDERR 2
%define SYSCALL_EXIT  1
%define SYSCALL_READ  3
%define SYSCALL_WRITE 4
%define BUFLEN 256



[SECTION .data]
num1:	db "Enter in a ISBN partial number: "   	; Ask the user for the isbn
len1:   equ $-num1                     	 	; Get the length of isbn entered (always 10)

out1:	db "The check digit should be: " 	; Output to the user if a valid isbn is entered
len2:   equ $-out1    

outx:	db "X" , 0x0a						; Output to the user if a valid isbn is entered
lenx:   equ $-outx

oute:	db 0x0a
lene:	equ $-oute


[SECTION .bss]	;;global variables
buf: resb BUFLEN                     ; buffer for read
newstr: resb BUFLEN                  ; converted string
readlen: resb 4                      ; storage for the length of string we read

[SECTION .text]
global _start     
_start:                        		; the program actually starts here
        ;; prompt for user input
        mov eax, SYSCALL_WRITE
        mov ebx, STDOUT
        mov ecx, num1 				;Output string
        mov edx, len1				
        int 80H

        ;; read user input
        mov eax, SYSCALL_READ		;Store input into eax
        mov ebx, STDIN				;Read in values
        mov ecx, buf				;Find size
        mov edx, BUFLEN
        int 80H

        ;; remember how many characters we read
        mov [readlen], eax

        ;; loop over all characters
        mov esi, buf
        mov edi, newstr

		mov eax, SYSCALL_WRITE	;Write a message 
		mov ebx, STDOUT
		mov ecx, out1
		mov edx, len2
		int 80H
		
		mov ecx, 11	;Give cl 10 (subtracts in sum to 10)
		mov edx, 0	;Reset edx to 0
		
		
		;;START OF PART 2
.sum:	
		
		
		mov bh, [esi]	;Get the next letter
        add esi, 1
        add edi, 1
        sub eax, 1
		
		sub bh, '0'		;Subtract the ascii value of 0 to get the proper number
		mov bl, bh		;Counter for the number in bh (0-9)
		sub ecx, 1		;Subtract from multiplier (10 to 1)
		
		cmp ecx, 1		;If your done with the string
		je .check		;Go to check
		
        jmp .loop		;Jump to loop
			
.loop:
		cmp bl, 0		;If the number is 0 skip
		je .sum 		;Go to sum
		
		cmp bh, 40		;If you have X as the multiplier (40 is ascii after subtracting 0)
		je .loopten		;Add 10
		
		jmp .loop2		;else jump to loop2
		
.loop2:
		cmp bl, 0		;If the multiplier is 0
		je .sum			;Go to sum
		
		add edx, ecx	;else Add the number
		sub bl, 1
		jmp .loop2		;Loop back to add again
		
.loopten:		
		add edx, 10 	;Add 10 at cl to the sum
		jmp .sum		;Go back to sum
		
	
.check:
		mov ecx, 11 		;Set ecx to 11
		jmp .find		

.find:
		cmp ecx, edx		;If the number happens equal or greater 
		jge .found
		
		add ecx, 11		;else Add 11
		jmp .find		;Loop again
		
		
		;;START OF PART 3
.found:
		sub ecx, edx 	;Find the difference between the two
		cmp ecx, 10		;See if the difference is 10
		je .found10
		
		add ecx, '0'	;Add 0 back in to point to the correct ascii
		
		mov [buf], ecx	;Move ecx into memory slot buff
		
		mov eax, SYSCALL_WRITE	;Write a message 
		mov ebx, STDOUT
		mov ecx, buf 
		mov edx, 1
		int 80H
		
		mov eax, SYSCALL_WRITE	;Formating
		mov ebx, STDOUT
		mov ecx, oute
		mov edx, lene
		int 80H
		jmp .end				;Go to the end
			
.found10:
		mov eax, SYSCALL_WRITE	;Write a message for 10
		mov ebx, STDOUT
		mov ecx, outx
		mov edx, lenx
		int 80H
			
.end:
        ;; call sys_exit to finish things off
        mov eax, SYSCALL_EXIT   ; sys_exit syscall
        mov ebx, 0              ; no error
        int 80H                 ; kernel interrupt
