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

%define ENDL 0x0D, 0x0A

start:
  jmp main

; Prints a string to the screen
; Params:
;   - ds:si points to string
puts:
  ; save registers we will modify
  push si
  push ax

.loop:
  lodsb        ; loads next character in al
  or al, al     ; verify if next character is null?
  jz .done

  mov ah, 0x0e	; call bios video interrupt
  int 0x10

  jmp .loop

.done:
  pop ax
  pop si
  ret

main:
  ; setup data segments
  mov ax, 0		; can't write to ds/es directly
  mov ds, ax
  mov es, ax

  ; setup stack
  mov ss, ax
  mov sp, 0x7C00	; stack grows downwards from where we are loaded in memory

  ; print message
  mov si, msg_hello
  call puts

  hlt       ; halt the CPU. Can be started again via interrupts

.halt:
  jmp .halt ; jump unconditionally to a location

msg_hello: db 'mittOS v0.1', ENDL, 0

; db define byte
; times repeats instruction n times
; '$' special symbol which is equal to the memory offset of the current line
; '$$' special symbol which is equal to the memory offset of the beginning of the current section (in this case, program)
; $-$$ gives the length of the current program so far, in bytes

times 510-($-$$) db 0
dw 0AA55H   ; define word(s) (2 bytes) encoded in little endian

