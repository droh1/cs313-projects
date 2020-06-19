; File: bookcmp.asm
;
; 
;

%define STDIN 0
%define STDOUT 1
%define SYSCALL_EXIT  1
%define SYSCALL_READ  3
%define SYSCALL_WRITE 4

;Offsets for data locations
%define TITLE_OFFSET 0 
%define AUTHOR_OFFSET 33
%define SUBJECT_OFFSET 54 
%define YEAR_OFFSET 68

[SECTION .data]                   ; initialized data section
	
[SECTION .bss]
	extern	book1, book2	;External variables from sort_book.c

[SECTION .text]              ; Code section.
    global  bookcmp         ; let loader see entry point
		


bookcmp: 
	;Save original registers
	push ebx
	push ecx
	push edx
	push esi
	push edi
	push esp
	push ebp
	
	xor eax, eax ;zero register
	
	mov ecx, [book1] ;Load book into register
	mov edx, [book2] ;Load book into register
	mov ecx, [ecx + YEAR_OFFSET] ;Move the memory to the year
	mov edx, [edx + YEAR_OFFSET] ;Move the memory to the year
	
	cmp ecx, edx ;if book one is larger
	jg .great
	jl .less
	je .equal
	
.great:
	mov eax, 1
	jmp .end
	
.less:
	mov eax, -1
	jmp .end

;In the case that the years are the same and Title needs to be used
.equal:
	mov ecx,[book1]
	mov edx,[book2]
	
	cmp ecx, edx
	xor esi, esi ;Zero char check
	xor edi, edi ;zero int check
	jmp .loop
	
.loop:
	mov dh, [ecx + esi + TITLE_OFFSET]
	mov dl, [edx + esi + TITLE_OFFSET]
	
	cmp dh, dl
	jg .less
	jl .great
	
	cmp dh, 0 ;If a null is reached
	je .end
	cmp dl, 0 ;If a null is reached
	je .end
	
	mov eax, 0; in the case the end is reached
	inc edi
	inc esi
	jmp .loop

	
.end:	
	;Return original registers
	pop ebp
	pop esp
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx

	ret ;Return to function

