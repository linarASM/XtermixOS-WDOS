print_string_si:
    push ax                   ; сохраняем ax на стеке

    mov ah, 0x0e              ; устанавливаем ah в 0x0e, чтобы вызвать функцию
    call print_next_char      ; прерывания

    pop ax                    ; восстанавливаем ax
    ret                       ; и выходим

print_next_char:
    mov al, [si]              ; загрузка одного символа
    cmp al, 0                 ; если si закончилась

    jz if_zero                ; то выходим из функции

    int 0x10                  ; в обратном случае печатаем al
    inc si                    ; и инкрементируем указатель

    jmp print_next_char       ; и начинаем заново...

if_zero:
    ret
