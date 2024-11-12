%include "mensajes.asm"
%include "funciones_de_c.asm"
%include "constantes.asm"
%include "variables.asm"

global juego

section     .text
juego:
;Idea:
    ;procesar_input (Esta parte procesa el input que recibe del usuario y llama a las macros que corresponden (moverSoldado, guardarPartida, recuperarPartida, salirDelJuego, etc.))
    ;verificar_partida (Si no termino ejecutaria nuevamente la etiqueta 'juego', si no redirige al fin del programa)
;fin_del_juego: (etiqueta de fin del juego)
    ;mostrar_estadisticas
    ;saludo_final
    mov rdi,msg_bienvenida
    mPuts
ret

