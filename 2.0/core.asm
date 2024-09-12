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

    call get_input          

    jmp mainloop             

get_input:
    mov bx, 0                 

input_processing:
    mov ah, 0x0               
    int 0x16                 

    cmp al, 0x0d           
    je check_the_input        
                           

    cmp al, 0x8               
    je backspace_pressed

    mov ah, 0x0e              
                              
    int 0x10

    mov [input+bx], al     
    inc bx                

    cmp bx, 64             
    je check_the_input      

    jmp input_processing      
              
backspace_pressed:
    cmp bx, 0             
    je input_processing       
    
    mov ah, 0x0e             
    int 0x10                 

    mov al, ' '              
    int 0x10           

    mov al, 0x8              
    int 0x10                 

    dec bx
    mov byte [input+bx], 0    

    jmp input_processing      
  
check_the_input:
    inc bx
    mov byte [input+bx], 0    
                              

    mov si, new_line          
    call print_string_si

    mov si, help_command    
    mov bx, input            
    call compare_strs_si_bx 

    cmp cx, 1                
                            
    je equal_help            
                              
                              
    mov si, info_command
    mov bx, input
    call compare_strs_si_bx
    
    cmp cx, 1

    je equal_info
    

    jmp equal_to_nothing    
equal_help:
    mov si, help_desc
    call print_string_si

    jmp done

equal_info:
    mov si, info_desk
    call print_string_si

    jmp done

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

; 0x0d -
wrong_command: db "Fatal trigger!", 0x0d, 0xa, 0
entr: db "Loadins system...", 0x0d, 0xa, 0xa, 0
entra: db "Load commands...", 0x0d, 0xa, 0xa, 0
entrb: db "Log in system...", 0x0d, 0xa, 0xa, 0
entrc: db " ", 0x0d, 0xa, 0xa, 0
greetings: db "             Corp. WoDoSoftf, XtermixOS 2.1", 0x0d, 0xa, 0xa, 0

help_desc: db "tdir/inf", 0x0d, 0xa, 0
help_command: db "tdir", 0

prompt: db "X:", 0
new_line: db 0x0d, 0xa, 0

info_desk: db "XtermixOS 2.1 . With the help of KomaruFan. Core version 1.1", 0x0d, 0xa, 0
info_command: db "inf", 0

input: times 256 db 0        
goodbye: db 0x0d, 0xa, "How you can turn off your computer...", 0x0d, 0xa, 0


times 1022 - ($-$$) db 0
dw 0xaa55
