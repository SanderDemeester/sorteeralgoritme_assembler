	.intel_syntax noprefix
	.text
	.globl main
	
sorteer:
	push ebp
	mov ebp,esp
	add esp,8
	pop eax			; lengte
	xor ebx,ebx		; index of current max
	mov ecx,eax		; loop counter1
	mov edx,1		; loop counter2
.startloop1:
	cmp ecx,0
	je .done
.startloop2:
.done:
	sub esp,8
	leave
	ret
.print_char:
	push ebp
	mov ebp,esp
	
main:
	push 3
	push 1
	push 2
	push 3			; het aantal
	call sorteer
	add esp,16
	mov eax,1
	mov ebx,0
	int 80h
	