;;File: 	escape.asm
;;Project:	Escape Sequences
;;Author: 	Daniel Roh
;;Date:		03/05/18
;;Section: 	3 
;;E-mail: 	droh1@umbc.edu

;HOW TO COMPILE
;nasm -f elf32 -g -F stabs name.asm
;ld -m elf_i386 -o name name.o

%define STDIN 0
%define STDOUT 1
%define STDERR 2
%define SYSCALL_EXIT  1
%define SYSCALL_READ  3
%define SYSCALL_WRITE 4
%define BUFLEN 256

[SECTION .data]

msg1:   db "Enter String: ",0            ; user prompt
len1:   equ $-msg1                      ; length of first message

msg2:   db "Original string: ",0        ; original string label
len2:   equ $-msg2                      ; length of second message

msg3:   db 0x0a ,"Converted string:  ", 0       ; converted string label
len3:   equ $-msg3

msg4:	db 0x0a, "Error: unknown escapse sequence \ ",0	;Error message1
len4: 	equ $-msg4 

msg5:	db 0x0a, "Error: Octal value overflow in ", 0x0a, 0	;Error message2
len5:	equ $-msg5

msg6:	db "\ " ; \\Case 
len6:	equ $-msg6

msg0:	db 0x0a	;Newline
len0:	equ $-msg0

;table: db 7d, 8d, -1d, -1d, -1d, 12d, -1d, -1d, -1d, -1d, -1d, -1d, -1d, 10d, -1d, -1d, -1d, 13d, -1d, 9d, -1d, 11d, -1d, -1d, -1d, -1d
matcher: db 7, 8, -1, -1, -1, 12, -1, -1, -1, -1, -1, -1, -1, 10, -1, -1, -1, 13, -1, 9, -1, 11, -1, -1, -1, -1
			;escape characters (a, b, f, n, r, t, and v)
			;vales for character(7d, 8d, 12d, 10d, 13d, 9d, 11d)

[SECTION .bss]
;;; Here we deecxare uninitialized data. We're reserving space (and
;;; potentially associating names with that space) that our code
;;; will use as it executes. Think of these as "global variables"

buf: resb BUFLEN                     ; buffer for read
newstr: resb BUFLEN                  ; converted string
readlen: resb 4                      ; storage for the length of string we read


[SECTION .text]
global _start                   ; make start global so ld can find it
_start:                         ; the program actually starts here
        ;; prompt for user input
        mov eax, SYSCALL_WRITE
        mov ebx, STDOUT
        mov ecx, msg1
        mov edx, len1
        int 80H

        ;; read user input
        mov eax, SYSCALL_READ
        mov ebx, STDIN
        mov ecx, buf
        mov edx, BUFLEN
        int 80H

        ;mov byte[buff + eax], 0 ;Null terminate string?
		mov byte[buf + eax-1], 0;Null terminate string?
		mov [readlen], eax	;remember how many characters we read

        ;; loop over all characters
        mov esi, buf
        mov edi, newstr

		;print out original string
		mov eax, SYSCALL_WRITE
        mov ebx, STDOUT
        mov ecx, msg2
        mov edx, len2
        int 80H
		
		mov eax, SYSCALL_WRITE
        mov ebx, STDOUT
        mov ecx, buf
        mov edx, BUFLEN
        int 80H
		
		;; print the converted string message
        mov eax, SYSCALL_WRITE
        mov ebx, STDOUT
        mov ecx, msg3
        mov edx, len3
        int 80H
		
		;Start of part 2
.loopA:
		mov ah, [esi]
		cmp ah, 0	;If you reached a null character
		je .done
		
		CALL .handle_ESC	;Go to check if a escape 
		
		inc esi
		jmp .loopA		;Loop back
		
.handle_ESC: ;SUBROTINE
		mov ecx, 0;
		mov dl, 3;
		
		cmp ah, 92	;If its not a back slash
		jne .nope

.ESC_check:		
		cmp ah, 92	;If its a double back slash
		je .doublebackcheck
		
		cmp ah, 57	;If its a number
		jle .numberCheck
		
		cmp ah, 92
		jl .CaseError
		;sub eax, 'a'	;Check if its not a char
		;mov eax, [table + al-1]
		
.ESC_check2:

		mov ebx, [esi]	
		mov al, bl		;Grab ascii
		sub al, 'a'		;convert to deci
		xor ebx, ebx	;zero ebx
		mov bl, al		;store ascii to 32
		mov ah, [matcher + ebx];ah holds the table number a position 0 + ebx
		
		cmp ah, 7
		je .bell
		
		cmp ah, 8
		je	.backspace
		
		cmp ah, 9
		je	.horitab
		
		cmp ah, 10
		je	.newline
		
		cmp ah, 11
		je	.verttab
		
		cmp ah, 12
		je	.formfeed
		
		cmp ah, 13
		je	.carrreturn
			
		RET ;Return to the call

.nope:
		mov [buf], ah	;Move ecx into memory slot buff
		mov eax, SYSCALL_WRITE
        mov ebx, STDOUT
        mov ecx, buf
        mov edx, 1
        int 80H
		RET ;return to call
		
.numberCheck:
		cmp ah, 48	;double check for number
		jge .itsanumber
		
		;ADD PART OF DOINT SOMTHING HERE
		
		jmp .ESC_check2 ;If its somehow not a number
		
.itsanumber:
		sub ah, '0'	;Convert to decimal
		;mul eax, dl
		;sub dl
		mov cl, ah
		cmp cl, 255
		jl .outofrange
		
		inc esi
		mov al, [esi]	;If another number is found
		cmp al, 57
		jle .itsanumber2
		
		dec esi
		cmp ah, 7
		je .bell
		
		cmp ah, 8
		je	.backspace
		
		cmp ah, 9
		je	.horitab
		
		ret
		
.itsanumber2:
		sub al, '0'
		
		add ah, al
		
		cmp ah, 1
		je	.newline
		
		cmp ah, 3
		je	.verttab
		
		cmp ah, 4
		je	.formfeed
		
		cmp ah, 5
		je	.carrreturn
		
		ret
		
.outofrange:
		mov eax, SYSCALL_WRITE
        mov ebx, STDOUT
        mov ecx, msg5
        mov edx, len5
        int 80H
		RET
		
.doublebackcheck:
		inc esi
		mov ah, [esi]
		
		cmp ah, 92
		je .doubleback
		
		jmp .ESC_check
		
.doubleback:
		;Back Slash
		mov eax, SYSCALL_WRITE
        mov ebx, STDOUT
        mov ecx, msg6
        mov edx, len6
        int 80H
		
		RET ;should return back to loopA?
		
.CaseError:
		mov edi, [esi];
		mov eax, SYSCALL_WRITE
        mov ebx, STDOUT
        mov ecx, msg4
        mov edx, len4
        int 80H
		
		mov [buf], edi	;Printout unknown char
		mov eax, SYSCALL_WRITE
        mov ebx, STDOUT
        mov ecx, buf
        mov edx, 1
        int 80H
		
		mov eax, SYSCALL_WRITE	;Format
        mov ebx, STDOUT
        mov ecx, msg0
        mov edx, len0
        int 80H
		
		RET

.bell:
		mov ecx, 7
		mov [buf], ecx	;Move ecx into memory slot buff
		mov eax, SYSCALL_WRITE
        mov ebx, STDOUT
        mov ecx, buf
        mov edx, 1
        int 80H
		
		RET
	
.backspace:
		mov ecx, 8
		mov [buf], ecx	;Move ecx into memory slot buff
		mov eax, SYSCALL_WRITE
        mov ebx, STDOUT
        mov ecx, buf
        mov edx, 1
        int 80H
		RET
.horitab:
		mov ecx, 9
		mov [buf], ecx	;Move ecx into memory slot buff
		mov eax, SYSCALL_WRITE
        mov ebx, STDOUT
        mov ecx, buf
        mov edx, 1
        int 80H
		RET

.newline:
		mov ecx, 10
		mov [buf], ecx	;Move ecx into memory slot buff
		mov eax, SYSCALL_WRITE
        mov ebx, STDOUT
        mov ecx, buf
        mov edx, 1
        int 80H
		RET

.verttab:
		mov ecx, 11
		mov [buf], ecx	;Move ecx into memory slot buff
		mov eax, SYSCALL_WRITE
        mov ebx, STDOUT
        mov ecx, buf
        mov edx, 1
        int 80H
		RET

.formfeed:
		mov ecx, 12
		mov [buf], ecx	;Move ecx into memory slot buff
		mov eax, SYSCALL_WRITE
        mov ebx, STDOUT
        mov ecx, buf
        mov edx, 1
        int 80H
		RET

.carrreturn:
		mov ecx, 13
		mov [buf], ecx	;Move ecx into memory slot buff
		mov eax, SYSCALL_WRITE
        mov ebx, STDOUT
        mov ecx, buf
        mov edx, 1
        int 80H
		RET
		
				
.lettercomplete:
        ;; store the letter and go on to the next one
        mov [edi], bh
        add esi, 1
        add edi, 1
        sub eax, 1
        jmp .done
		
.done:
        jmp .end

.end:
        mov eax, SYSCALL_WRITE
        mov ebx, STDOUT
        mov ecx, msg0
        mov edx, len0
        int 80H
		
		;; call sys_exit to finish things off
        mov eax, SYSCALL_EXIT   ; sys_exit syscall
        mov ebx, 0              ; no error
        int 80H                 ; kernel interrupt
		
		
		
		
		
;;/*SUDO CODE FOR PROJECT 2 IN c++ */

		
		
		
		
