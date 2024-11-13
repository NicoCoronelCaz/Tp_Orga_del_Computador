%include "mensajes.asm"
%include "funciones_de_c.asm"
%include "constantes.asm"
%include "variables.asm"

global main

section     .text
main:
;Idea:
    ;mensaje_inicial
    ;establecer_configuracion (Aca se configuraria la partida ya sea de manera personalizada o predeterminada)
    ;procesar_input (Esta parte procesa el input que recibe del usuario y llama a las macros que corresponden (moverSoldado, guardarPartida, recuperarPartida, salirDelJuego, etc.))
    ;verificar_partida (Si todavia no termino la partida, redirijo a la etiqueta 'main', si no, redirije al fin del programa)
;fin_del_juego: (etiqueta de fin del juego)
    ;mostrar_estadisticas
    ;saludo_final
    mov rdi,msg_bienvenida
    mPuts
ret

