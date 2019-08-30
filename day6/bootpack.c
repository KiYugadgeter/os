#include <stdarg.h>
#include "bootpack.h"
void HariMain() {
    struct BOOTINFO *binfo;
    char s[40];

    init_gdtidt();
    init_pic();
    io_sti();
    init_palette();
    binfo = (struct BOOTINFO*) ADR_BOOTINFO; 
    init_screen8(binfo->vram, binfo->scrnx, binfo->scrny);
    mysprintf(s, "scrnx = %d", binfo->scrnx);
    putfonts8_asc(binfo->vram, binfo->scrnx, 16, 64, COL8_FFFFFF, s);
    char mcursor[16][16];
    int mx, my;
    mx = (binfo->scrnx - 16) / 2;
    my = (binfo->scrny - 28 - 16) / 2;
    init_mouse_cursor8(mcursor, COL8_008484);
    putblock8_8(binfo->vram, binfo->scrnx, 16, 16, mx, my, mcursor, 16);
    mysprintf(s, "(%d, %d)", mx, my);
    putfonts8_asc(binfo->vram, binfo->scrnx, 0, 0, COL8_FFFFFF, s);
    
    io_out8(PIC0_IMR, 0xf9);
    io_out8(PIC1_IMR, 0xef);
    for (;;) {
        io_hlt();
    }
}
    
