assembly
; Простой цветной загрузчик на NASM

section .text
    global _start

_start:
    ; Устанавливаем цвет фона и текста
    mov ax, 0x0E00  ; Устанавливаем цвет текста (белый)
    int 0x10       ; Вызов BIOS для установки цвета

    ; Показать сообщение
    mov si, message
    call print_string

    ; Бесконечный цикл
hang:
    jmp hang

print_string:
    mov ah, 0x0E    ; Функция BIOS для вывода символа
.next_char:
    lodsb           ; Загружаем следующий байт из строки
    test al, al     ; Проверка на конец строки (нулевой байт)
    jz .done        ; Если конец строки, выходим
    int 0x10       ; Выводим символ
    jmp .next_char  ; Переходим к следующему символу
.done:
    ret

section .data
message db 'Hello, World!', 0

