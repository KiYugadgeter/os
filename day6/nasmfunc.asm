bits 32


section .text
global io_hlt
global io_cli
global io_sti
global io_out8
global io_store_eflags
global io_load_eflags
global load_gdtr
global load_idtr
global asm_inthandler21
global asm_inthandler2c

extern	inthandler21
extern	inthandler2c


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

load_gdtr:
	mov	ax,[esp+4] ; limit
	mov	[esp+6],AX
	lgdt	[esp+6]
	ret

load_idtr:
	mov	ax,[esp+4] ; limit
	mov	[esp+6],ax
	lidt	[esp+6]
	ret

asm_inthandler21:
	push es
	push ds
	pushad
	mov	eax,esp
	push	eax
	mov	ax,ss
	mov	ds,ax
	mov	es,ax
	call	inthandler21
	pop	eax
	popad
	pop	ds
	pop es
	iretd

asm_inthandler2c:
	push es
	push ds
	pushad
	mov	eax,esp
	push	eax
	mov	ax,ss
	mov	ds,ax
	mov	es,ax
	call	inthandler2c
	pop	eax
	popad
	pop	ds
	pop es
	iretd
