times_wd:
section .data
    n dd 365                  ; Количество минут
    hours db 0                ; Переменная для часов
    minutes db 0              ; Переменная для минут
    format db "%d:%02d", 0    ; Формат вывода

section .text
    extern printf             ; Объявляем внешнюю функцию printf
    global _start             ; Точка входа программы

_start:
    ; Вычисление часов и минут
    mov eax, [n]             ; Загружаем количество минут
    mov ecx, 60              ; Количество минут в часе
    xor edx, edx             ; Обнуляем edx для деления
    div ecx                  ; Делим, получаем часы (eax) и минуты (edx)
    mov [hours], al          ; Сохраняем часы
    mov [minutes], dl        ; Сохраняем минуты

    ; Вывод результата
    push dword [minutes]     ; Параметры для printf
    push dword [hours]
    push format
    call printf
    add esp, 12              ; Очищаем стек

    ; Завершение программы
    mov eax, 1               ; Код для выхода
    xor ebx, ebx             ; Код возврата 0
    int 0x80                 ; Вызов системного прерывания
