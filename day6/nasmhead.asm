; haribote-os boot asm
; TAB=4

botpak	equ		0X00280000		; BOOTPACKのロード先
dskcac	equ		0X00100000		; ディスクキャッシュの場所
dskcac0	equ		0X00008000		; ディスクキャッシュの場所（リアルモード）

; boot_info関係
cyls	equ		0X0FF0			; ブートセクタが設定する
leds	equ		0X0FF1
vmode	equ		0X0FF2			; 色数に関する情報。何ビットカラーか？
scrnx	equ		0X0FF4			; 解像度のx
scrny	equ		0X0FF6			; 解像度のy
vram	equ		0X0FF8			; グラフィックバッファの開始番地

		org		0XC200			; このプログラムがどこに読み込まれるのか

; 画面モードを設定

		mov		al,0X13			; vgaグラフィックス、320X200X8BITカラー
		mov		ah,0X00
		int		0X10
		mov		byte [vmode],8	; 画面モードをメモする（c言語が参照する）
		mov		word [scrnx],320
		mov		word [scrny],200
		mov		dword [vram],0X000A0000

; キーボードのled状態をbiosに教えてもらう

		mov		ah,0X02
		int		0X16 			; KEYBOARD bios
		mov		[leds],al

; picが一切の割り込みを受け付けないようにする
;	at互換機の仕様では、picの初期化をするなら、
;	こいつをcli前にやっておかないと、たまにハングアップする
;	picの初期化はあとでやる

		mov		al,0XFF
		out		0X21,al
		nop						; out命令を連続させるとうまくいかない機種があるらしいので
		out		0XA1,al

		cli						; さらにcpuレベルでも割り込み禁止

; cpuから1mb以上のメモリにアクセスできるように、a20gateを設定

		call	WAITKBDOUT
		mov		al,0XD1
		out		0X64,al
		call	WAITKBDOUT
		mov		al,0XDF			; ENABLE a20
		out		0X60,al
		call	WAITKBDOUT

; プロテクトモード移行

;[instrset "I486P"]				; 486の命令まで使いたいという記述

		lgdt	[gdtr0]			; 暫定gdtを設定
		mov		eax,cr0
		and		eax,0X7FFFFFFF	; BIT31を0にする（ページング禁止のため）
		or		eax,0X00000001	; BIT0を1にする（プロテクトモード移行のため）
		mov		cr0,eax
		jmp		PIPELINEFLUSH
PIPELINEFLUSH:
		mov		ax,1*8			;  読み書き可能セグメント32BIT
		mov		ds,ax
		mov		es,ax
		mov		fs,ax
		mov		gs,ax
		mov		ss,ax

; BOOTPACKの転送

		mov		esi,BOOTPACK	; 転送元
		mov		edi,botpak		; 転送先
		mov		ecx,512*1024/4
		call	MEMCPY

; ついでにディスクデータも本来の位置へ転送

; まずはブートセクタから

		mov		esi,0X7C00		; 転送元
		mov		edi,dskcac		; 転送先
		mov		ecx,512/4
		call	MEMCPY

; 残り全部

		mov		esi,dskcac0+512	; 転送元
		mov		edi,dskcac+512	; 転送先
		mov		ecx,0
		mov		cl,byte [cyls]
		imul	ecx,512*18*2/4	; シリンダ数からバイト数/4に変換
		sub		ecx,512/4		; iplの分だけ差し引く
		call	MEMCPY

; ASMHEADでしなければいけないことは全部し終わったので、
;	あとはBOOTPACKに任せる

; BOOTPACKの起動

		mov		ebx,botpak
		mov		ecx,[ebx+16]
		add		ecx,3			; ecx += 3;
		shr		ecx,2			; ecx /= 4;
		jz		SKIP			; 転送するべきものがない
		mov		esi,[ebx+20]	; 転送元
		add		esi,ebx
		mov		edi,[ebx+12]	; 転送先
		call	MEMCPY
SKIP:
		mov		esp,[ebx+12]	; スタック初期値
		jmp		dword 2*8:0X0000001B

WAITKBDOUT:
		in		 al,0X64
		and		 al,0X02
		jnz		WAITKBDOUT		; andの結果が0でなければWAITKBDOUTへ
		ret

MEMCPY:
		mov		eax,[esi]
		add		esi,4
		mov		[edi],eax
		add		edi,4
		sub		ecx,1
		jnz		MEMCPY			; 引き算した結果が0でなければMEMCPYへ
		ret
; MEMCPYはアドレスサイズプリフィクスを入れ忘れなければ、ストリング命令でも書ける

		align	16
		db	0
gdt0:
		times	8 db	0				; ヌルセレクタ
		dw		0XFFFF,0X0000,0X9200,0X00CF	; 読み書き可能セグメント32BIT
		dw		0XFFFF,0X0000,0X9A28,0X0047	; 実行可能セグメント32BIT（BOOTPACK用）

		dw		0
gdtr0:
		dw		8*3-1
		dd		gdt0

		align	16
		db	0
BOOTPACK:
