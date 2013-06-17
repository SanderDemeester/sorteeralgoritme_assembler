%include "macro/macro.mac"
%include "functions/generic_functions.asm"	
section .data	
	filename	db 	'nummers.txt',0 	; filename
	newline		db  	0ah			; newline
	filename_len	equ 	$-filename	   	; length of the filename
	STDOUT		equ	1	   		; stdout
	buffer 		dd 	0		   	; buffer
	nel		dd	0			; save the nummer of elements
	begin_heap	dd	0			; begin heap
	heap_pointer	dd	0			; heap pointer

section .bss
	
section .text
	global _start	
_start:
	;; read first byte from file to know how many elements there are
	mov eax,5		; syscall open
	mov ebx,filename	; filename
	mov ecx,0		; read-only
	int 80h			; call kernel
	test eax,eax
	js ret

	mov edx,eax
	mov eax,3		; syscall read
	mov ebx,edx		; file descriptor
	mov ecx,buffer	    	; location for storing 4 bytes
	mov edx,4		; read 4 bytes
	int 80h			; call the kernel
	mov eax,[buffer]	; first line contains number of elements
	mov [nel],eax		; save in nel the number of lines
	push ebx		; save the file descr

	mov eax,45		; sys_brk
	mov ebx,0
	int 80h			; call the kernel

	mov dword [begin_heap],eax ; end of heap to begin of heap
	push eax
	mov eax,4
	mul dword [buffer] 	; for each element we need 4 bytes
	mov [buffer],eax
	pop eax
	add eax,[buffer]
	mov ebx,eax
	mov eax,45
	int 80h			; request some more memory

	pop ebx
	push eax

	mov eax,3
	mov ecx,[begin_heap]
	mov edx,[buffer]
	int 80h

	mov ecx,0		; first counter
	mov edx,[nel]		; second counter
	mov ebx,0		; third counter
	sub edx,1		; from 0 to nel-1
	mov esi,[begin_heap]

.l1:
	mov eax,[ecx*4+esi]	; our element that we will use to compare	
.l2:
	inc ebx			; we init at zero, so increment first. forall other situations in loop this is ok
	cmp ebx,ecx		; we can not go over the position of our choosen element
	je .end_l2		; if they equal, we need to end this loop
	cmp eax,[ebx*4+esi]	; compare
	jg .l2			; if eax is bigger, we need to check the next element
	sw [ecx*4+esi],[ebx*4+esi]
.end_l2:	
	mov ebx,0		; we start back at zero
	
	inc ecx
	cmp ecx,edx
	je .end
	jmp .l1
.end:
	

ret:	
	mov eax,1
	mov ebx,1
	int 80h
	
	
