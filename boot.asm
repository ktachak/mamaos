;**************************************************
;   boot.asm
;           - A simple bootloader
;   Operating Systems Development Tutorial
;**************************************************

bits    16                              ; 16 bit Real Mode

org     0x7C00                          ; Loaded by BIOS at 0x7C00

start:  jmp loader                      ; Jump over OEM block

;**************************************************
;       OEM Parameter block
;**************************************************

times   0Bh-$+start db 0

BPB_BYTES_PER_SECTOR:           dw 512
BPB_SECTORS_PER_CLUSTER:        db 1
BPB_RESERVED_SECTORS:           dw 1
BPB_NUMBER_OF_FATS:             db 2
BPB_ROOT_ENTRIES:               dw 224
BPB_TOTAL_SECTORS:              dw 2880
BPB_MEDIA:                      db 9
BPB_SECTORS_PER_FAT:            dw 9
BPB_SECTORS_PER_TRACK:          dw 18
BPB_HEADS_PER_CYLINDER:         dw 2
BPB_HIDDEN_SECTORS:             dd 0
BPB_TOTAL_SECTORS_BIG:          dd 0
BS_DRIVE_NUMBER:                db 0
BS_UNUSED:                      db 0
BS_EXT_BOOT_SIG:                db 0x29
BS_SERIAL_NO:                   dd 0xa0a1a2a3
BS_VOLUME_LABEL:                db "MOS FLOPPY"
BS_FILE_SYSTEM:                 db "FAT12   "

msg     db      "Welcome to My Operating System!", 0

;*************************************************
;       Prints a string
;       DS=>SI: 0 terminated string
;*************************************************

print:
        lodsb
        or      al, al          ; al = current character
        jz      printdone       ; null terminator found
        mov     ah, 0eh         ; get next character
        int     10h
        jmp     print
printdone:
        ret

;*************************************************
;       Bootloader Entry Point
;*************************************************

loader:
        xor     ax, ax          ; Setup segments to insure they are 0.
        mov     ds, ax
        mov     es, ax

        mov     si, msg
        call    print
        
        cli                             ; Clear all interrupts
        hlt                             ; Halt the system

times   510 - ($-$$) db 0               ; Pad to fill 512 bytes.
dw      0xAA55                          ; Boot signature