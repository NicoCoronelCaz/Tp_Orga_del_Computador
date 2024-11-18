section .data
    primer_oficial_posicion_guardada db 31 ; Posicion del oficial de la izquierda
    primer_oficial_capturas_guardada db 0 ; Cantidad de soldados capturados por el oficial de la izquierda
    primer_oficial_movimientos_guardada db 0 ; Cantidad de movimientos hechos por el oficial de la izquierda
    segundo_oficial_posicion_guardada db 30 ; Posicion del oficial de la derecha
    segundo_oficial_capturas_guardada db 0 ; Cantidad de soldados capturados por el oficial de la derecha
    segundo_oficial_movimientos_guardada db 0 ; Cantidad de movimientos hechos por el oficial de la derecha
    turno_guardada   db  0       ; O si es turno de los soldados, 1 si es turno de los oficiales
    
    tablero_guardado db ' ', ' ', 'X', 'X', 'X', ' ', ' '        
        db ' ', ' ', 'X', 'X', 'X', ' ', ' ' 
        db 'X', 'X', 'X', 'X', 'X', 'X', 'X' 
        db 'X', 'X', 'X', 'X', 'X', 'X', 'X' 
        db 'X','X', '-', '-', '-', 'X', 'X'
        db ' ',' ', '-', '-', 'O', ' ', ' '
        db ' ',' ', 'O', '-', '-', ' ', ' '
