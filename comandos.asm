section     .data
    msg_comando db "Ingrese un comando",0
    msg_guardar db "¿Está seguro que desea guardar la partida? Perderá la partida guardada anteriormente. (S/N):",0
    msg_recuperar db "¿Está seguro que desea recuperar la partida guardada? Perderá el progreso de la partida actual. (S/N):",0
    msg_mover db "¿Está seguro que desea mover una pieza? Una vez iniciada esta accion, no puede detenerse. (S/N): ",0
    msg_salir db "¿Está seguro que desea salir? Perderá todo su progreso. (S/N): ",0
    msg_soldado db "Redirigio a mover soldado",0
    msg_oficial db "Redirigio a mover oficial",0
    msg_error_coordenada db "La coordenada ingresada es invalida, recordar que debe ser un numero entre 1 y 7",0
    msg_error_posicion db "La posicion ingresada es invalida, las coordenadas deben estar dentro del tablero",0
    msg_coordenada_horizontal db "Ingrese la coordenada horizontal: ",0
    msg_coordenada_vertical db "Ingrese la coordenada vertical: ",0
    COMANDO_MOVER          db "M",0
    COMANDO_GUARDAR        db "G",0
    COMANDO_RECUPERAR      db "R",0
    COMANDO_SALIR          db "S",0
    desplazamiento         db 0
    posiciones_validas     db 2,3,4,9,10,11,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,37,38,39,44,45,46
    cantidad_filas         db 7
    coordenada_horizontal  db 0
    coordenada_vertical    db 0
    posicion               db 0

section     .bss
    input resb 1
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
    mov     rsi, posiciones_validas   ; Cargar la dirección de la lista de posiciones válidas
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

    imul byte[cantidad_filas]       

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
    imprimir_mensaje msg_comando
    
    leer_input

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
    imprimir_mensaje msg_recuperar

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
    imprimir_mensaje msg_mover

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
    imprimir_mensaje msg_soldado

    imprimir_mensaje msg_coordenada_vertical
    leer_input
    
    convertir_caracter_a_numero input
    
    mov al, [input_numerico]
    es_coordenada_valida al
    
    je .imprimir_error_coordenada

    ; Almaceno la coordenada horizontal en la variable correspondiente
    mov al, [input_numerico]
    mov [coordenada_horizontal], al

    imprimir_mensaje msg_coordenada_horizontal
    leer_input

    convertir_caracter_a_numero input

    mov al, [input_numerico]
    es_coordenada_valida al

    je .imprimir_error_coordenada

    ; Almaceno la coordenada vertical en la variable correspondiente
    mov al, [input_numerico]
    mov [coordenada_vertical], al

    calcular_posicion coordenada_horizontal, coordenada_vertical

    es_posicion_invalida posicion

    je .imprimir_error_posicion 

    jmp .fin

    .imprimir_error_coordenada:
        imprimir_error msg_error_coordenada, procesar_input
        jmp .fin
    
    .imprimir_error_posicion:
        imprimir_error msg_error_posicion, procesar_input


    .fin:

    ret

mover_oficial:
    imprimir_mensaje msg_oficial
    ret
    
salir_del_juego:
    imprimir_mensaje msg_salir

    leer_input

    ; Si el usuario confirmo la salida, redirijo a fin_del_juego
    mov     al, [input]
    cmp     al, 'S'
    je fin_del_juego

    ; Si no es 'S', vuelve al procesamiento de input
    jmp procesar_input


