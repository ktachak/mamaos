;**************************************************
;   boot.asm
;           - A simple bootloader
;   Operating Systems Development Tutorial
;**************************************************

org     0x7C00                          ; Loaded by BIOS at 0x7C00
bits    16                              ; 16 bit Real Mode

start:
        cli                             ; Clear all interrupts
        hlt                             ; Halt the system
times   510 - ($-$$) db 0               ; Pad to fill 512 bytes.
dw      0xAA55                          ; Boot signature