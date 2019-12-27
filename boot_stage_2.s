org 0x0     ; offset to 0, we will set segments later
bits 16     ; we are still in real mode

start:   
    jmp     main    ; Jump to main

;***************************************
;	Prints a string
;	DS=>SI: 0 terminated string
;***************************************

print:
	lodsb				; load next byte from string from SI to AL
	or		al, al		; Does AL=0?
	jz		printdone   ; Yep, null terminator found-bail out
	mov		ah,	0eh	    ; Nope-Print the character
	int		10h
	jmp		print       ; Repeat until null terminator found
printdone:
	ret				    ; we are done, so return

;*************************************************;
;	Second Stage Loader Entry Point
;*************************************************;

main:
    cli                 ; clear interrupts
    push    cs          ; Insure DS=CS
    pop     ds

    mov     si, MSG
    call    print

	cli							; Clear all Interrupts
	hlt			

;************************************************
;   Data Section
;************************************************

MSG     db      "Preparing to load operating system...",13,10,0