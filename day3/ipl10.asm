cyls	equ 10
org	0x7c00

jmp	entry
db	0x90;
db	"HARIBOTE";
dw	512;
db	1;
dw	1;
db	2;
dw	224;
dw	2880;
db	0xf0
dw	9
dw	18
dw	2
dd 0
dd 2880
db 0,0,0x29
dd	0xffffffff
db	"HARIBOTEOS "
db	"FAT12   "
times	18	db	0

; プログラム本体

entry:
	mov	ax,0
	mov	ss,ax
	mov	sp,0x7c00
	mov	ds,ax
	
	;mov	si,msg

;ディスクを読む
mov	ax,0x0820
mov	es,ax
mov	ch,0 ;シリンダ0
mov	dh,0 ;ヘッド0
mov	cl,2 ;セクタ2

readloop:
	mov	si,0 ;失敗回数を数えるレジスタを0にする

retry:
	mov	ah,0x02 ;AH=0x02 : ディスク読み込み
	mov	al,1 ;1セクタ
	mov	bx,0 ;
	mov	dl,0x00 ;Aドライブ
	int	0x13 ;ディスクbios呼び出し
	jnc	next
	add	si,1
	cmp	si,5
	jae	error
	mov	ah,0 ;システムのリセット(0x13ディスク関係内)
	mov	dl,0x00
	int	0x13
	jmp	retry

next:
	mov	ax,es
	add ax,0x0020
	mov es,ax
	add cl,1
	cmp cl,18
	jbe readloop
	mov	cl,1
	add	dh,1
	cmp	dh,2
	jb	readloop
	mov	dh,0
	add	ch,1
	cmp	ch,cyls
	jb	readloop
	
	mov	[0x0ff0],ch
	jmp	0xc200

	
	
fin:
	hlt
	jmp	fin
	
error:
	mov	si,msg

putloop:
	mov al,[si]
	add si,1
	cmp al,0
	je	fin
	mov	ah,0x0e
	mov bx,15
	int	0x10
	jmp	putloop


msg:
	db	0x0a,0x0a
	db	"Load Error"
	db	0x0a
	db	0
	times	0x7dfe-0x7c00-($-$$)	db	0
	db 0x55,0xaa

;以下はブートセクタ以外の部分の記述
;db	0xf0,0xff,0xff,0x00,0x00,0x00,0x00,0x00
;times 4600 db 0
;db 0xf0,0xff,0xff,0x00,0x00,0x00,0x00,0x00
;times 1469432 db 0


