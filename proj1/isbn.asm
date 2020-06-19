;;File: 	isbn.asm
;;Project: 	CSMC 313 ISBN validation 
;;Author: 	Daniel Roh
;;Date:		02/20/18
;;Section: 	3 
;;E-mail: 	droh1@umbc.edu

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
num1:	db "Enter in a ISBN number: "   	; Ask the user for the isbn
len1:   equ $-num1                     	 	; Get the length of isbn entered (always 10)

out1:	db "This is a vaild ISBN :)", 0x0a	; Output to the user if a valid isbn is entered
len2:   equ $-out1                      	; length of message

out2:   db "This is a INVALID ISBN", 0x0a 	; Output to user if the isbn is invalid
len3:   equ $-out2							; length of message 


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

		mov ecx, 11	;Give cl 10 (subtracts in sum to 10)
		mov edx, 0	;Reset edx to 0
		
		
		;;START OF PART 2
.sum:	
		cmp eax, 0		;If your done with the string
		je .check		;Go to check
		
		mov bh, [esi]	;Get the next letter
        add esi, 1
        add edi, 1
        sub eax, 1
		
		sub bh, '0'		;Subtract the ascii value of 0 to get the proper number
		mov bl, bh		;Counter for the number in bh (0-9)
		sub ecx, 1		;Subtract from multiplier (10 to 1)
		
        jmp .loop		;Jump to loop
			
.loop:
		cmp bl, 0		;If the number is 0 skip
		je .sum 		;Go to sum
		
		cmp bh, 40		;If you have X as the multiplier (40 is X after subtracting '0')
		je .loopten		;Add 10
		
		cmp bh, 72		;If you have x as the multiplier (72 is x after subtracting '0')
		je .loopten
		
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
		;Check if the number is a multiple of 11
		;Number should be stored in edx
		cmp edx, 11		;If the number happens to be 11
		je .divTrue
		
		cmp edx, 0		;If the number is a multiple of 11
		je .divTrue
		
		cmp edx, 0		;If the number is not a multiple 
		jl .divFalse
		
		sub edx, 11		;Add 11
		jmp .check		;Loop back 

		
		;;START OF PART 3
.divTrue:
		;; If a proper ISBN was entered
		mov eax, SYSCALL_WRITE	;Write a message 
		mov ebx, STDOUT
		mov ecx, out1
		mov edx, len2
		int 80H
		jmp .end				;Go to the end
			
		
.divFalse:
        ;; If a improper ISBN was entered
        mov eax, SYSCALL_WRITE	;Write a message 
        mov ebx, STDOUT
        mov ecx, out2
        mov edx, len2
        int 80H
        jmp .end				;Go to the end

.end:
        ;; call sys_exit to finish things off
        mov eax, SYSCALL_EXIT   ; sys_exit syscall
        mov ebx, 0              ; no error
        int 80H                 ; kernel interrupt
