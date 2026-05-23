section .multiboot
align 4

mb_header_start:
    dd 0x1BADB002                 ; multiboot magic
    dd 0x0                        ; flags
    dd -(0x1BADB002 + 0x0)       ; checksum
mb_header_end:

section .bss
align 16

stack_bottom:
    resb 16384
stack_top:

section .text
global _start

extern kernel_main
extern __bss_start
extern __bss_end

_start:
    cli

    ; setup 32-bit stack
    mov esp, stack_top

    ; clear .bss
    mov edi, __bss_start
    mov ecx, __bss_end

    sub ecx, edi

    xor eax, eax

    rep stosb

    ; call kernel
    call kernel_main

.hang:
    hlt
    jmp .hang
