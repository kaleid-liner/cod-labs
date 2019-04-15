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
    lea edx, [100]
    
    loop:
        test edx, edx
        jz test

        xor edi, edi
        bubble:
            cmp edi, edx
            jge continue

            mov ecx, [rax+rdi*4]
            mov esi, [rax+rdi*4+4]
            cmp ecx, esi
            jle noswap

            swap:
            mov [rax+rdi*4+4], ecx
            mov [rax+rdi*4], esi

            noswap:
            inc edi
            jmp bubble

        continue:
        dec edx
        jmp loop

    test: ; test if right
        lea edi, [0]

        test_loop:
            cmp edi, 100
            jge right
            mov ecx, [rax+rdi*4]
            cmp ecx, [rax+rdi*4+4]
            jg wrong
            inc edi
            jmp test_loop

    wrong:
    mov edx, len
    mov rsi, wmsg
    lea rdi, [1]
    lea rax, [1]
    syscall
    jmp exit

    right:
    mov edx, len
    mov rsi, rmsg
    lea rdi, [1]
    lea rax, [1]
    syscall
    
    exit:

    xor rdi, rdi
    lea rax, [60]
    syscall
    
