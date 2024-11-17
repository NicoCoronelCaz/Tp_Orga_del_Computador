section     .data
    msg_input db "Ingrese input",0
    msg_guardar db "Ingresaste guardar",0
    msg_recuperar db "Ingresaste recuperar",0
    msg_mover db "Ingresaste mover",0
    msg_salir db "Ingresaste salir",0
    COMANDO_MOVER          db "M",0
    COMANDO_GUARDAR        db "G",0
    COMANDO_RECUPERAR      db "R",0
    COMANDO_SALIR          db "S",0

section     .bss
    comando resb 1

%macro comparar_comando 2
    ; Compara el comando ingresado con el comando dado
    mov rsi, comando        ; Carga el comando ingresado
    mov rdi, %1             ; Carga el comando a comparar
    mov rcx, 1              
    repe cmpsb              ; Compara los dos strings

    je %2                   ; Si son iguales, salta a la etiqueta proporcionada
%endmacro

section .text
procesar_input:
    imprimir_mensaje msg_input
    ; Leo el input del usuario.
    mov		rdi,comando	
	mGets

    ; Redirijo al comando que corresponda
    comparar_comando COMANDO_MOVER, mover_pieza
    comparar_comando COMANDO_GUARDAR, guardar_partida
    comparar_comando COMANDO_RECUPERAR, recuperar_partida
    comparar_comando COMANDO_SALIR, salir_del_juego

    ; Si no coincide con ningún comando, muestra un mensaje de error
    imprimir_mensaje msg_error_comando

    ret

guardar_partida:
   imprimir_mensaje msg_guardar

    ret

recuperar_partida:
    imprimir_mensaje msg_recuperar

    ret

mover_pieza:
    imprimir_mensaje msg_mover

    ret
    
salir_del_juego:
    imprimir_mensaje msg_salir

    jmp fin_del_juego