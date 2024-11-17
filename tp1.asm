;nasm -f elf64 -g -F dwarf -l tp1.lst -o tp1.o tp1.asm
;gcc -no-pie -o tp1 tp1.o

%include "mensajes.asm"
%include "funciones_de_c.asm"
%include "constantes.asm"           
%include "variables.asm"           
; %include "partida_guardada.asm"     
%include "errores.asm"              
; %include "comandos.asm"
%include "partida.asm"
; %include "tablero.asm"
%include "configuracion.asm"
%include "movimiento.asm"

global main

section     .text
main:
    imprimir_mensaje msg_bienvenida

    call establecer_configuracion

    call loop_juego

    jmp fin_del_juego

    ret

loop_juego:
    call verificar_partida
    je loop_juego

    ret

fin_del_juego:
    imprimir_mensaje msg_estadisticas
    imprimir_mensaje msg_final_partida 
    ; Finaliza el programa
    mov rax, 60       
    xor rdi, rdi      
    syscall           

