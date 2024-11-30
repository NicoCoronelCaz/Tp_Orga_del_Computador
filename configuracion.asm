section .data
    msg_menu_configuracion db "CONFIGURACIÓN PERSONALIZADA", 10
                        db "¿Qué le gustaría hacer?", 10
                        db "1. Modificar símbolos de las piezas", 10
                        db "2. Modificar los turnos", 10
                        db "3. Modificar la orientación del tablero", 10, 
                        db "4. Salir del menú configuración", 10,
                        db "INGRESE UNA OPCIÓN:" ,0
section .bss
    respuesta_usuario resb 1 

section .text

%macro ingresar_input 2
    imprimir_mensaje %1
    mov rdi, %2
    mGets
%endmacro

establecer_configuracion:
        mov rdi,respuesta_usuario
        mGets

        mov     al, [respuesta_usuario]
        cmp     al, 'S'
        je      configuracion_personalizada

        cmp     al, 'N'
        je      salir_configuracion 

        imprimir_mensaje msg_invalido
        jmp     establecer_configuracion
configuracion_personalizada:
    ingresar_input msg_menu_configuracion, respuesta_usuario
    mov al, [respuesta_usuario]
    cmp al, '1'
    je establecer_simbolos
    cmp al, '2'
    je establecer_turnos
    cmp al, '3'
    je establecer_orientacion
    cmp al, '4'
    je salir_configuracion
    jmp configuracion_personalizada

establecer_simbolos:
    .pedir_soldado:
        imprimir_mensaje msg_simbolos
        ingresar_input msg_simboloSoldados, soldado
        mov al,[soldado]
        cmp al,'-'
        je .pedir_soldado
        cmp al,' '
        je .pedir_soldado

    .procesar_simboloOficial:
        ingresar_input msg_simboloOficiales, oficial
        mov al,[oficial]
        mov bl,[soldado]
        cmp al,'-'
        je .procesar_simboloOficial
        cmp al,' '
        je .procesar_simboloOficial  
        cmp al,bl
        jne  configuracion_personalizada 
        imprimir_mensaje msg_invalido
        jmp .procesar_simboloOficial
    
establecer_turnos:
    ingresar_input msg_turno, turno
    mov al, [turno]
    cmp al, 'S'
    je configuracion_personalizada
    cmp al, 'O'
    je configuracion_personalizada
    imprimir_mensaje msg_invalido
    jmp establecer_turnos

establecer_orientacion:
    ingresar_input msg_orientacion, orientacion
    mov al, [orientacion]
    sub al, '0'            
    cmp     al, 1
    jl      .orientacion_invalida
    cmp al,4 
    jg .orientacion_invalida
    mov     rsi,0
    jmp orientar_movimientos
    .orientacion_invalida:
        imprimir_mensaje msg_invalido
        jmp establecer_configuracion    


orientar_movimientos:
    mov al, [orientacion]
    cmp al, '1'
    je salir_configuracion
    cmp al, '2'
    je rota_90_grados
    cmp al, '3'
    je rota_180_grados
    cmp al, '4'
    je rota_270_grados
    ret
rota_90_grados:
    ; Arriba -> Izquierda, Abajo -> Derecha, Derecha -> Arriba, Izquierda -> Abajo
    mov byte [movimiento_arriba], 'A'
    mov byte [movimiento_abajo], 'D'
    mov byte [movimiento_derecha], 'W'
    mov byte [movimiento_izquierda], 'S'
    ; Diagonales
    mov byte [movimiento_arriba_derecha], 'Q'
    mov byte [movimiento_arriba_izquierda], 'Z'
    mov byte [movimiento_abajo_derecha], 'E'
    mov byte [movimiento_abajo_izquierda], 'C'
    jmp configuracion_personalizada

rota_180_grados:
    ; Arriba -> Abajo, Abajo -> Arriba, Derecha -> Izquierda, Izquierda -> Derecha
    mov byte [movimiento_arriba], 'S'
    mov byte [movimiento_abajo], 'W'
    mov byte [movimiento_derecha], 'A'
    mov byte [movimiento_izquierda], 'D'
    ; Diagonales
    mov byte [movimiento_arriba_derecha], 'Z'
    mov byte [movimiento_arriba_izquierda], 'C'
    mov byte [movimiento_abajo_derecha], 'Q'
    mov byte [movimiento_abajo_izquierda], 'E'
    jmp configuracion_personalizada

rota_270_grados:
    ; Arriba -> Derecha, Abajo -> Izquierda, Derecha -> Abajo, Izquierda -> Arriba
    mov byte [movimiento_arriba], 'D'
    mov byte [movimiento_abajo], 'A'
    mov byte [movimiento_derecha], 'S'
    mov byte [movimiento_izquierda], 'W'
    ; Diagonales
    mov byte [movimiento_arriba_derecha], 'C'
    mov byte [movimiento_arriba_izquierda], 'E'
    mov byte [movimiento_abajo_derecha], 'Z'
    mov byte [movimiento_abajo_izquierda], 'Q'
    jmp configuracion_personalizada


salir_configuracion:
    ret