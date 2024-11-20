section .data
    posiciones_fortaleza db 30,31,32,37,38,39,44,45,46 ; Indice de las posiciones de la fortaleza en el tablero
    dir_movimientos db -7, 7, -1, 1, -8, -6, 6, 8 ; Movimientos posibles que pueden realizar los oficiales
    msg_partida_continua db "La partida continua", 10, 0
section     .text
oficial_tiene_mov_disponible: 
        mov rdi, 0                ; indice para recorrer las direcciones
        mov rcx, 8                ; contador para 8 direcciones posibles

        .chequear_direccion:
            movsx rdx, byte [dir_movimientos + rdi]
            mov dl, [tablero + rsi + rdx]  ; chequea la casilla adyacente o diagonal depende de rdx

            cmp dl, '-'
            je .movimiento_disponible 
            
            cmp dl, 'X'
            jne .siguiente_direccion    ; si no es soldado, ir a la siguiente dirección
            
            mov dl, [tablero + rsi + (rdx * 2)] ; chequea si se puede comer al soldado
            cmp dl, '-'
            je .movimiento_disponible   

        .siguiente_direccion:
            add rdi, 1
            loop .chequear_direccion    

        ret

        .movimiento_disponible:
            mov r8, 1 
            ret


verificar_partida:
    lea rbx, [tablero]        ; rbx apunta al inicio de la matriz
    mov cl, 0             
    mov rdi,0

    ;Chequeo la cantidada de soldados, si esta es menor a 9, ganan los oficiales, sino continua verificando la partida
    .verificar_cantidad_soldados:    
        mov al, [rbx + rdi]   
        cmp al, 'X'           
        jne .sig_pos    ; Si no es soldado va a la siguiente posición
        inc cl
        cmp cl, 9 ; Si cl >= 9, salir del ciclo
        je .verificar_fortaleza         

    .sig_pos:
        add rdi, 1
        cmp rdi, 49
        jne .verificar_cantidad_soldados   
    cmp cl, 9
    jl .ganaron_oficiales ;la cantidad de soldados es menor a 9

    ;Verifica si la fortaleza está ocupada por los soldados, si es asi ganan los soldados sino continua verificando la partida
    .verificar_fortaleza:
        mov rcx, 0 ; contador para las posiciones de la fortaleza
        mov ax, 0  ; cantidad de posiciones ocupadas por soldados
        mov rdi, posiciones_fortaleza 
        .verificar_soldados_en_fortaleza:
            movzx rdx, byte [rdi + rcx] ; cargar el índice de la fortaleza en rdx
            add rdx, tablero                ; accede a la posicion rdi+rcx de la matriz
            mov dl, [rdx]               
            cmp dl, 'X'                 
            jne .verificar_oficiales ; si no es soldado, pasa a verificar los oficiales
            inc ax                     ; suma al contador de soldados en fortaleza
            inc rcx                     ; siguiente posición en fortaleza
            cmp rcx, 9                  ; chequea que no se sobrepase de los nueve elementos de la fortaleza
            jne .verificar_soldados_en_fortaleza
        cmp ax, 9  ; Si ax es igual a 9, todos los puntos están ocupados por soldados
        je .ganaron_soldados
    
    ;Verifica si los oficiales estan encerrados, si es asi ganan los soldados, sino la partida continua
    .verificar_oficiales:
        mov rdi, 0            
        mov rax, 0             ; posición del oficial 1
        mov rbx, 0             ; posición del oficial 2
        mov r8, 0

        .buscar_ofc_loop:
            mov dl, [tablero + rdi]   
            cmp dl, 'O'          
            jne .siguiente_pos_ofc     
            cmp rax, 0             ; verifica si ya se guardo el primer oficial
            jne .guardar_oficial_2  ; si rax tiene un valor, guarda el segundo oficial
            mov rax, rdi          
            jmp .siguiente_pos_ofc
        .guardar_oficial_2:
            mov rbx, rdi           
            jmp .chequear_movimiento
        .siguiente_pos_ofc:
            inc rdi
            cmp rdi, 48
            jne .buscar_ofc_loop

        .chequear_movimiento:
            mov rsi, rax  ; posición del primer oficial
            call oficial_tiene_mov_disponible
            cmp r8,1  ;si es uno es porque el oficial tiene lugar para moverse
            je .sigue_partida ;con que no pueda moverse ya permite seguir con la partida
            mov rsi, rbx   ; posición del segundo oficial 
            call oficial_tiene_mov_disponible
            cmp r8,1
            je .sigue_partida

    .ganaron_soldados:
        mov rdi, msg_soldados_ganan
        mPuts
        jmp fin_del_juego

    .ganaron_oficiales:
        mov rdi, msg_oficiales_ganan
        mPuts
        jmp fin_del_juego
    .sigue_partida: ;temporal porque si redirijo a loop_juego entro en bucle
        mov rdi, msg_partida_continua
        mPuts
        jmp fin_del_juego
        ; xor rax, rax
        ; ret
