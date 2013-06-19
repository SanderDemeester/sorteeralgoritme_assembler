section .data
	greater_string	db	'groter',0
	greater_len	equ	$ - greater_string
	
	lower_string	db	'kleiner',0
	lower_len	equ	$ - lower_string
section .text
	global _start
_start:
	mov ebx,10
	cmp ebx,7
	jle .l1
.l2:
	mov edx,lower_len
	mov ecx,lower_string
	mov ebx,1
	mov eax,4
	int 80h
	jmp .end

.l1:
	mov edx,greater_len	; number of bytes
	mov ecx,greater_string	; message
	mov ebx,1
	mov eax,4
	int 80h

.end:
	mov eax,1
	mov ebx,0
	int 80h
	

