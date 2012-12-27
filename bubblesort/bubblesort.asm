section .data	
filename	db 'nummers.txt' ; just use lenth of string
filename_len	equ $-filename	 ; here we use a constant
	
section .bss	
number_of_ent resb 4		; reverse 4bytes
	
section .text
	global _start	
_start:
	mov eax,42		
	mov dword [number_of_ent],eax
	mov eax,1
	mov ebx,[number_of_ent]
	int 80h
	


	