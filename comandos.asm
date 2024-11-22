section     .data
    ; Mensajes
    MSG_COMANDO                db "Ingrese un comando", 0
    MSG_GUARDAR                db "¿Está seguro que desea guardar la partida? Perderá la partida guardada anteriormente. (S/N):", 0
    MSG_RECUPERAR              db "¿Está seguro que desea recuperar la partida guardada? Perderá el progreso de la partida actual. (S/N):", 0
    MSG_MOVER                  db "¿Está seguro que desea mover una pieza? Una vez iniciada esta acción, no puede detenerse. (S/N): ", 0
    MSG_SALIR                  db "¿Está seguro que desea salir? Perderá todo su progreso. (S/N): ", 0
    MSG_SOLDADO                db "Redirigió a mover soldado", 0
    MSG_OFICIAL                db "Redirigió a mover oficial", 0
    MSG_ERROR_COORDENADA       db "La coordenada ingresada es inválida, recordar que debe ser un número entre 1 y 7", 0
    MSG_ERROR_POSICION_INICIAL db "La posición ingresada es inválida, las coordenadas deben estar dentro del tablero", 0
    MSG_ERROR_POSICION_FINAL   db "La posición a la que se quiere mover esta fuera del tablero", 0
    MSG_ERROR_POSICION_OCUPADA db "La posición a la que se quiere mover esta ocupada", 0
    MSG_ERROR_NO_HAY_SOLDADO   db "La posicion que ingreso no tiene un soldado, recuerde que debe ingresar las coordenadas del soldado que quiere mover", 0
    MSG_ERROR_NO_HAY_OFICIAL   db "La posicion que ingreso no tiene un oficial, recuerde que debe ingresar las coordenadas del oficial que quiere mover", 0
    MSG_ERROR_SOLDADO_LATERAL   db "Un soldado que no esta en la seccion de color rojo, no puede moverse lateralmente", 0
    MSG_ERROR_MOVIMIENTO       db "El movimiento ingresado es inválido, leer los movimientos posibles para las piezas", 0
    MSG_COORDENADA_HORIZONTAL  db "Ingrese la coordenada horizontal: ", 0
    MSG_COORDENADA_VERTICAL    db "Ingrese la coordenada vertical: ", 0
    MSG_MOVIMIENTO             db "Ingrese el movimiento que desea hacer", 0

    ; Comandos
    COMANDO_MOVER              db "M", 0
    COMANDO_GUARDAR            db "G", 0
    COMANDO_RECUPERAR          db "R", 0
    COMANDO_SALIR              db "S", 0

    ; Constantes del juego
    POSICIONES_VALIDAS         db 2,3,4,9,10,11,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,37,38,39,44,45,46
    POSICIONES_SOLDADO_LATERAL db 28,29,33,34
    CANTIDAD_FILAS             db 7
    SOLDADO_PREDETERMINADO     db 'X'
    OFICIAL_PREDETERMINADO     db 'O'
    ESPACIO_VACIO              db '-'

    ; Variables del juego
    desplazamiento              db 0
    coordenada_horizontal       db 0
    coordenada_vertical         db 0
    posicion_inicial            db 0
    posicion_final              db 0
    posicion_soldado_a_capturar db 0

section     .bss
    ; Datos ingresados por el usuario
    input          resb 1
    input_numerico resb 1

%macro imprimir_error 2
    imprimir_mensaje %1
    jmp %2
%endmacro 
%macro imprimir_turno 0
    mov al, [turno]  
    cmp al, 'S'       
    je %%imprimir_soldado
    cmp al, 'O'        
    je %%imprimir_oficial
    
    %%imprimir_soldado:
        imprimir_mensaje MSG_SOLDADO
        jmp %%fin
    
    %%imprimir_oficial:
        imprimir_mensaje MSG_OFICIAL
    %%fin:
%endmacro
%macro es_coordenada_invalida 1

    cmp %1, 1                       
    jl %%coordenada_invalida         
    cmp %1, 7                       
    jg %%coordenada_invalida         
    
    ; Si la coordenada es valida, settea el ZF=0
        mov rax, 1
        cmp rax, 0

    jmp %%fin                         

    %%coordenada_invalida:
        ; Si la coordenada es invalida, settea el ZF=1
        mov rax, 0
        cmp rax, 0

    %%fin:
%endmacro

%macro es_posicion_invalida 1
    ; Verificar si la posición está en la lista de posiciones válidas
    mov     al, [%1]                ; Cargar la posición a verificar en el registro al
    mov     rsi, POSICIONES_VALIDAS   ; Cargar la dirección de la lista de posiciones válidas
    mov     rcx, 33               ; Número de elementos en la lista (en este caso 33)

    %%buscar_posicion_valida:
        cmp     al, [rsi]             ; Comparar la posición con el valor en la lista
        je      %%posicion_valida      ; Si son iguales, la posición es válida, salta a la etiqueta de fin

        inc     rsi                   ; Avanzar al siguiente valor en la lista
        loop    %%buscar_posicion_valida ; Repetir hasta que se haya comprobado toda la lista

        ; Si no se encontró la posición en la lista, es inválida
        jmp     %%posicion_invalida    ; Salta a la sección de error

    %%posicion_valida:
        ; Si la posicion es valida, settea el ZF=0
        mov rax, 1
        cmp rax, 0
        jmp     %%fin                  ; Si la posiciOn es válida, termina la macro

    %%posicion_invalida:
        ; Si la posicion es invalida, settea el ZF=1
        mov rax, 0
        cmp rax, 0
    %%fin:
%endmacro

%macro es_movimiento_invalido 2
    cmp %2, 'S'
    je %%es_soldado
    cmp %2, 'O'
    je %%es_oficial

    %%es_soldado:
        cmp %1, [movimiento_abajo]
        je %%valido
        cmp %1, [movimiento_abajo_derecha]
        je %%valido
        cmp %1, [movimiento_abajo_izquierda]
        je %%valido
        cmp %1, [movimiento_derecha]
        je %%valido
        cmp %1, [movimiento_izquierda]
        je %%valido
        jmp %%invalido

    %%es_oficial:
        cmp %1, [movimiento_abajo]
        je %%valido
        cmp %1, [movimiento_abajo_derecha]
        je %%valido
        cmp %1, [movimiento_abajo_izquierda]
        je %%valido
        cmp %1, [movimiento_derecha]
        je %%valido
        cmp %1, [movimiento_izquierda]
        je %%valido
        cmp %1, [movimiento_arriba]
        je %%valido
        cmp %1, [movimiento_arriba_derecha]
        je %%valido
        cmp %1, [movimiento_arriba_izquierda]
        je %%valido
        jmp %%invalido

    %%valido:
        mov rax, 1
        cmp rax, 0
        jmp %%fin

    %%invalido:
        mov rax, 0
        cmp rax, 0
    %%fin:
%endmacro
%macro convertir_caracter_a_numero 1
    mov     rdi, %1              
    mAtoi                        
    mov     [input_numerico], al                       
%endmacro

%macro comparar_comando 2
    ; Compara el input ingresado con el comando dado
    mov rsi, input        ; Carga el comando ingresado
    mov rdi, %1             ; Carga el comando a comparar
    mov rcx, 1              
    repe cmpsb              ; Compara los dos strings

    je %2                   ; Si son iguales, salta a la etiqueta proporcionada
%endmacro

%macro actualizar_coordenadas 1
    
    cmp %1, [movimiento_abajo]
    je %%mover_abajo
    cmp %1, [movimiento_arriba]
    je %%mover_arriba
    cmp %1, [movimiento_derecha]
    je %%mover_derecha
    cmp %1, [movimiento_izquierda]
    je %%mover_izquierda
    cmp %1, [movimiento_abajo_derecha]
    je %%mover_abajo_derecha
    cmp %1, [movimiento_abajo_izquierda]
    je %%mover_abajo_izquierda
    cmp %1, [movimiento_arriba_derecha]
    je %%mover_arriba_derecha
    cmp %1, [movimiento_arriba_izquierda]
    je %%mover_arriba_izquierda
    jmp %%fin

    %%mover_abajo:
        inc byte[coordenada_vertical]
        jmp %%fin

    %%mover_arriba:
        dec byte[coordenada_vertical]
        jmp %%fin

    %%mover_derecha:
        inc byte[coordenada_horizontal]
        jmp %%fin

    %%mover_izquierda:
        dec byte[coordenada_horizontal]
        jmp %%fin

    %%mover_abajo_derecha:
        inc byte[coordenada_vertical]
        inc byte[coordenada_horizontal]
        jmp %%fin

    %%mover_abajo_izquierda:
        inc byte[coordenada_vertical]
        dec byte[coordenada_horizontal]
        jmp %%fin

    %%mover_arriba_derecha:
        dec byte[coordenada_vertical]
        inc byte[coordenada_horizontal]
        jmp %%fin

    %%mover_arriba_izquierda:
        dec byte[coordenada_vertical]
        dec byte[coordenada_horizontal]
        jmp %%fin

    %%fin:
%endmacro

%macro calcular_posicion 3
    ; La macro recibe dos parametros: x, y, posicion
    ; Al final el resultado de la operación (x-1)*7 + (y-1) se guarda en la variable posicion
    
    mov     al, byte[%1]             
    sub     al, 1             

    imul byte[CANTIDAD_FILAS]       

    mov     bl, byte[%2]             
    sub     bl, 1            

    add     al, bl         

    mov     [%3], al
%endmacro

%macro verificar_elemento_en_posicion 2
    mov al, [%1]
    mov bl, [%2]
    movzx rbx, bl  
    cmp al, [tablero+rbx]       
    je %%hay_elemento
        mov rax, 1
        cmp rax, 0
        jmp %%fin
    %%hay_elemento:
        mov rax, 0
        cmp rax, 0
        jmp %%fin
    %%fin:
%endmacro

%macro ocupar_posicion_tablero 2
    mov al, [%1]
    mov bl, [%2]
    movzx rbx, bl
    mov [tablero+rbx], al 
%endmacro

%macro es_soldado_lateral 1
    ; Verificar si la posición está en la lista de posiciones válidas
    mov     al, [%1]                ; Cargar la posición a verificar en el registro al
    mov     rsi, POSICIONES_SOLDADO_LATERAL   ; Cargar la dirección de la lista de posiciones laterales
    mov     rcx, 4             ; Número de elementos en la lista (en este caso 33)

    %%buscar_posicion_valida:
        cmp     al, [rsi]             ; Comparar la posición con el valor en la lista
        je      %%posicion_valida      ; Si son iguales, la posición es válida, salta a la etiqueta de fin

        inc     rsi                   ; Avanzar al siguiente valor en la lista
        loop    %%buscar_posicion_valida ; Repetir hasta que se haya comprobado toda la lista

        ; Si no se encontró la posición en la lista, es inválida
        jmp     %%posicion_invalida    ; Salta a la sección de error

    %%posicion_valida:
        ; Si la posicion es valida, settea el ZF=0
        mov rax, 1
        cmp rax, 0
        jmp     %%fin                  ; Si la posiciOn es válida, termina la macro

    %%posicion_invalida:
        ; Si la posicion es invalida, settea el ZF=1
        mov rax, 0
        cmp rax, 0
    %%fin:
%endmacro

%macro intercambiar_valores 2
    mov al, [%1]
    mov bl, [%2]

    mov [%1], bl
    mov [%2], al
%endmacro

%macro leer_input 0
    mov		rdi,input	
	mGets
%endmacro

section .text
procesar_input:
    imprimir_mensaje MSG_COMANDO ; Pido el comando
    
    leer_input ; Leo el comando ingresado

    comparar_comando COMANDO_MOVER, mover_pieza ; Redirijo al comando mover si corresponde
    comparar_comando COMANDO_GUARDAR, guardar_partida ; Redirijo al comando guardar si corresponde
    comparar_comando COMANDO_RECUPERAR, recuperar_partida ; Redirijo al comando recuperar si corresponde
    comparar_comando COMANDO_SALIR, salir_del_juego ; Redirijo al comando salir si corresponde

    imprimir_mensaje msg_error_comando ; Si no coincide con ningun comando, muestra un mensaje de error

    ret

guardar_partida:
    imprimir_mensaje MSG_GUARDAR

    leer_input

    mov al, [input]  
    cmp al, 'S'      
    jne procesar_input  

    mov al, [primer_oficial_posicion]         
    mov [primer_oficial_posicion_guardada], al 

    mov al, [primer_oficial_capturas]         
    mov [primer_oficial_capturas_guardada], al 

    mov al, [primer_oficial_movimientos]      
    mov [primer_oficial_movimientos_guardada], al 

    ; Copiar las variables del segundo oficial
    mov al, [segundo_oficial_posicion]       
    mov [segundo_oficial_posicion_guardada], al 

    mov al, [segundo_oficial_capturas]       
    mov [segundo_oficial_capturas_guardada], al 

    mov al, [segundo_oficial_movimientos]     
    mov [segundo_oficial_movimientos_guardada], al 

    mov al, [turno]                         
    mov [turno_guardada], al                 

    mov al, [tablero]           
    mov [tablero_guardado], al            

    mov rax, 0                  

    .guarda_tablero:
        mov al, [tablero+rax]          
        mov [tablero_guardado+rax], al            
        inc rax
        cmp rax, 49                               ; Cantidad de elementos en el tablero
        jle .guarda_tablero

    ret

recuperar_partida:
    imprimir_mensaje MSG_RECUPERAR

    leer_input

    mov al, [input] 
    cmp al, 'S'     
    jne procesar_input  

    mov al, [primer_oficial_posicion_guardada]  
    mov [primer_oficial_posicion], al         

    mov al, [primer_oficial_capturas_guardada]  
    mov [primer_oficial_capturas], al          

    mov al, [primer_oficial_movimientos_guardada] 
    mov [primer_oficial_movimientos], al       

    mov al, [segundo_oficial_posicion_guardada] 
    mov [segundo_oficial_posicion], al         

    mov al, [segundo_oficial_capturas_guardada] 
    mov [segundo_oficial_capturas], al         

    mov al, [segundo_oficial_movimientos_guardada] 
    mov [segundo_oficial_movimientos], al      

    mov al, [turno_guardada]                   
    mov [turno], al                            

    mov rax, 0                  

    .recupera_tablero:
        mov al, [tablero_guardado+rax]            
        mov [tablero+rax], al           
        inc rax
        cmp rax, 49                               ; Cantidad de elementos en el tablero
        jle .recupera_tablero


    ret                                       

mover_pieza:
    imprimir_mensaje MSG_MOVER

    leer_input  ; Leer el input del usuario

    mov al, [input]  ; Preparo para comparar el input
    cmp al, 'S'      ; Comparo con confirmacion del usuario   
    jne procesar_input ; Si no confirma, vuelve a pedir un comando

    imprimir_turno ; Imprimo si es turno de los soldados o de los oficiales

    imprimir_mensaje MSG_COORDENADA_VERTICAL ; Pido la coordenada vertical
    leer_input  ; Leo la coordenada vertical
    
    convertir_caracter_a_numero input ; Convierto la cordenada vertical en un numero
    
    mov al, [input_numerico] ; Paso la coordenada vertical a un registro para poder mandarla a una macro
    es_coordenada_invalida al  ; Veo si la coordenada vertical es valida
    
    je .imprimir_error_coordenada ; Si la coordenada vertical es invalida, imprimo el error

    mov al, [input_numerico] ; Paso la coordenada vertical a un registro para poder almacenarla en una variable
    mov [coordenada_vertical], al ; Almaceno la coordenada vertical en la variable correspondiente

    imprimir_mensaje MSG_COORDENADA_HORIZONTAL ; Pido la coordenada horizontal
    leer_input ; Leo la coordenada horizontal

    convertir_caracter_a_numero input ; Convierto la coordenada horizontal en un numero

    mov al, [input_numerico] ; Paso la coordenada horizontal a un registro para poder mandarla a una macro
    es_coordenada_invalida al  ; Veo si la coordenada horizontal es invalida

    je .imprimir_error_coordenada ; Si la coordenada horizontal es invalida, imprimo el error

    mov al, [input_numerico] ; Paso la coordenada horizontal a un registro para poder almacenarla en una variable
    mov [coordenada_horizontal], al ; Almaceno la coordenada horizontal en la variable correspondiente

    mov al, '2' ; Verifico si el tablero esta rotado 90 grados para calibrar las coordenadas
    cmp al, [orientacion]
    je .intercambiar_coordenadas

    mov al, '4' ; Verifico si el tablero esta rotado 270 grados para calibrar las coordenadas
    cmp al, [orientacion]
    je .intercambiar_coordenadas

    jmp .continua

    .intercambiar_coordenadas:
        intercambiar_valores coordenada_horizontal, coordenada_vertical
    .continua:

    calcular_posicion coordenada_vertical, coordenada_horizontal, posicion_inicial ; Calculo el desplazamiento del tablero para llegar al elemento que quiero

    es_posicion_invalida posicion_inicial ; Veo si la posicion es invalida

    je .imprimir_error_posicion ; Si la posicion es invalida, imprimo el error

    imprimir_mensaje MSG_MOVIMIENTO ; Pido el movimiento
    leer_input ; Leo el movimiento

    mov al, [input] ; Preparo el movimiento para mandarlo a una macro
    mov bl, [turno] ; Preparo el tipo de pieza para mandarlo a una macro
    es_movimiento_invalido al, bl ; Veo si el movimiento ingresado es valido

    je .imprimir_error_movimiento ; Si el movimiento es invalido, imprimo el error

    ; Continuar con la logica de mover_pieza segun el turno
    mov al, [turno]  
    cmp al, 'S'       
    je mover_soldado 
    cmp al, 'O'        
    je mover_oficial

    jmp .fin

    .imprimir_error_coordenada:
        imprimir_error MSG_ERROR_COORDENADA, procesar_input
        jmp .fin
    
    .imprimir_error_posicion:
        imprimir_error MSG_ERROR_POSICION_INICIAL, procesar_input
        jmp .fin

    .imprimir_error_movimiento:
        imprimir_error MSG_ERROR_MOVIMIENTO, procesar_input
        jmp .fin 
    .fin:
    ret 

mover_soldado:
    imprimir_mensaje MSG_SOLDADO ; Imprimo mensaje que declara el turno de los soldados y explica los movimeintos posibles

    verificar_elemento_en_posicion SOLDADO_PREDETERMINADO, posicion_inicial ; Veo si la posicion tiene un soldado

    jne .imprimir_error_no_hay_soldado ; Imprimo error si no hay soldado

    es_soldado_lateral posicion_inicial ; Veo si es soldado lateral

    je .no_es_soldado_lateral ; Si no es, analizo si el movimiento ingresado es lateral
    jmp .continua ; Si es, continuo

    .no_es_soldado_lateral:
        mov al, [input]
        cmp al, [movimiento_derecha]
        je .imprimir_error_soldado_lateral
        cmp al, [movimiento_izquierda]
        je .imprimir_error_soldado_lateral ; Imprimo error si el soldado no es lateral y quiere hacer un movimiento lateral

    .continua:

    mov al, [input]
    actualizar_coordenadas al ; Calculo las coordenadas aplicando el movimiento

    calcular_posicion coordenada_vertical, coordenada_horizontal, posicion_final ; Calculo la posicion con las coordenadas actualizadas

    es_posicion_invalida posicion_final ; Veo si la posicion es invalida

    je .imprimir_error_posicion ; Si la posicion es invalida, imprimo el error

    verificar_elemento_en_posicion ESPACIO_VACIO, posicion_final ; Veo si la posicion a la que se movera el soldado esta vacia

    jne .imprimir_error_posicion_ocupada ; Si la posicion esta ocupada, imprimo el error

    ocupar_posicion_tablero SOLDADO_PREDETERMINADO, posicion_final ; Muevo el soldado a la posicion que corresponde

    ocupar_posicion_tablero ESPACIO_VACIO, posicion_inicial ; Dejo vacia la posicion de la que se movio el soldado

    mov byte[turno], 'O' ; Si movi el soldado exitosamente, pasa a ser turno de los oficiales

    jmp .fin

    .imprimir_error_posicion:
        imprimir_error MSG_ERROR_POSICION_FINAL, procesar_input
        jmp .fin
    .imprimir_error_posicion_ocupada:
        imprimir_error MSG_ERROR_POSICION_OCUPADA, procesar_input
        jmp .fin
    .imprimir_error_no_hay_soldado:
        imprimir_error MSG_ERROR_NO_HAY_SOLDADO, procesar_input
        jmp .fin
    .imprimir_error_soldado_lateral:
        imprimir_error MSG_ERROR_SOLDADO_LATERAL, procesar_input
        jmp .fin
    .fin:
    ret

mover_oficial:
    imprimir_mensaje MSG_OFICIAL

    verificar_elemento_en_posicion OFICIAL_PREDETERMINADO, posicion_inicial ; Veo si la posicion tiene un oficial

    jne .imprimir_error_no_hay_oficial ; Imprimo error si no hay oficial
    mov al, [input]
    actualizar_coordenadas al ; Calculo las coordenadas aplicando el movimiento

    calcular_posicion coordenada_vertical, coordenada_horizontal, posicion_final ; Calculo la posicion con las coordenadas actualizadas

    es_posicion_invalida posicion_final ; Veo si la posicion es invalida

    je .imprimir_error_posicion ; Si la posicion es invalida, imprimo el error

    verificar_elemento_en_posicion ESPACIO_VACIO, posicion_final ; Veo si la posicion a la que se movera el oficial esta vacia

    je .continua ; Si la posicion esta vacia, me muevo ahi.

    .captura_soldado:
        verificar_elemento_en_posicion OFICIAL_PREDETERMINADO, posicion_final ; Veo si lo que quiero saltar es un oficial
        je .imprimir_error_posicion_ocupada ; Si quiero saltar un oficial, imprimir error

        mov al, [posicion_final]
        mov [posicion_soldado_a_capturar], al ; Me guardo la posicion en caso de que tenga que capturar el soldado
        mov al, [input]
        actualizar_coordenadas al ; Actualizo las coordenadas para saltar al soldado

        calcular_posicion coordenada_vertical, coordenada_horizontal, posicion_final ; Calculo la posicion con las coordenadas actualizadas

        es_posicion_invalida posicion_final ; Veo si la posicion es invalida

        je .imprimir_error_posicion ; Si la posicion es invalida, imprimo el error

        verificar_elemento_en_posicion ESPACIO_VACIO, posicion_final ; Veo si la posicion a la que se movera el oficial esta vacia

        jne .imprimir_error_posicion_ocupada ; Si la posicion esta ocupada, imprimo error

        ocupar_posicion_tablero ESPACIO_VACIO, posicion_soldado_a_capturar ; Si no lo esta, capturo el soldado

        mov al, [primer_oficial_posicion]
        cmp al, [posicion_inicial]
        je .actualizar_primer_oficial ; Si era el primer oficial actualizo sus datos

        mov al, [segundo_oficial_posicion]
        cmp al, [posicion_inicial]
        je .actualizar_segundo_oficial ; Si era el segundo oficial actualizo sus datos
        
        jmp .continua ; Nunca deberia llegar aca

        .actualizar_primer_oficial:
            mov al, [posicion_final]
            mov [primer_oficial_posicion], al

            inc byte[primer_oficial_capturas]

            jmp .continua

        .actualizar_segundo_oficial:
            mov al, [posicion_final]
            mov [segundo_oficial_posicion], al

            inc byte[segundo_oficial_capturas]

            jmp .continua
    .continua:

    ocupar_posicion_tablero OFICIAL_PREDETERMINADO, posicion_final ; Muevo el oficial a la posicion que corresponde

    ocupar_posicion_tablero ESPACIO_VACIO, posicion_inicial ; Dejo vacia la posicion de la que se movio el oficial

    mov al, [primer_oficial_posicion]
    cmp al, [posicion_inicial]
    je .actualizar_movimientos_primer_oficial ; Si era el primer oficial actualizo sus movimientos

    mov al, [segundo_oficial_posicion]
    cmp al, [posicion_inicial]
    je .actualizar_movimientos_segundo_oficial ; Si era el segundo oficial actualizo sus movimientos
        
    jmp .termina ; Nunca deberia llegar aca

    .actualizar_movimientos_primer_oficial:
        inc byte[primer_oficial_movimientos]
        jmp .termina

    .actualizar_movimientos_segundo_oficial:
        inc byte[segundo_oficial_movimientos]
        jmp .termina

    .termina:
    mov byte[turno], 'S' ; Si movi el oficial exitosamente, pasa a ser turno de los soldados

    jmp .fin
    .imprimir_error_posicion_ocupada:
        imprimir_error MSG_ERROR_POSICION_OCUPADA, procesar_input
        jmp .fin
    .imprimir_error_no_hay_oficial:
        imprimir_error MSG_ERROR_NO_HAY_OFICIAL, procesar_input
        jmp .fin
    .imprimir_error_posicion:
        imprimir_error MSG_ERROR_POSICION_FINAL, procesar_input
        jmp .fin
    .fin: 
    ret
    
salir_del_juego:
    imprimir_mensaje MSG_SALIR

    leer_input

    ; Si el usuario confirmo la salida, redirijo a fin_del_juego
    mov     al, [input]
    cmp     al, 'S'
    je fin_del_juego

    ; Si no es 'S', vuelve al procesamiento de input
    jmp procesar_input


