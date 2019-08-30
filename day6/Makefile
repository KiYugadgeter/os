default:
	make img

run: haribote.img
	make img
	qemu-system-i386 -fda $^

ipl10.bin: ipl10.asm
	nasm -o $@ $^ -l ipl10.lst

nasmhead.bin: nasmhead.asm
	nasm -o $@ $^ -l haribote.lst

nasmfunc.o: nasmfunc.asm
	nasm -f elf32 -o nasmfunc.o nasmfunc.asm
	
bootpack.o: bootpack.c Makefile
	gcc -c -m32 -fno-pic -o bootpack.o bootpack.c

font2byte: font2byte.c
	gcc -o font2byte font2byte.c
	
hankaku.c: font2byte hankaku.txt
	./font2byte
	
hankaku.o: font2byte hankaku.c hankaku.txt
	gcc -c -fno-pic -m32 -nostdlib -o hankaku.o hankaku.c

mysprintf.o: mysprintf.c
	gcc -fno-pic -fno-stack-protector -nostdlib -c -m32 -o mysprintf.o mysprintf.c

%.o: %.c
	gcc -c -fno-pic -m32 -nostdlib -o $*.o $*.c

bootpack.bin: bootpack.o nasmfunc.o hankaku.o mysprintf.o graphic.o dsctbl.o int.o
	ld -m elf_i386 -e HariMain -o bootpack.bin -Tos.ld bootpack.o nasmfunc.o hankaku.o mysprintf.o graphic.o dsctbl.o int.o

haribote.sys: nasmhead.bin bootpack.bin
	cat nasmhead.bin bootpack.bin > haribote.sys

haribote.img: ipl10.bin haribote.sys
	mformat -f 1440 -C -B ipl10.bin -i haribote.img ::
	mcopy haribote.sys -i haribote.img ::


asm:
	make -r ipl10.bin

img:
	make -r haribote.img

.PHONY: clean
clean:
	rm -rf *.o *.bin *.img *.sys font2byte hankaku.c mysprintf.o
