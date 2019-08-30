OUTPUT_FORMAT("binary");

SECTIONS {
    .head 0x0 : {
        LONG(64*1024)
        LONG(0x69726148)
        LONG(0)
        LONG(0x310000)
        LONG(SIZEOF(.data))
        LONG(LOADADDR(.data))
        LONG(0xe9000000)
        LONG(HariMain - 0x20)
        LONG(0x01)
    }
    .text : { *(.text) }
    
    .data 0x310000 : AT ( ADDR(.text) + SIZEOF(.text) ) {
        *(.data)
        *(.rodata*)
        *(.bss)
    }
    /DISCARD/ : { *(.eh_frame)}
}
