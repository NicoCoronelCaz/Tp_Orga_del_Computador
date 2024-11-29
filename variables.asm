section .data
    primer_oficial_posicion db 44 ; Posicion del oficial de la izquierda
    primer_oficial_capturas db 0 ; Cantidad de soldados capturados por el oficial de la izquierda
    primer_oficial_movimientos db 0 ; Cantidad de movimientos hechos por el oficial de la izquierda

    primer_oficial_movs_abajo_izq  db 0 ; Cantidad de movimientos hacia abajo-izquierda hechos por el oficial de la izquierda
    primer_oficial_movs_abajo      db 0 ; Cantidad de movimientos hacia abajo hechos por el oficial de la izquierda
    primer_oficial_movs_abajo_der  db 0 ; Cantidad de movimientos hacia abajo-derecha hechos por el oficial de la izquierda
    primer_oficial_movs_arriba_izq db 0 ; Cantidad de movimientos hacia arriba-izquierda hechos por el oficial de la izquierda
    primer_oficial_movs_arriba     db 0 ; Cantidad de movimientos hacia arriba hechos por el oficial de la izquierda
    primer_oficial_movs_arriba_der db 0 ; Cantidad de movimientos hacia arriba-derecha hechos por el oficial de la izquierda
    primer_oficial_movs_derecha    db 0 ; Cantidad de movimientos hacia la derecha hechos por el oficial de la izquierda
    primer_oficial_movs_izquierda  db 0 ; Cantidad de movimientos hacia la izquierda hechos por el oficial de la izquierda

    segundo_oficial_posicion db 39 ; Posicion del oficial de la derecha
    segundo_oficial_capturas db 0 ; Cantidad de soldados capturados por el oficial de la derecha
    segundo_oficial_movimientos db 0 ; Cantidad de movimientos hechos por el oficial de la derecha

    segundo_oficial_movs_abajo_izq  db 0 ; Cantidad de movimientos hacia abajo-izquierda hechos por el oficial de la derecha
    segundo_oficial_movs_abajo      db 0 ; Cantidad de movimientos hacia abajo hechos por el oficial de la derecha
    segundo_oficial_movs_abajo_der  db 0 ; Cantidad de movimientos hacia abajo-derecha hechos por el oficial de la derecha
    segundo_oficial_movs_arriba_izq db 0 ; Cantidad de movimientos hacia arriba-izquierda hechos por el oficial de la derecha
    segundo_oficial_movs_arriba     db 0 ; Cantidad de movimientos hacia arriba hechos por el oficial de la derecha
    segundo_oficial_movs_arriba_der db 0 ; Cantidad de movimientos hacia arriba-derecha hechos por el oficial de la derecha
    segundo_oficial_movs_derecha    db 0 ; Cantidad de movimientos hacia la derecha hechos por el oficial de la derecha
    segundo_oficial_movs_izquierda  db 0 ; Cantidad de movimientos hacia la izquierda hechos por el oficial de la derecha

    turno   db  'S'       ; S si es turno de los soldados, O si es turno de los oficiales
    orientacion db '1'  ; 1 si no roto, 2 si roto 90 grados, 3 si roto 180 grados y 4 si roto 270 grados
    estado_partida db 0 ; 0 si la partida continua, 1 si no

    tablero db ' ', ' ', 'X', 'X', 'X', ' ', ' '        
            db ' ', ' ', 'X', 'X', 'X', ' ', ' ' 
            db 'X', 'X', 'X', 'X', 'X', 'X', 'X' 
            db 'X', 'X', 'X', 'X', 'X', 'X', 'X' 
            db 'X', 'X', '-', '-', '-', 'X', 'X'
            db ' ', ' ', '-', '-', 'O', ' ', ' '
            db ' ', ' ', 'O', '-', '-', ' ', ' '

    soldado db 'X'      ; Simbolo del soldado
    oficial db 'O'      ; Simbolo del oficial