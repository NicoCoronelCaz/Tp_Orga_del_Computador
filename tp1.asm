;nasm -f elf64 -g -F dwarf -l tp1.lst -o tp1.o tp1.asm
;gcc -no-pie -o tp1 tp1.o

%include "mensajes.asm"
%include "funciones_de_c.asm"
%include "constantes.asm"
%include "variables.asm"
%include "partida_guardada.asm"
%include "errores.asm"

%macro comparar_comando 2
    ; Compara el comando ingresado con el comando dado
    mov rsi, comando        ; Carga el comando ingresado
    mov rdi, %1             ; Carga el comando a comparar
    mov rcx, 1              
    repe cmpsb              ; Compara los dos strings

    je %2                   ; Si son iguales, salta a la etiqueta proporcionada
%endmacro

global main

section     .data
    ; Formato para printf en rojo, basicamente settea la salida de la terminal en color rojo (31) y despues la settea nuevamente a su configuracion original
    formato_en_color_rojo db 0x1B, "[1;31m%s", 0x1B, "[0m", 10, 0 
    saludo db "Hola",0
    msg_input db "Ingrese input",0
    msg_guardar db "Ingresaste guardar",0
    msg_recuperar db "Ingresaste recuperar",0
    msg_mover db "Ingresaste mover",0
    msg_salir db "Ingresaste salir",0

section     .text
main:
    mov rdi, msg_input
    mPuts
    call procesar_input
; Probando imprimir con color
    mov rdi, formato_en_color_rojo   
    mov rsi, saludo      
    mPrintf
ret

procesar_input:
    ; Leo el input del usuario.
    mov		rdi,comando	
	mGets

    ; Redirijo al comando que corresponda
    comparar_comando COMANDO_MOVER, mover
    comparar_comando COMANDO_GUARDAR, guardar
    comparar_comando COMANDO_RECUPERAR, recuperar
    comparar_comando COMANDO_SALIR, salir

    ; Si no coincide con ningún comando, muestra un mensaje de error
    mov rdi, msg_error_comando
    mPuts

    ret

guardar:
    mov rdi, msg_guardar
    mPuts

    ret

recuperar:
    mov rdi, msg_recuperar
    mPuts

    ret

mover:
    mov rdi, msg_mover
    mPuts

    ret
    
salir:
    mov rdi, msg_salir
    mPuts

    ret

; Leo el input del usuario. Comandos posibles: 
        ; mover posicion movimiento:
            ; Verifico si la posicion recibida es valida, verifico si el movimiento recibido es valido.
        ; guardar:
            ; Pregunto si esta seguro 
        ; recuperar
            ; Pregunto si esta seguro 
    ;

;Idea de como quedaria el main:
    ;mensaje_inicial
    ;establecer_configuracion (Aca se configuraria la partida ya sea de manera personalizada o predeterminada)
;loop_juego:
    ;procesar_input (Esta parte procesa el input que recibe del usuario y llama a las macros que corresponden (moverSoldado, guardarPartida, recuperarPartida, salirDelJuego, etc.))
    ;verificar_partida (Si todavia no termino la partida, redirijo a la etiqueta 'loop_juego', si no, redirije al fin del programa)
;fin_del_juego: (etiqueta de fin del juego)
    ;mostrar_estadisticas
    ;saludo_final

