section .bss

    array: resd 100

section .data
    rmsg db "Right answer.", 0xa
    wmsg db "Wrong answer.", 0xa
    len equ $ - wmsg

section .text
global _start

_start:

    fill:
    lea rdi, [array]
    lea rsi, [400]
    lea rdx, [1]
    lea rax, [318]
    syscall

    mov rax, rdi
    lea rdx, [100]
    
    loop:
        test rdx, rdx
        jz test

        xor rdi, rdi
        bubble:
            cmp rdi, rdx
            jge continue

            mov rcx, [rax+rdi*4]
            mov rsi, [rax+rdi*4+4]
            cmp rcx, rsi
            jle noswap

            swap:
            mov [rax+rdi*4+4], rcx
            mov [rax+rdi*4], rsi

            noswap:
            inc rdi
            jmp bubble

        continue:
        dec rdx
        jmp loop

    test: ; test if right
        lea rdi, [0]

        test_loop:
            cmp rdi, 100
            jge right
            mov rcx, [rax+rdi*4]
            cmp rcx, [rax+rdi*4+4]
            jg wrong
            inc rdi
            jmp test_loop

    wrong:
    mov rdx, len
    mov rsi, wmsg
    lea rdi, [1]
    lea rax, [1]
    syscall
    jmp exit

    right:
    mov rdx, len
    mov rsi, rmsg
    lea rdi, [1]
    lea rax, [1]
    syscall
    
    exit:

    xor rdi, rdi
    lea rax, [60]
    syscall
    
