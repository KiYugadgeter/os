default:
	make img

run: haribote.img
	make img
	qemu-system-i386 -fda $^

ipl10.bin: ipl10.asm
	nasm -o $@ $^ -l ipl10.lst

asmhead.bin: asmhead.asm
	nasm -o $@ $^ -l haribote.lst

nasmfunc.o: nasmfunc.asm
	nasm -f elf32 -o nasmfunc.o nasmfunc.asm
	
bootpack.o: bootpack.c Makefile
	gcc -c -m32 -fno-pic -o bootpack.o bootpack.c
	
bootpack.bin: bootpack.o nasmfunc.o
	ld -m elf_i386 -e HariMain -o bootpack.bin -T os.ld bootpack.o nasmfunc.o 

haribote.sys: asmhead.bin bootpack.bin
	cat asmhead.bin bootpack.bin > haribote.sys

haribote.img: ipl10.bin haribote.sys
	mformat -f 1440 -C -B ipl10.bin -i haribote.img ::
	mcopy haribote.sys -i haribote.img ::

asm:
	make -r ipl10.bin

img:
	make -r haribote.img
