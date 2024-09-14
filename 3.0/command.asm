print_string_si:
    push ax                   ;  как и обещано часть исходного кода

    mov ah, 0x0e              
    call print_next_char      

    pop ax                    
    ret                     

print_next_char:
    mov al, [si]             
    cmp al, 0                
    jz if_zero              

    int 0x10                  
    inc si                    

    jmp print_next_char     

format_hd:
    mov dl, 80h
    mov ah, 05h
    mov ah, 06h
    mov ah, 07h

    je equal_test1
    
    jmp print_next_char 

format_fd:
    mov ah, 17h
    mov dl, 00h
    mov ah, 05h
    mov ah, 06h
    mov ah, 07h

    je equal_test2
    
    jmp print_next_char

if_zero:
    ret