section .data
    msg_configuracion db "Redireccion a configuracion exitosa", 10, 0

section .text
establecer_configuracion:
    imprimir_mensaje msg_configuracion

    ret