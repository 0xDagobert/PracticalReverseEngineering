# Exercise

This function uses a combination SCAS and STOS to do its work. First, explain what is the type of the ``[EPB+8]`` and ``[EPB+C]`` in line 1 and 8, respectively. Next, explain what this snippet does.

## Snippet


```asm
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
```

## Context and basic Explanation 

We see line 1 ``mov edi, [EPB+8]`` and line 8 ``mov al, [EPB+C]``

As a remainder EBP is the 32 bit register containing the base pointer for the current stack frame

Line 1 is telling us to move data from the base of the stack +8 into a dword register (edi)
Line 8 is telling us to move data from the base of the stack +C into a byte register (al)

``[EPB+8]`` is gonna be the first argument of the function and ``[EPB+C]`` the second one

Now that we know that we can add a prologue where we are gonna initialize 2 variables, a dword and a byte, that are gonna be called by the snippet above.

## Setup the code

First thing to do will be to make the code run-able, to do that we need a prologue.

```asm
    SECTION .data

    string:
        db 'Learning how to reverse', 0

    SECTION .text

    GLOBAL _start

    _start:
        nop
        push byte '2'       ;pushing second arg on stack
        push dword string   ;pushing first arg on stack
```

We then add the code of the function adding thing to it

```asm
tbd:
    push ebp        ;saving base pointer
    mov ebp, esp    ;base pointer -> ESP

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

    mov esp, ebp    ;restoring stack pointer
    pop ebp         ;restoring stack base pointer
    ret
```

We then call in the prologue the "tbd" function and add a syscall

```asm
_start:
    nop
    push byte '2'
    push dword string
    call tbd    
    add esp, 8  ;clean stack
    mov ebx, 0  ;ret value for syscall
    mov eax, 1  ;exit syscall
    int 080h    ;syscall
```

We now have a functionnal and run-able snippet, let's see what he does

## Running the snippet

I will use Miasm to run the code, we will focus on checking the value and state of register.

Once compiled with nasm


