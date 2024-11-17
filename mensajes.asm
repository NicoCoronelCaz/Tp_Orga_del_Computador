%macro imprimir_mensaje 1
    ; Macro para imprimir un mensaje definido
    mov rdi, %1   ; Carga la dirección del mensaje en RDI
    mPuts         ; Llama a mPuts para imprimir
%endmacro

section     .data
    msg_bienvenida db "Bienvenido a 'El Asalto', juego estrategico del siglo XIX, donde dos oficiales defienden una fortaleza contra un escuadron de 24 soldados. ",10
                db "Objetivo: Los oficiales deben proteger la fortaleza, capturando soldados, mientras los soldados intentan ocupar toda la fortaleza.",10,10
                db "COMANDOS DISPONIBLES:",10
                db "1. Guardar: Puedes guardar la partida actual ingresando 'G'",10
                db "2. Recuperar: Puedes recuperar la partida guardada ingresando 'R'",10
                db "3. Salir: Puedes salir del juego ingresando 'S'",10
                db "4. Mover: Puedes realizar un movimiento de alguna de las piezas del equipo en turno",10,10
                db "OPCIONES DE CONFIGURACION:",10
                db "1. Configuracion predeterminada: Comenzar el juego con las reglas y disposicion clasica.",10
                db "2. Configuracion personalizada: Puedes elegir simbolos para los oficiales y soldados, cambiar la orientacion del tablero y seleccionar quien comienza.",10,10
                db "¿Deseas una configuracion personalizada? (S/N): ",0
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
    msg_estadisticas              db "Estadisticas de la partida...",10,0
    msg_final_partida    db "La partida ha finalizado, nos vemos en el siguiente Asalto",10,0
    msg_soldados_ganan      db "¡Ganaron los soldados!", 10, 0
    msg_oficiales_ganan     db "¡Ganaron los oficiales!",10, 0