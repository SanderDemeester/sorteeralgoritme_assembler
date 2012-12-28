%macro write 2
	mov eax,4		; write syscall
	mov ebx,STDOUT		; stdout
	mov edx,%2		; number of bytes
	mov ecx,%1		; buffer
	int 80h			; call kernel
%endmacro
	
section .data	
filename	db 'nummers.txt' ; just use lenth of string
filename_len	equ $-filename	 ; here we use a constant
STDOUT		equ	1	 ; stdout
	
section .bss	
number_of_ent resb 1		; reverse 1 byte
buf	      resb 4		; reverse 1 byte for printing.
	
section .text
	global _start	
_start:

	;; read first byte from file to know how many elements there are
	mov eax,5		; syscall open
	mov ebx,filename	; filename
	mov ecx,0		; read-only
	int 80h			; call kernel

	mov eax,3		; syscall read
	mov ebx,eax		; file descriptor
	mov ecx,number_of_ent	; location for storing 1 byte
	mov edx,1		; read 1 byte
	int 80h			; call the kernel
	mov eax,[number_of_ent]
	write number_of_ent, 1
	call ret		; lets go home

ret:	
	mov eax,1
	mov ebx,1
	int 80h

	
	


	