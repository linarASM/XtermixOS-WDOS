org 0x7c00
bits 16

jmp start                     ; сразу переходим в start

%include "print_string.asm"
%include "str_compare.asm"

; ====================================================

start:
    cli                                ; запрещаем прерывания, чтобы наш код 
                                       ; ничто лишнее не останавливало

    mov ah, 0x00              ; очистка экрана
    mov al, 0x03
    int 0x10

    mov sp, 0x7c00            ; инициализация стека

    mov si, greetings         ; печатаем приветственное сообщение
    call print_string_si      ; после чего сразу переходим в mainloop

mainloop:
    mov si, prompt            ; печатаем стрелочку
    call print_string_si

    call get_input            ; вызываем функцию ожидания ввода

    jmp mainloop              ; повторяем mainloop...

get_input:
    mov bx, 0                 ; инициализируем bx как индекс для хранения ввода

input_processing:
    mov ah, 0x0               ; параметр для вызова 0x16
    int 0x16                  ; получаем ASCII код

    cmp al, 0x0d              ; если нажали enter
    je check_the_input        ; то вызываем функцию, в которой проверяем, какое
                              ; слово было введено

    cmp al, 0x8               ; если нажали backspace
    je backspace_pressed

    cmp al, 0x3               ; если нажали ctrl+c
    je format_disk

    mov ah, 0x0e              ; во всех противных случаях - просто печатаем
                              ; очередной символ из ввода
    int 0x10

    mov [input+bx], al        ; и сохраняем его в буффер ввода
    inc bx                    ; увеличиваем индекс

    cmp bx, 64                ; если input переполнен
    je check_the_input        ; то ведем себя так, будто был нажат enter

    jmp input_processing      ; и идем заново

format_disk:
    int 13h
    mov dl, 80h
    mov ah, 07h
    mov si, goodbye           ; печатаем прощание
    call print_string_si

    jmp input_processing
    
backspace_pressed:
    cmp bx, 0                 ; если backspace нажат, но input пуст, то
    je input_processing       ; ничего не делаем

    mov ah, 0x0e              ; печатаем backspace. это значит, что каретка
    int 0x10                  ; просто передвинется назад, но сам символ не сотрется

    mov al, ' '               ; поэтому печатаем пробел на том месте, куда
    int 0x10                  ; встала каретка

    mov al, 0x8               ; пробел передвинет каретку в изначальное положение
    int 0x10                  ; поэтому еще раз печатаем backspace

    dec bx
    mov byte [input+bx], 0    ; и убираем из input последний символ

    jmp input_processing      ; и возвращаемся обратно

check_the_input:
    inc bx
    mov byte [input+bx], 0    ; в конце ввода ставим ноль, означающий конец
                              ; стркоки (тот же '\0' в Си)

    mov si, new_line          ; печатаем символ новой строки
    call print_string_si

    mov si, help_command      ; в si загружаем заранее подготовленное слово help
    mov bx, input             ; а в bx - сам ввод
    call compare_strs_si_bx   ; сравниваем si и bx (введено ли help)

    cmp cx, 1                 ; compare_strs_si_bx загружает в cx 1, если
                              ; строки равны друг другу
    je equal_help             ; равны => вызываем функцию отображения
                              ; текста help

    jmp equal_to_nothing      ; если не равны, то выводим "Wrong command!"

equal_help:
    mov si, help_desc
    call print_string_si

    jmp done

equal_to_nothing:
    mov si, wrong_command
    call print_string_si

    jmp done

; done очищает всю переменную input
done:
    cmp bx, 0                 ; если зашли дальше начала input в памяти
    je exit                   ; то вызываем функцию, идующую обратно в mainloop

    dec bx                    ; если нет, то инициализируем очередной байт нулем
    mov byte [input+bx], 0

    jmp done                  ; и делаем то же самое заново

exit:
    ret

; 0x0d - символ возварата картки, 0xa - символ новой строки
wrong_command: db "Wrong command!", 0x0d, 0xa, 0
greetings: db "WoDoSoft Corporation 2022-2025. XtermixDOS 1.01", 0x0d, 0xa, 0xa, 0
help_desc: db "Access denied", 0x0d, 0xa, 0
goodbye: db 0x0d, 0xa, "Goodbye disk!", 0x0d, 0xa, 0
prompt: db "X:", 0
new_line: db 0x0d, 0xa, 0
help_command: db "help", 0
input: times 64 db 0          ; размер буффера - 64 байта

times 510 - ($-$$) db 0
dw 0xaa55
