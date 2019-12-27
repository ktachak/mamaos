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

BPB_OEM                         db "MAMA OS "
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
BS_VOLUME_LABEL:                db "MOS FLOPPY "
BS_FILE_SYSTEM:                 db "FAT12   "

msg     db      "Welcome to My Operating System!", 0

;*************************************************
;       Prints a string
;       DS=>SI: 0 terminated string
;*************************************************

print:
        lodsb                   ; load next byte from string pointed by SI to AL
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

;*************************************************
;       Reset the head to the start sector of a disk
;***************************************************

.reset:
        mov     ah, 0           ; reset floppy disk function
        mov     dl, 0           ; drive 0 is floppy drive
        int     0x13            ; call BIOS
        jc      .reset          ; if carry flag (CF) is set, there was an error. Try resetting again.

        mov     ax, 0x1000      ; we are going to read sector into address 0x1000:0
        mov     es, ax
        xor     bx, bx

.read:
        mov     ah, 0x02        ; function 2
        mov     al, 1           ; read 1 sector
        mov     ch, 1           ; we are reading the second sector past us, so its still on track 1
        mov     cl, 2           ; sector to read (The second sector)
        mov     dh, 0           ; head number
        mov     dl, 0           ; drive number. Remember Drive 0 is floppy drive.
        int     0x13            ; call BIOS - Read the sector
        jc      .read           ; try again on error

        jmp     0x1000:0x0      ; jump to execute the sector!

times   510 - ($-$$) db 0               ; Pad to fill 512 bytes.
dw      0xAA55                          ; Boot signature