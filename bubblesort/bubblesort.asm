%macro write 2
	mov eax,4		; write syscall
	mov ebx,STDOUT		; stdout
	mov edx,%2		; number of bytes
	mov ecx,%1		; buffer
	int 80h			; call kernel
%endmacro
	
section .data	
filename	db 'nummers.txt',0 ; just use lenth of string
filename_len	equ $-filename	 ; here we use a constant
STDOUT		equ	1	 ; stdout
buffer 		db 0
	
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
	pushad
	mov eax,3		; syscall read
	mov ebx,edx		; file descriptor
	mov ecx,buffer	    	; location for storing 4 bytes
	mov edx,1		; read 4 bytes
	int 80h			; call the kernel
	popad

	mov eax,4
	mov ebx,STDOUT
	mov ecx,buffer
	mov edx,1
	int 80h
	call ret		; lets go home

ret:
	mov eax,1
	mov ebx,1
	int 80h

	
	


	