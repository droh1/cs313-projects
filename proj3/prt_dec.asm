;; File: prt_dec.asm
;;Project:	Print Decimal
;;Author: 	Daniel Roh
;;Date:		03/26/18
;;Section: 	3 
;;E-mail: 	droh1@umbc.edu

; Program subroutine
;
;How to compile:
;nasm -f elf32 -g -F stabs main3.asm  
;nasm -f elf32 -g -F stabs prt_dec.asm 
;ld main3.o prt_dec.o -m elf_i386


%define STDIN 0
%define STDOUT 1
%define SYSCALL_EXIT  1
%define SYSCALL_READ  3
%define SYSCALL_WRITE 4
%define BUFLEN 256

SECTION .data                   ; initialized data section

lf:   	db  10            		; just a linefeed 

msg1:	db "0"	
len1 equ $ - msg1

[SECTION .bss]	;;global variables
buf: resb BUFLEN                     ; buffer for read

SECTION .text                   ; Code section.
		global prt_dec			;Set the start point

prt_dec:
	pop esi	;Store the CALL location
	pop eax ;Grab the value passed into the function?
	
	;Store registers
	push ebx
	push edx
	push edi
	push ebp
	
	;Zero registers
	xor ebx, ebx
	xor ebp, ebp
	xor edi, edi 
	xor ecx, ecx 

	mov edi, 1	;Set the multiplier initially to 0
	mov ebx, 10 ;Store the divisor 
	
	cmp eax, 0 ;If zero is given at the start
	je .zero
	
.divide:
	cmp eax, 0	;Check if the value is 0
	je .move
	
	xor edx, edx ;zero out edx
	div ebx ;Divide the number by 10
	push edx ;store the reminder
	inc ebp ;counter
	
	jmp .divide 
	
.move:
	xor ecx, ecx ;Clear edx for debugging
	xor edi, edi
	
	jmp .convert

.zero:
	add eax, '0' ;Convert into ascii
	mov [buf], eax ;Store in buffer
	mov ebp, 1 ;Give size of buffer
	
	jmp .print
	
.convert:
	;loop and multi by 10 until you get to the int
	cmp ebp, edi ;See of ebp(counter) = edi(buf counter)
	je .print
	
	pop eax ;Get the first value 
	add eax, '0' ;Convert number into ascii
	mov[buf + edi], eax ;Place number into buffer
	inc edi

	jmp .convert
		
.print:
	;Print out the converted value
	mov     eax, SYSCALL_WRITE
	mov     ebx, STDOUT
	mov     ecx, buf
	mov     edx, ebp
    int     080h
	jmp .done
	
.done:
	;restore registers
	pop ebp
	pop edi
	pop edx
	pop ebx
	
	push esi	;Restore the Call location
	ret ;Return to call