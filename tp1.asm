;nasm -f elf64 -g -F dwarf -l tp1.lst -o tp1.o tp1.asm
;gcc -no-pie -o tp1 tp1.o

%include "mensajes.asm"
%include "funciones_de_c.asm"
%include "constantes.asm"           
%include "variables.asm"           
%include "errores.asm"              
%include "comandos.asm"
%include "partida.asm"
%include "tablero.asm"
%include "configuracion.asm"
%include "movimiento.asm"
%include "guardar_recuperar_partida.asm"

global main

section .data
    ascii db 0
section     .text
%macro imprimir_estadisticas_movimientos 4
    imprimir_mensaje header_movimientos

    ; Inicializa el array ascii con espacios y separadores
    mov rdi, ascii
    mov rcx, 33
    mov al, ' '
    rep stosb

    ; Insertar separadores
    mov byte [ascii+7], '|'
    mov byte [ascii+15], '|'
    mov byte [ascii+25], '|'
    mov byte [ascii+31], 0x0A  ; Carácter de nueva línea
    mov byte [ascii+32], 0     ; Terminar la cadena con nulo

    mov al, [%1]
    add al, '0'
    mov [ascii+3], al

    mov al, [%2]
    add al, '0'
    mov [ascii+11], al

    mov al, [%3]
    add al, '0'
    mov [ascii+20], al

    mov al, [%4]
    add al, '0'
    mov [ascii+30], al

    mov rdi, ascii
    mPuts

%endmacro
main:
    imprimir_mensaje msg_bienvenida

    call establecer_configuracion
    call loop_juego
    jmp fin_del_juego

    ret

loop_juego:
    call imprimir_tablero
    call procesar_input
    call verificar_partida
    je loop_juego

    ret

fin_del_juego:
    imprimir_mensaje msg_estadisticas_capturas
    imprimir_mensaje msg_estadisticas_oficial1
    mov al, [primer_oficial_capturas] 
    add al, '0'
    mov [ascii], al

    mov byte [ascii+1], 0x0A          
    mov byte [ascii+2], 0             

    mov rdi, ascii
    mPuts    

    imprimir_mensaje msg_estadisticas_oficial2 
    mov al, [primer_oficial_capturas] 
    add al, '0'
    mov [ascii], al

    mov byte [ascii+1], 0x0A         
    mov byte [ascii+2], 0           

    mov rdi, ascii
    mPuts   

    imprimir_mensaje msg_estadisticas_movimientos
    imprimir_mensaje msg_estadisticas_oficial1
    imprimir_estadisticas_movimientos primer_oficial_movs_arriba, primer_oficial_movs_abajo, primer_oficial_movs_derecha, primer_oficial_movs_izquierda
    imprimir_mensaje msg_estadisticas_oficial2 
    imprimir_estadisticas_movimientos segundo_oficial_movs_arriba, segundo_oficial_movs_abajo, segundo_oficial_movs_derecha, segundo_oficial_movs_izquierda

    
    imprimir_mensaje msg_final_partida 
    ; Finaliza el programa
    mov rax, 60       
    xor rdi, rdi      
    syscall           


    