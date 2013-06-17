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
	int 80h

ret:	
	mov eax,1
	mov ebx,1
	int 80h
	
	
