section .data
    primer_oficial_posicion_guardado db 31 ; Posicion del oficial de la izquierda
    primer_oficial_capturas_guardado db 0 ; Cantidad de soldados capturados por el oficial de la izquierda
    primer_oficial_movimientos_guardado db 0 ; Cantidad de movimientos hechos por el oficial de la izquierda
    segundo_oficial_posicion_guardado db 30 ; Posicion del oficial de la derecha
    segundo_oficial_capturas_guardado db 0 ; Cantidad de soldados capturados por el oficial de la derecha
    segundo_oficial_movimientos_guardado db 0 ; Cantidad de movimientos hechos por el oficial de la derecha
    turno_guardado   db  0       ; O si es turno de los soldados, 1 si es turno de los oficiales

section .bss
    partida_guardada    times 49 resb 1