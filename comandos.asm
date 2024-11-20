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
    MSG_ERROR_POSICION         db "La posición ingresada es inválida, las coordenadas deben estar dentro del tablero", 0
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
    POSICIONES_VALIDAS     db 2,3,4,9,10,11,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,37,38,39,44,45,46
    CANTIDAD_FILAS         db 7

    ; Variables del juego
    desplazamiento         db 0
    coordenada_horizontal  db 0
    coordenada_vertical    db 0
    posicion               db 0

section     .bss
    ; Datos ingresados por el usuario
    input          resb 1
    input_numerico resb 1

%macro imprimir_error 2
    imprimir_mensaje %1
    jmp %2
%endmacro 

%macro es_coordenada_valida 1

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
        cmp %1, [movimiento_derecha]
        je %%valido
        cmp %1, [movimiento_izquierda]
        je %%valido
        cmp %1, [movimiento_abajo_izquierda]
        je %%valido
        cmp %1, [movimiento_abajo_derecha]
        je %%valido
        jmp %%invalido

    %%es_oficial:
        cmp %1, [movimiento_abajo]
        je %%valido
        cmp %1, [movimiento_derecha]
        je %%valido
        cmp %1, [movimiento_izquierda]
        je %%valido
        cmp %1, [movimiento_abajo_izquierda]
        je %%valido
        cmp %1, [movimiento_abajo_derecha]
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
        jmp .fin

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

%macro calcular_posicion 2
    ; La macro recibe dos parametros: x e y
    ; Al final el resultado de la operación (x-1)*7 + (y-1) se guarda en la variable posicion
    
    mov     al, byte[%1]             
    sub     al, 1             

    imul byte[CANTIDAD_FILAS]       

    mov     bl, byte[%2]             
    sub     bl, 1            

    add     al, bl         

    mov     [posicion], al
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

    mov al, [input]  
    cmp al, 'S'     
    jne procesar_input   

    ; Continuar con la logica de mover_pieza segun el turno
    mov al, [turno]  
    cmp al, 'S'       
    je mover_soldado 
    cmp al, 'O'        
    je mover_oficial 

    ret 

mover_soldado:
    imprimir_mensaje MSG_SOLDADO ; Imprimo mensaje que declara el turno de los soldados y explica los movimeintos posibles

    imprimir_mensaje MSG_COORDENADA_VERTICAL ; Pido la coordenada vertical
    leer_input  ; Leo la coordenada vertical
    
    convertir_caracter_a_numero input ; Convierto la cordenada vertical en un numero
    
    mov al, [input_numerico] ; Paso la coordenada vertical a un registro para poder mandarla a una macro
    es_coordenada_valida al  ; Veo si la coordenada vertical es valida
    
    je .imprimir_error_coordenada ; Si la coordenada vertical es invalida, imprimo el error

    mov al, [input_numerico] ; Paso la coordenada vertical a un registro para poder almacenarla en una variable
    mov [coordenada_horizontal], al ; Almaceno la coordenada vertical en la variable correspondiente

    imprimir_mensaje MSG_COORDENADA_HORIZONTAL ; Pido la coordenada horizontal
    leer_input ; Leo la coordenada horizontal

    convertir_caracter_a_numero input ; Convierto la coordenada horizontal en un numero

    mov al, [input_numerico] ; Paso la coordenada horizontal a un registro para poder mandarla a una macro
    es_coordenada_valida al  ; Veo si la coordenada horizontal es invalida

    je .imprimir_error_coordenada ; Si la coordenada horizontal es invalida, imprimo el error

    mov al, [input_numerico] ; Paso la coordenada horizontal a un registro para poder almacenarla en una variable
    mov [coordenada_vertical], al ; Almaceno la coordenada horizontal en la variable correspondiente

    calcular_posicion coordenada_horizontal, coordenada_vertical ; Calculo el desplazamiento del tablero para llegar al elemento que quiero

    es_posicion_invalida posicion ; Veo si la posicion es invalida

    je .imprimir_error_posicion ; Si la posicion es invalida, imprimo el error

    imprimir_mensaje MSG_MOVIMIENTO ; Pido el movimiento
    leer_input ; Leo el movimiento

    mov al, [input] ; Preparo el movimiento para mandarlo a una macro
    mov bl, 'S' ; Preparo el tipo de pieza para mandarlo a una macro
    es_movimiento_invalido al, bl ; Veo si el movimiento ingresado es valido

    je .imprimir_error_movimiento ; Si el movimiento es invalido, imprimo el error

    jmp .fin

    .imprimir_error_coordenada:
        imprimir_error MSG_ERROR_COORDENADA, procesar_input
        jmp .fin
    
    .imprimir_error_posicion:
        imprimir_error MSG_ERROR_POSICION, procesar_input
        jmp .fin

    .imprimir_error_movimiento:
        imprimir_error MSG_ERROR_MOVIMIENTO, procesar_input
        jmp .fin

    .fin:

    ret

mover_oficial:
    imprimir_mensaje MSG_OFICIAL
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


