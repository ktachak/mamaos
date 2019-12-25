# OS Development Notes

## x86 BIOS Interrupts

### INT 0x19

Search for a bootable disk.

### INT 0x13

Disk access. AH register is used to choose the function. Returns status code in AH and success flag in CF (cleared on success). The list of functions is given as:

- AH = 0x0 :: Reset disk system. Immediately go to the first sector on disk.
- AH = 0x02 :: Read sectors into memory. AL contains number of sectors to read. CH contains low eight bits of cylinder number. CL sector number (bits 0-5). Bits 6-7 are for hard disks only. DH head number. DL drive number (bit 7 set for hard disks). ES:BX is for buffer to read sectors to.

## Bootloader (First Stage)

- Are stored with the Master Boot Record (MBR).
- Are in the first sector of the disk.
- Is the size of a single sector (512) bytes.
- Are loaded by the BIOS INT 0x19 at address 0x7C00.

### Boot Signature

The BIOS INT 0x19 searches for a bootable disk. If the 511 byte is 0xAA and the 512 byte is 0x55, in a boot sector, INT 0x19 will load and execute the bootloader.

## Processor Modes

### Real Mode

- Uses the native segment:offset memory model.
- Is limited to 1MB (+64k) of memory.
- No virtual memory or memory protection.

### Protected Mode

- 32 bit processor mode.
- Allows memory protection through the use of Descriptor Tables that describe the memory layout.
- 32 bit registers and up to 4 GB of RAM.
