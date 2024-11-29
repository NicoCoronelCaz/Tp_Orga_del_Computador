%macro imprimir_mensaje 1
    ; Macro para imprimir un mensaje definido
    mov rdi, %1   ; Carga la dirección del mensaje en RDI
    mPuts         ; Llama a mPuts para imprimir
%endmacro

section     .data
    msg_bienvenida db "Bienvenido a 'El Asalto', juego estrategico del siglo XIX, donde dos oficiales defienden una fortaleza contra un escuadron de 24 soldados. ",10
                db "Objetivo: Los oficiales deben proteger la fortaleza, capturando soldados, mientras los soldados intentan ocupar toda la fortaleza.",10,10
                db "OPCIONES DE CONFIGURACION:",10
                db "1. Configuracion predeterminada: Comenzar el juego con las reglas y disposicion clasica.",10
                db "2. Configuracion personalizada: Puedes elegir simbolos para los oficiales y soldados, cambiar la orientacion del tablero y seleccionar quien comienza.",10,10
                db "¿Deseas una configuracion personalizada? (S/N): ",0
    msg_menu db "MENÚ PRINCIPAL:",10
                db "¿Qué le gustaría hacer?",10
                db "- Guardar partida actual: ingresar 'G'",10
                db "- Recuperar partida guardada: ingresar 'R'",10
                db "- Salir del juego: ingresar 'S'",10
                db "- Mover alguna de las piezas según el turno correspondiente: ingresar 'M'",10,10,0
    msg_simbolos         db "Ahora ingresara por teclado los simbolos correspondientes a los soldados y a los oficiales, tener en cuenta que puede elegir cualquier caracter excepto los reservados ' ' y '-'. ",10,0
    msg_simboloOficiales db "Ingrese el simbolo de los oficiales: ",10,0
    msg_simboloSoldados  db "Ingrese el simbolo de los soldados: ",10,0
    msg_orientacion      db "OPCIONES DE ORIENTACION DEL TABLERO: ",10
                        db "1. Orientacion predeterminada",10
                        db "2. Rotar 90 grados",10
                        db "3. Rotar 180 grados",10
                        db "4. Rotar 270 grados",10
                        db "Ingrese el numero de la opcion que quiere elegir: ",10,0
    msg_turno            db "Ingrese 'S' si quiere que empiecen los soldados, 'O' si quiere que empiecen los oficiales: ",10,0
    msg_inicio_partida   db "La partida esta lista... Que comience 'El Asalto'",10,0
    msg_guardar_partida  db "Ha guardado la partida correctamente",10,0
    msg_esta_seguro_guardar      db "¿Esta seguro que desea guardar la partida actual? Perdera cualquier partida guardada anteriormente (S/N): ",10,0
    msg_recuperar_partida db "Ha recuperado la partida correctamente",10,0
    msg_esta_seguro_recuperar     db "¿Esta seguro que desea recuperar la partida guardada? Perdera la partida actual (S/N): ",10,0
    msg_estadisticas_oficial1     db "Primer oficial: ",0
    msg_estadisticas_oficial2     db "Segundo oficial: ",0
    msg_final_partida    db "La partida ha finalizado, nos vemos en el siguiente Asalto",10,0
    msg_soldados_ganan db 0x1B, "[31m", "¡Victoria aplastante de los soldados! La fortaleza ha caído.", 0x1B, "[0m", 10, 0
    msg_oficiales_ganan db 0x1B, "[32m", "¡Triunfo estratégico de los oficiales! Los soldados se han rendido.", 0x1B, "[0m", 10, 0

    msg_movimientos_comandos db "COMANDOS DE MOVIMIENTOS:", 10
                    db "W: Mover hacia arriba", 10
                    db "S: Mover hacia abajo", 10
                    db "A: Mover hacia la izquierda", 10
                    db "D: Mover hacia la derecha", 10
                    db "Q: Mover en diagonal hacia arriba e izquierda", 10
                    db "E: Mover en diagonal hacia arriba y derecha", 10
                    db "Z: Mover en diagonal hacia abajo e izquierda", 10
                    db "C: Mover en diagonal hacia abajo y derecha", 10, 0
    msg_tablero_actual db "TABLERO ACTUAL:", 10, 0
    header_movimientos db "ARRIBA | ABAJO | DERECHA | IZQUIERDA", 0

    msg_estadisticas_capturas db "ESTADÍSTICAS DE CAPTURA POR OFICIAL: ",10, 0
    msg_estadisticas_movimientos db "ESTADÍSTICAS DE MOVIMIENTOS POR OFICIAL: ",10, 0
