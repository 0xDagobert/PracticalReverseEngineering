SECTION .data

string:
    db 'Learning how to reverse', 0

SECTION .text

GLOBAL _start

_start:
    nop
    push byte '2'
    push dword string
    call tbd
    add esp, 8
    mov ebx, 0
    mov eax, 1
    int 080h

tbd:
    push ebp
    mov ebp, esp

    mov edi, [ebp+8]
    mov edx, edi
    xor eax, eax
    or ecx, 0FFFFFFFFh
    repne scasb
    add ecx, 2
    neg ecx
    mov al, [ebp+0Ch]
    mov edi, edx
    rep stosb
    mov eax, edx
    mov esp, ebp
    pop ebp
    ret
