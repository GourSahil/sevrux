section .multiboot
align 8

mb_header_start:
    dd 0xe85250d6                ; magic
    dd 0                         ; architecture
    dd mb_header_end - mb_header_start
    dd -(0xe85250d6 + 0 + (mb_header_end - mb_header_start))

    dw 0
    dw 0
    dd 8

mb_header_end:

section .text
global _start
extern kernel_main

_start:
    cli
    call kernel_main

.hang:
    hlt
    jmp .hang
