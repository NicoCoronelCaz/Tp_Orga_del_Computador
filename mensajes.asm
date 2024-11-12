section     .data
    msg_bienvenida db "Bienvenido a 'El Asalto', juego estrategico del siglo XIX, donde dos oficiales defienden una fortaleza contra un escuadron de 24 soldados. ",10
                db "Objetivo: Los oficiales deben proteger la fortaleza, capturando soldados, mientras los soldados intentan ocupar toda la fortaleza.",10,10
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
    msg_esta_seguro      db "¿Esta seguro que desea guardar la partida actual? Perdera cualquier partida guardada anteriormente (S/N): ",10,0
    msg_final_partida    db "La partida ha finalizado, nos vemos en el siguiente Asalto",10,0
    msg_invalido         db "Opcion invalida, ingrese una opcion valida",10,0
