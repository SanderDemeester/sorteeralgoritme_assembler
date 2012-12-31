%macro write 2
	mov eax,4		; write syscall
	mov ebx,STDOUT		; stdout
	mov edx,%2		; number of bytes
	mov ecx,%1		; buffer
	int 80h			; call kernel
%endmacro

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
	mov ecx,[begin_heap]		; upper bound of our heap
	mov edx,[buffer]	; number of bytes we should read
	int 80h			; 	


	xor ecx,ecx		; first counter
	xor edx,edx		; second counter

.loop1:

	inc ecx
.loop2:	
	cmp [nel],ecx
	jne .loop1
	
xo	write buffer,4
	call ret		; lets go home.

ret:
	mov eax,1
	mov ebx,1
	int 80h

	
	


	