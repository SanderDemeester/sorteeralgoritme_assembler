%macro write 3
	mov eax,4		; write syscall
	mov ebx,STDOUT		; stdout
	mov ecx,%2		; number of bytes	
	mov edx,%3		; buffer
	int 80h			; call kernel
%endmacro
	
section .data	
filename	db 'nummers.txt' ; just use lenth of string
filename_len	equ $-filename	 ; here we use a constant
STDOUT		equ	1	 ; stdout
	
section .bss	
number_of_ent resb 4		; reverse 4bytes.
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
	mov ecx,number_of_ent	; location for storing our first 4 bytes
	mov edx,4		; read 4 bytes
	int 80h			; call the kernel
	push dword [number_of_ent]
	call print_byte
	call ret		; lets go home

ret:	
	mov eax,1
	mov ebx,1
	int 80h
print_byte:
	push ebp
	mov ebp,esp
	mov eax,[ebp+8]		; byte to print
	mov dword [buf],eax
	mov eax,4
	mov ebx,1
	mov ecx,buf
	mov edx,1
	int 80h
	
	mov esp,ebp
	pop ebp
	ret
	
	


	