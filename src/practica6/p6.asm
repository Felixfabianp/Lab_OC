%include "../../lib/pc_io.inc"

section .data
    bskey equ 0x7F
    lencadena equ 255
    ln equ 0x0A
    msg_prompt db 'Ingresa cadena: ', 0
    msg_minus db ln,'Minusculas: ', 0
    msg_mayus db ln,'Mayusculas: ', 0

section .bss
    cadena resb lencadena

section .text
    global _start

_start:
    mov edx, msg_prompt
    call puts

    mov ax, lencadena
    mov edx, cadena
    call captura

    mov edx, msg_minus
    call puts
    mov edx, cadena
    call minusculas
    call puts

    mov edx, msg_mayus
    call puts
    mov edx, cadena
    call mayusculas
    call puts

    mov al, ln
    call putchar

.fin_programa:
    mov eax, 1
    xor ebx, ebx
    int 0x80

captura:
    push eax
    push ebx
    push edx
    push esi

    movzx ebx, ax
    dec ebx
    mov esi, edx

.ciclo:
    call getch

    cmp al, ln
    je .fin

    cmp al, 0x0D
    je .fin

    cmp al, bskey
    je .retroceso

    cmp al, 0x08
    je .retroceso

    cmp ebx, 0
    je .ciclo

    mov [esi], al
    inc esi
    dec ebx
    call putchar
    jmp .ciclo

.retroceso:
    cmp esi, edx
    je .ciclo

    dec esi
    inc ebx
    call borrar
    jmp .ciclo

.fin:
    mov byte [esi], 0

    pop esi
    pop edx
    pop ebx
    pop eax
    ret

borrar:
    push eax
    mov al, 0x08
    call putchar
    mov al, ' '
    call putchar
    mov al, 0x08
    call putchar
    pop eax
    ret

mayusculas:
    push eax
    push edx

.ciclo:
    mov al, [edx]
    cmp al, 0
    je .salir
    cmp al, 'a'
    jb .siguiente
    cmp al, 'z'
    ja .siguiente
    sub al, 32
    mov [edx], al

.siguiente:
    inc edx
    jmp .ciclo

.salir:
    pop edx
    pop eax
    ret

minusculas:
    push eax
    push edx

.ciclo:
    mov al, [edx]
    cmp al, 0
    je .salir
    cmp al, 'A'
    jb .siguiente
    cmp al, 'Z'
    ja .siguiente
    add al, 32
    mov [edx], al

.siguiente:
    inc edx
    jmp .ciclo

.salir:
    pop edx
    pop eax
    ret
