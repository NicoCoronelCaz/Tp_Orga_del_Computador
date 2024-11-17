section .data
    msg_configuracion db "Redireccion a configuracion exitosa", 10, 0
section .bss
    respuesta_usuario resb 1 

section .text

%macro ingresar_input 2
    mov rdi, %1
    mPuts
    mov rdi, %2
    mGets
%endmacro

establecer_configuracion:
    procesar_input:
        mov rdi,respuesta_usuario
        mGets

        mov     al, [respuesta_usuario]
        cmp     al, 'S'
        je      .pedir_soldado

        cmp     al, 'N'
        je      loop_juego 

        mov     rdi, msg_invalido
        mPuts
        jmp     procesar_input

    .pedir_soldado:
        mov rdi, msg_simbolos
        mPuts
        ingresar_input msg_simboloSoldados, soldado

    .procesar_simboloOficial:
        ingresar_input msg_simboloOficiales, oficial
        mov al,[oficial]
        mov bl,[soldado]
        cmp al,bl
        jne     .procesar_turno   
        mov     rdi, msg_invalido
        mPuts
        jmp .procesar_simboloOficial

    .procesar_turno:
        ingresar_input msg_turno, turno
        mov al, [turno]
        cmp al, 'S'
        je .procesar_orientacion
        cmp al, 'O'
        je .procesar_orientacion
        mov rdi, msg_invalido
        mPuts
        jmp .procesar_turno
    
    .procesar_orientacion:
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
        mov rdi, msg_invalido
        mPuts
        jmp .procesar_orientacion    


orientar_movimientos:
    mov al, [orientacion]
    cmp al, 1
    je loop_juego
    cmp al, 2
    je rota_90_grados
    cmp al,3
    je rota_180_grados
    cmp al, 4
    je rota_270_grados
    ret

rota_90_grados:
    mov rdi, msg_configuracion
    mPuts
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
    jmp loop_juego

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
    jmp loop_juego


rota_270_grados:
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
    jmp loop_juego
