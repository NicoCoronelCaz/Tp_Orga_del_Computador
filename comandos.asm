section     .data
    msg_comando db "Ingrese un comando",0
    msg_guardar db "¿Está seguro que desea guardar la partida? Perderá la partida guardada anteriormente. (S/N):",0
    msg_recuperar db "¿Está seguro que desea recuperar la partida guardada? Perderá el progreso de la partida actual. (S/N):",0
    msg_mover db "¿Está seguro que desea mover una pieza? Una vez iniciada esta accion, no puede detenerse. (S/N): ",0
    msg_salir db "¿Está seguro que desea salir? Perderá todo su progreso. (S/N): ",0
    msg_soldado db "Redirigio a mover soldado",0
    msg_oficial db "Redirigio a mover oficial",0
    COMANDO_MOVER          db "M",0
    COMANDO_GUARDAR        db "G",0
    COMANDO_RECUPERAR      db "R",0
    COMANDO_SALIR          db "S",0
    desplazamiento         db 0

section     .bss
    input resb 1

%macro comparar_comando 2
    ; Compara el input ingresado con el comando dado
    mov rsi, input        ; Carga el comando ingresado
    mov rdi, %1             ; Carga el comando a comparar
    mov rcx, 1              
    repe cmpsb              ; Compara los dos strings

    je %2                   ; Si son iguales, salta a la etiqueta proporcionada
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

    ; Continuar con la lógica de mover_pieza según el turno
    mov al, [turno]  
    cmp al, 0       
    je mover_soldado 
    cmp al, 1        
    je mover_oficial 

    ret 

mover_soldado:
    imprimir_mensaje msg_soldado
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