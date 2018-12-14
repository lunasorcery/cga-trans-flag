org 100h   ; specify this is a .COM file

; note: Mode 4 (320x200 CGA) doesn't use a linear framebuffer layout - it's two interlaced 320x100 buffers. This is important.

start:
		mov  al,4h       ; move 4 into AL - we're about to enter video mode 4 (320x200 CGA)
		int  10h         ; call interrupt 10h - with AH register set to zero, this sets the video mode based on AL
		push word 0xB800 ; I copied this off the sizecoding.org exampes - not really sure what it does but it seemed important :D
		pop  es          ; ES now points to our framebuffer memory

mainloop:
		cwd
		mov ax,di       ; get screen position (row*width+column) into AX
		and ax,0x1fff   ; mask off the top bits of our pixel index so the second interlaced framebuffer gets treated the same as the first
		mov bx,1600     ; put 1600 into BX - this is how many bytes each stripe of the flag takes up in a framebuffer
		div bx          ; divide the pixel coordinate by 1600, so now we know which row our pixel is on, numbered 0,1,2,3,4
		mov cl,al       ; copy the row number to CL
		shl cl,1        ; double the row number (so now 0,2,4,6,8)
		mov al,0x64     ; put 0x64 into AL - this is a clever magic number
		shr al,cl       ; shift that 0x64 down by CL bits (so 0 bits for the first row, 2 bits for the next row, 4 bits for the next and so on)
		and al,3        ; mask to just the bottom two bits
		inc al          ; increment those two bits by 1
		mov bx,0x55     ; put 0x55 into BX
		mul bx          ; multiply our 2-bit number in AL by the 0x55 in BX
		stosb           ; write the contents of AL to the current pixels, and advance the write pointer

		; So what's going on with those magic numbers?

		; Fact 1: The CGA palette maps a 2-bit number to a color.
		; Our four colors in palette 1 are:
		; 00: black
		; 01: cyan
		; 10: magenta
		; 11: white
		; I found that the most elegant way of storing the stripes was packing the 2-bit values together.
		; I wanted to pack it in binary as 01 10 11 10 01, but this would be 10 bits wide and take up a larger register.
		; Since I'm not using black, I could decrement each value by 1, giving me 00 01 10 01 00, which fits nicely in an 8bit register.
		; From there, I perform a right-shift by the row number doubled, which leaves the desired color index in the bottom two bits.

		; Fact 2: The framebuffer layout stores four 2-bit pixels in a single byte.
		; The multiplication by 0x55 is a neat trick to copy those two bits into the other bits of an 8bit register.
		; This is necessary because we're actually handling four pixels at once, due to the framebuffer layout.
		; You'll notice that 0x55 is 01010101 in binary, so you can start to figure out how the multiply trick works from there.

		; copied verbatim from http://www.sizecoding.org/wiki/Getting_Started
		;Check for user wanting to leave by pressing ESC
		in      al,60h          ;read whatever is at keyboard port; looking for ESC which is #1
		dec     al              ;if ESC, AL now 0
		jnz     mainloop        ;fall through if 0, jump otherwise
		mov     al,03           ;AX=0000 due to mainloop exit condition
		int     10h             ;Switch back to text mode as a convenience
		ret                     ;.COM files can exit with RET