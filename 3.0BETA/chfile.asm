compare_strs_si_bx:
    push si                   ; сохраняем все нужные в функции регистры на стеке
    push bx
    push ax

comp:
    mov ah, [bx]              ; напрямую регистры сравнить не получится,
    cmp [si], ah              ; поэтому переносим первый символ в ah
    jne not_equal             ; если символы не совпадают, то выходим из функции

    cmp byte [si], 0          ; в обратном случае сравниваем, является ли символ
    je first_zero             ; символом окончания строки

    inc si                    ; переходим к следующему байту bx и si
    inc bx

    jmp comp                  ; и повторяем

first_zero:
    cmp byte [bx], 0          ; если символ в bx != 0, то значит, что строки
    jne not_equal             ; не равны, поэтому переходим в not_equal

    mov cx, 1                 ; в обратном случае строки равны, значит cx = 1

    pop si                    ; поэтому восстанавливаем значения регистров
    pop bx
    pop ax

    ret                       ; и выходим из функции

not_equal:
    mov cx, 0                 ; не равны, значит cx = 0

    pop si                    ; восстанавливаем значения регистров
    pop bx
    pop ax

    ret                       ; и выходим из функции
    
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
    add esp, 12              ; Очищаем стек

    ; Завершение программы
    mov eax, 1               ; Код для выхода
    xor ebx, ebx             ; Код возврата 0
    int 0x80                 ; Вызов системного прерывания
    
    ret
