;nasm -f elf64 -g -F dwarf -l tp1.lst -o tp1.o tp1.asm
;gcc -no-pie -o tp1 tp1.o

%include "mensajes.asm"
%include "funciones_de_c.asm"
%include "constantes.asm"
%include "variables.asm"

global main

section     .text
    ; Formato para printf en rojo, basicamente settea la salida de la terminal en color rojo (31) y despues la settea nuevamente a su configuracion original
    formato_en_color_rojo db 0x1B, "[1;31m%s", 0x1B, "[0m", 10, 0 
    saludo db "Hola",0
main:
;Idea de como quedaria el main:
    ;mensaje_inicial
    ;establecer_configuracion (Aca se configuraria la partida ya sea de manera personalizada o predeterminada)
;loop_juego:
    ;procesar_input (Esta parte procesa el input que recibe del usuario y llama a las macros que corresponden (moverSoldado, guardarPartida, recuperarPartida, salirDelJuego, etc.))
    ;verificar_partida (Si todavia no termino la partida, redirijo a la etiqueta 'loop_juego', si no, redirije al fin del programa)
;fin_del_juego: (etiqueta de fin del juego)
    ;mostrar_estadisticas
    ;saludo_final
    mov rdi,msg_bienvenida
    mPuts
; Probando imprimir con color
    mov rdi, formato_en_color_rojo   
    mov rsi, saludo      
    mPrintf
ret

