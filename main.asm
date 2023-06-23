; Legacy booting
; BIOS loads first sector of each bootable device
; into memory (at location 0x7c00)
; BIOS checks for 0xaa55 signature
; If found, it starts executing code

; ORG (directive)
; Tells assembler where we expect our code to be loaded.
; The assembler uses this information to calculate label addresses.
org 0x7C00
bits 16     ; bits directive, tells assembler to emit 16/32/64-bit code

main:
  hlt       ; halt the CPU. Can be started again via interrupts

.halt:
  jmp .halt ; jump unconditionally to a location

; db define byte
; times repeats instruction n times
; '$' special symbol which is equal to the memory offset of the current line
; '$$' special symbol which is equal to the memory offset of the beginning of the current section (in this case, program)
; $-$$ gives the length of the current program so far, in bytes

times 510-($-$$) db 0
dw 0AA55H   ; define word(s) (2 bytes) encoded in little endian

