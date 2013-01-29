printint2:
	enter 4, 0 
	pusha 
	mov eax, dword [ebp+12] 
	mov ebx, eax 
	mov byte [ebx], 45; ASCII code for '-'
	
	xor eax, eax 
	mov esi, eax 

	;; check for > 0
	mov eax, dword [ebp+8] 
	sub eax, 0 
	jnl .over1 
	;; If the integer is negative, we would need to increment the number. 
	inc esi
	;; Also, we make sure the number we're dealing with is positive. 	
	neg eax				   		

	.over1:
	
	;; We save the integer to [ebp-4] 
	mov dword [ebp-4], eax
	
	;; Count the number of digits required for the string.
	
	mov eax, dword [ebp-4] 	; EAX= the integer 
	xor ecx, ecx		; ECX= 0 
	mov ebx, 10		; EBX= 10 

	.l1: 
		inc ecx		; ECX= ECX + 1 
		xor edx, edx	; EDX= 0 
		div ebx		; EAX= EAX / EBX = EAX / 10 
		cmp eax, 0	; If not 0 yet, 
		jnz .l1	; continue loop. 

	

	add ecx, esi		; 1 if n is 0 else 1

	mov eax, dword [ebp+12] 
	add eax, ecx		; Add offset
	
	mov ebx, eax		; We will NULL terminate it
	
	;; NULL terminate
	mov byte [ebx], 0 
	
	
	.l2: 
		dec ebx		; Decrement pointer
		mov eax, dword [ebp-4] 
		xor edx, edx 
		mov ecx, 10 
		div ecx		; Devide int
	
		xchg eax, edx	; backup
		add eax, 48 	; eax is our remainder.
		mov byte [ebx], al ; set to remainder + 48
		xchg eax, edx	   ; return our backup
	
		mov dword [ebp-4], eax		
		sub eax, 0 
		jnz .l2	; if not 0, we continue with the loop
	.l2s: 
	popa 
	leave 
	
	ret 8 