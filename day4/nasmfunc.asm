bits 32


section .text
global io_hlt
global io_cli
global io_out8
global io_store_eflags
global io_load_eflags

io_hlt:
	hlt
	ret

io_cli: ; void io_cli();
	cli
	ret
	
io_sti: ; void io_sti();
	sti
	ret
	
io_stihlt: ; void io_stihlt();
	sti
	hlt
	ret
	
io_in8: ; int io_in8(int port);
	mov	edx,[esp+4]
	mov	eax,0
	in	al,dx
	ret

io_in16: ; int io_int16(int port);
	mov	edx,[esp+4]
	mov eax,0
	in	ax,dx
	ret
	

io_in32: ; int io_int32(int port);
	mov	edx,[esp+4]
	mov eax,0
	in	eax,dx
	ret

io_out8: ; int io_out8(int port, int data);
	mov	edx,[esp+4]
	mov	al,[esp+8]; data
	out	dx,al
	ret

io_out16: ; int io_out16(int port, int data);
	mov	edx,[esp+4]
	mov	eax,[esp+8]; data
	out	dx,ax
	ret

io_out32: ; int io_out32(int port, int data);
	mov	edx,[esp+4]
	mov	eax,[esp+8]; data
	out	dx,eax
	ret
	
io_load_eflags:	;int io_load_eflags();
	pushfd
	pop	eax
	ret

io_store_eflags:	;int io_store_eflags(int eflags);
	mov	eax,[esp+4]
	push	eax
	popfd
	ret
