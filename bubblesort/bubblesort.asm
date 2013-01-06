%include "macro/macro.mac"
section .data	
	filename	db 	'nummers.txt',0 	; just use lenth of string
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
	push 33
	mov eax,dword [esp]
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
	mov eax,[esi]		; save integer to eax
	xor ecx,ecx		; clear out ecx
	mov esi,eax
	;; count number of digiste required

	push eax		; save integer
	mov ebx,10		;
.c:
	inc ecx
	xor edx,edx
	div ebx
	cmp eax,0
	jnz .c

	mov eax,buffer		; move buffer to eax
	add eax,ecx		; add offset to buffer
	mov ebx,eax
	mov byte [ebx],0
	
.a:
	dec ebx			; decrement pointer
	mov eax,dword [esp]
	pop eax			; bring back our integer
	xor edx,edx		; clear out edx
	mov ecx,10		; move 10 to ecx
	div ecx			; div
	xchg eax,edx		; eax is now remainer
	
	add eax,48
	mov byte [ebx],al
	xchg eax,edx
	mov eax,dword [esp]
	sub eax,0
	jnz .a
		
	write buffer,4
	call ret		; lets go home.

ret:
	mov eax,1
	mov ebx,1
	int 80h

