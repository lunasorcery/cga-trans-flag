org 100h
start:
		mov  al,4h
		int  10h
		push word 0xB800
		pop  es
mainloop:
		cwd
		mov ax,di
		and ax,0x1fff
		mov bx,1600
		div bx
		mov cl,al
		shl cl,1
		mov al,0x64
		shr al,cl
		and al,3
		inc al
		mov bx,0x55
		mul bx
		stosb
		in  al,60h
		dec al
		jnz mainloop
		mov al,03
		int 10h
		ret