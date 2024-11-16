section .data
    msg_verificar_partida db "Redireccion a verificar partida exitosa", 10, 0

section .text
verificar_partida:
    imprimir_mensaje msg_verificar_partida

    ; Esto es como para simular una comparacion que realizaria verificar partida, 
    ; dependiendo de si continua o no, verificar_partida settearia el flag que corresponnde.
    mov rax, 11        
    mov rbx, 10       

    cmp rax, rbx

    ret