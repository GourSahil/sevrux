section .multiboot
align 8

mb_header_start:
    dd 0xe85250d6
    dd 0
    dd mb_header_end - mb_header_start
    dd -(0xe85250d6 + 0 + (mb_header_end - mb_header_start))

    dw 0
    dw 0
    dd 8

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

    ; setup 64-bit stack
    mov rsp, stack_top

    ; zero .bss section
    mov rdi, __bss_start
    mov rcx, __bss_end

    sub rcx, rdi

    xor rax, rax

    rep stosb

    ; call kernel
    call kernel_main

.hang:
    hlt
    jmp .hang
