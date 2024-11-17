section .data
    msg_imprimir_tablero db "Redireccion a imprimir tablero exitosa", 10, 0

section .text
imprimir_tablero:

    imprimir_mensaje msg_imprimir_tablero

    ret