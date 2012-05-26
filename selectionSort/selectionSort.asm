section .data
newline:	db '',10
newlineLen	equ $-newline

	section .text
	global _start
_start:
	pop ecx
	jmp print_arv
print_arv:
	pop ecx
	test ecx,ecx
	jz exit
	push ecx
	call echol
	pop ecx
	jmp print_arv
echol:
	push ebp
	mov ebp,esp
	mov ecx,[ebp+8]
	push ecx
	call strlen
	pop ecx
	mov edx,eax
	mov eax,4
	mov ebx,1
	int 0x80

	mov eax,4
	mov ebx,1
	mov ecx,newline
	mov edx,newlineLen
	int 0x80
	
	pop ebp
	xor eax,eax
	ret
strlen:
	pushall
	;;  stackframe goed zetten
	push ebp
	mov ebp,esp
	;; haal eerste argument van de stack in edi
	mov edi,[ebp+8]

	;;  ecx = 0
	xor ecx,ecx

	;;  flip all bits of ecx
	;;  ecx is now the largest possible integer (when viewed as an unsigned integer)
	not ecx

	;;  al = 0
	xor al,al

	;;  clear directoin flag
	cld

	;; do while [edi+ecx] != al, zoek voor 0 in string
	repne scasb

	;;  flip bits
	;; ecx is nu de lengte van de string + 1 (inc 0)
	not ecx

	;;  
	;; min1 van ecx voor null en zet eax goed voor return value
	lea eax,[ecx-1]

	;;  herstellen stackframe
	pop ebp

	;;  return
	popall
	ret
	
exit:
	;;  eax - exit() syscall
	;;  ebx - 0 (success)
	mov eax,1
	xor ebx,ebx
	int 0x80
	