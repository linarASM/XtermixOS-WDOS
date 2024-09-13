org 0x7c00
bits 16

jmp start                   

%include "command.asm"
%include "chfile.asm"

; LICENSE WMELA

start:
    cli                             
                                      

    mov ah, 0x00             
    mov al, 0x03
    int 0x10

    mov sp, 0x7c00            

    mov si, entr
    mov si, entra
    mov si, entrb
    mov si, entrc
    mov si, greetings
    call print_string_si     

mainloop:
    mov si, prompt 
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

    mov ah, 0x0e              ; во всех противных случаях - просто печатаем
                              ; очередной символ из ввода
    int 0x10

    mov [input+bx], al        ; и сохраняем его в буффер ввода
    inc bx                    ; увеличиваем индекс

    cmp bx, 64                ; если input переполнен
    je check_the_input        ; то ведем себя так, будто был нажат enter

    jmp input_processing      ; и идем заново
              
backspace_pressed:
    cmp bx, 0             
    je input_processing       
    
    mov ah, 0x0e             
    int 0x10                 

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
    je times_wd            
                                     
    jmp equal_to_nothing   
      
equal_to_nothing:
    mov si, wrong_command
    call print_string_si

    jmp done

; done очищает всю переменную input
done:
    cmp bx, 0                 
    je exit                   

    dec bx                    
    mov byte [input+bx], 0

    jmp done               

exit:
    ret

; 0x0d - символ возварата картки, 0xa - символ новой строки
wrong_command: db "Fatal trigger!", 0x0d, 0xa, 0
entr: db "Loadins system...", 0x0d, 0xa, 0xa, 0
entra: db "Load commands...", 0x0d, 0xa, 0xa, 0
entrb: db "Log in system...", 0x0d, 0xa, 0xa, 0
entrc: db " ", 0x0d, 0xa, 0xa, 0
greetings: db "             Corp. WoDoSoft, XtermixOS 3.0 Codename Fedora", 0x0d, 0xa, 0xa, 0

prompt: db "X:", 0
new_line: db 0x0d, 0xa, 0

help_command: db "time", 0

input: times 256 db 0        
goodbye: db 0x0d, 0xa, "How you can turn off your computer...", 0x0d, 0xa, 0


times 1022 - ($-$$) db 0
dw 0xaa55
