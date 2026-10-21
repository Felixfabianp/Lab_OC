
%include "../../lib/pc_io.inc"

section .data
    msg_input db "Ingrese la cadena numerica: ", 0
    msg_atoi  db "atoi -> ", 0
    msg_itoa  db "itoa -> ", 0

section .bss
    string    resb 64
    resultado resb 64
    numero    resd 1

section .text
    global _start

_start:
    mov edx, msg_input
    call puts

    mov edi, string
    mov ecx, 63

capturar:
    push ecx
    push edi
    call getch
    pop edi
    pop ecx

    cmp al, 13
    je fin_captura
    cmp al, 10
    je fin_captura

    cmp al, 8
    je capturar

    push eax
    push ecx
    push edi
    call putchar
    pop edi
    pop ecx
    pop eax

    mov [edi], al
    inc edi
    dec ecx

    cmp ecx, 0
    je fin_captura

    jmp capturar

fin_captura:
    mov byte [edi], 0

    mov al, 10
    call putchar

    mov edx, string
    call atoi
    mov [numero], eax

    mov edx, msg_atoi
    call puts

    mov eax, [numero]
    mov edx, resultado
    mov ecx, 64
    call itoa

    mov edx, resultado
    call puts

    mov al, 10
    call putchar

    mov edx, msg_itoa
    call puts

    mov edx, resultado
    call puts

    mov al, 10
    call putchar

    mov eax, 1
    mov ebx, 0
    int 0x80

atoi:
    mov esi, edx
    xor eax, eax
    mov ebx, 1

espacios:
    cmp byte [esi], ' '
    je siguiente
    cmp byte [esi], 9
    jne signo

siguiente:
    inc esi
    jmp espacios

signo:
    cmp byte [esi], '-'
    jne positivo
    mov ebx, -1
    inc esi
    jmp convertir

positivo:
    cmp byte [esi], '+'
    jne convertir
    inc esi

convertir:
    movzx ecx, byte [esi]
    cmp ecx, '0'
    jl fin_atoi
    cmp ecx, '9'
    jg fin_atoi

    sub ecx, '0'
    imul eax, eax, 10
    add eax, ecx

    inc esi
    jmp convertir

fin_atoi:
    imul eax, ebx
    ret

itoa:
    mov edi, edx
    mov esi, edx
    mov ebx, 10

    cmp ecx, 2
    jb fin_itoa

    cmp eax, 0
    jge convertir_numero

    mov byte [edi], '-'
    inc edi
    dec ecx

convertir_numero:
    mov esi, edi
    mov ebp, ecx
    dec ebp

dividir:
    cdq
    idiv ebx

    cmp edx, 0
    jge digito
    neg edx

digito:
    add dl, '0'
    mov [edi], dl
    inc edi
    dec ebp

    cmp eax, 0
    je invertir
    cmp ebp, 0
    jne dividir

invertir:
    mov byte [edi], 0
    dec edi

cambiar:
    cmp esi, edi
    jae fin_itoa

    mov al, [esi]
    mov ah, [edi]
    mov [esi], ah
    mov [edi], al

    inc esi
    dec edi
    jmp cambiar

fin_itoa:
    mov eax, edx
    ret
