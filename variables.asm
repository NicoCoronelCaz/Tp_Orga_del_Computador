section .data
    soldado db 'X'      ; Simbolo del soldado
    oficial db 'O'      ; Simbolo del oficial
    primer_oficial_posicion db 31 ; Posicion del oficial de la izquierda
    primer_oficial_capturas db 0 ; Cantidad de soldados capturados por el oficial de la izquierda
    primer_oficial_movimientos db 0 ; Cantidad de movimientos hechos por el oficial de la izquierda
    segundo_oficial_posicion db 30 ; Posicion del oficial de la derecha
    segundo_oficial_capturas db 0 ; Cantidad de soldados capturados por el oficial de la derecha
    segundo_oficial_movimientos db 0 ; Cantidad de movimientos hechos por el oficial de la derecha
    turno   db  0       ; O si es turno de los soldados, 1 si es turno de los oficiales
    orientacion db '1'  ; 1 si no roto, 2 si roto 90 grados, 3 si roto 180 grados y 4 si roto 270 grados
    estado_partida db 0 ; 0 si la partida continua, 1 si no
    tablero db ' ', ' ', 'X', 'X', 'X', ' ', ' '        
        db ' ', ' ', 'X', 'X', 'X', ' ', ' ' 
        db 'X', 'X', 'X', 'X', 'X', 'X', 'X' 
        db 'X', 'X', 'X', 'X', 'X', 'X', 'X' 
        db 'X','X', '-', '-', '-', 'X', 'X'
        db ' ',' ', '-', '-', 'O', ' ', ' '
        db ' ',' ', 'O', '-', '-', ' ', ' '
section .bss
    partida_actual      times 49 resb 1
    partida_guardada    times 49 resb 1
