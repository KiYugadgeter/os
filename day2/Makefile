run: helloos.img
	make img
	qemu-system-i386 -fda $^

ipl.bin: ipl.asm
	nasm -o $@ $^ -l ipl.lst

helloos.img: ipl.bin
	cat ipl.bin > helloos.img
	
asm:
	make -r ipl.bin

img:
	make -r helloos.img
