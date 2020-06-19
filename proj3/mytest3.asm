;; File: mytest3.asm
;;Project:	Print Decimal
;;Author: 	Daniel Roh
;;Date:		03/26/18
;;Section: 	3 
;;E-mail: 	droh1@umbc.edu

;
; program used to test the prt_dec subroutine
;

%define STDIN 0
%define STDOUT 1
%define SYSCALL_EXIT  1
%define SYSCALL_READ  3
%define SYSCALL_WRITE 4


        SECTION .data                   ; initialized data section

lf:   	db  10            		; just a linefeed 

msg1:	db " plus "	
len1 equ $ - msg1

msg2: 	db " minus "
len2 equ $ - msg2

msg3:	db " equals "
len3 equ $ - msg3

        SECTION .text                   ; Code section.
        global  _start                  ; let loader see entry point
	extern	prt_dec

_start: 
	mov	ebx, 0
	mov	edx, 9760321
	mov	edi, 1
	mov	ebp, 59804573 

	push	dword 0x00000001
	call	prt_dec
	add	esp, 4
	call	prt_lf

	push	edi
	call	prt_dec
	add	esp, 4
	call	prt_lf

	push	ebp
	call	prt_dec
	add	esp, 4
	call	prt_lf

	push	100
	call	prt_dec
	add	esp, 4

        mov     eax, SYSCALL_WRITE      ; write message
        mov     ebx, STDOUT
        mov     ecx, msg1
        mov     edx, len1
        int     080h
	
	push	501
	call	prt_dec
	add	esp, 4

        mov     eax, SYSCALL_WRITE      ; write message
        mov     ebx, STDOUT
        mov     ecx, msg3
        mov     edx, len3
        int     080h

	push	601
	call	prt_dec
	add	esp, 4
	call	prt_lf

	push	47
	call	prt_dec
	add	esp, 4

        mov     eax, SYSCALL_WRITE      ; write message
        mov     ebx, STDOUT
        mov     ecx, msg2
        mov     edx, len2
        int     080h
	
	push	7
	call	prt_dec
	add	esp, 4

        mov     eax, SYSCALL_WRITE      ; write message
        mov     ebx, STDOUT
        mov     ecx, msg3
        mov     edx, len3
        int     080h

	push	40
	call	prt_dec
	add	esp, 4
	call	prt_lf


	push	dword 0x99999999
	call	prt_dec
	add	esp, 4
	call	prt_lf
        ; final exit
        ;
exit:   mov     EAX, SYSCALL_EXIT       ; exit function
        mov     EBX, 0                  ; exit code, 0=normal
        int     080h                    ; ask kernel to take over



	; A subroutine to print a LF, all registers are preserved
prt_lf:
	push	eax
	push	ebx
	push	ecx
	push	edx

        mov     eax, SYSCALL_WRITE      ; write message
        mov     ebx, STDOUT
        mov     ecx, lf
        mov     edx, 1			; LF is a single character
        int     080h

	pop	edx
	pop	ecx
	pop	ebx
	pop	eax
	ret

