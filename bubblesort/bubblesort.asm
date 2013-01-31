%include "macro/macro.mac"
%include "functions/generic_functions.asm"	
section .data	
	filename	db 	'nummers.txt',0 	; just use lenth of string
	newline		db  	12			; newline
	filename_len	equ 	$-filename	   	; here we use a constant
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
	mov eax,[buffer]
	mov [nel],eax
	push ebx		; save file descr
	
	mov eax,45		; syscall 45
	mov ebx,0		; argument
	int 80h			; call kernel

	mov dword [begin_heap],eax ; end of heap to [begin_of_heap]
	push eax		   ; save eax
	mov eax,4
	mul dword [buffer]	   ; number of bytes we need on the heap
	mov [buffer],eax
	pop eax
	add eax,[buffer]
	mov ebx,eax
	mov eax,45
	int 80h

	pop ebx			; get back our file descriptor
	push eax		; save heap breakpoint

	mov eax,3		; syscall read
	mov ecx,[begin_heap]    ; upper bound of our heap
	mov edx,[buffer]	; number of bytes we should read
	int 80h			; 	

	mov ecx,[nel]		; first counter
	mov esi,[begin_heap]

.loop1:

	dec ecx
	cmp ecx,0
	jl .end
	mov edx,0		; init second counter in loop
.loop2:

	push ecx
	mov ecx,[edx*4+esi]
	push ecx
	mov eax,[((edx+1)*4)+esi]
	cmp eax,[esp]
	jg .n_switch
	sw [edx*4+esi],[((edx+1)*4)+esi]

.n_switch:
	add esp,4
	pop ecx
	cmp ecx,edx
	je .loop1
	inc edx
	jmp .loop2
.end:
	xor eax,eax
	push buffer
	push dword [esi]
	call printint2
	write buffer,4
	write newline,1
.l1:
	inc eax
	mov dword [buffer],0 	; clear out buffer
	pushad
	push buffer
	push dword [eax*4+esi]
	call printint2
	popad
	write buffer,4		; 4 byte for int
	write newline, 1
	cmp eax,[nel]
	jl .l1
	

	call ret		; lets go home.

ret:
	mov eax,1
	mov ebx,1
	int 80h

