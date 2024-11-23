section .data
        LONG_ELEMENTO      EQU 1

        msg_error_al_abrir_archivo  db "Error al abrir el archivo, la partida no se pudo guardar/recuperar.",0
        msg_ingresar_nombre_archivo db "Ingresar el nombre del archivo:",0

        modoEscritura       db "w+",0
        modoLectura         db "r",0

        tituloTablero       db `TABLERO:\n`,0
        tituloEstadistica1  db `ESTADISTICAS DE PRIMER OFICIAL (Posicion, Capturas, #Movimientos):\n`,0
        tituloEstadistica2  db `ESTADISTICAS DE SEGUNDO OFICIAL (Posicion, Capturas, #Movimientos):\n`,0
        tituloConfig        db `CONFIGURACION DE PARTIDA (Turno, Orientacion, simbolo oficial, simbolo soldado):\n`,0

        formatoNumero       db "%hhi,",0
        formatoCaracter     db "%c,",0
        formatoString       db "%s",0
        saltoDeLinea        db `\n`,0

        lineaDeEstadistica  db `%hhi,%hhi,%hhi,`,0
        lineaDeConfig       db `%c,%c,%c,%c,`,0

section .bss
        ptrArchivo                  resq 1
        nombreArchivo               resb 100
        lineaLeida                  resb 100
        elementoLeido               resb 1

        elementoActualTablero       resb 1
        indiceElementoActualTablero resq 1
        cantFilasCopiadas           resb 1
        cantElementosCopiadosEnFila resb 1

section .text

guardarPartida:
        sub rsp, 8
        call pedirNombreDeArchivo
        add rsp, 8

        mFopen nombreArchivo, modoEscritura
        cmp rax, 0
        jle errorDeApertura

        mov qword[ptrArchivo], rax
        mov qword[indiceElementoActualTablero], 0
        mov byte[cantFilasCopiadas], 0
        mov byte[cantElementosCopiadosEnFila], 0

        mFprintf [ptrArchivo], formatoString, tituloTablero
        guardarFilaTablero:
                cmp byte[cantFilasCopiadas],7
                je guardarEstadisticas

                guardarElemento:
                        cmp byte[cantElementosCopiadosEnFila], 7
                        je avanzarFilaDeTablero

                        sub rsp, 8
                        call obtenerElementoDeTablero
                        add rsp, 8
                        mFprintf [ptrArchivo], formatoCaracter, [elementoActualTablero]

                        inc qword[indiceElementoActualTablero]
                        inc byte[cantElementosCopiadosEnFila]
                        jmp guardarElemento

                avanzarFilaDeTablero:
                        mFprintf [ptrArchivo], formatoString, saltoDeLinea
                        mov byte[cantElementosCopiadosEnFila], 0
                        inc byte[cantFilasCopiadas]

                jmp guardarFilaTablero

        guardarEstadisticas:
                mFprintf [ptrArchivo], formatoString, tituloEstadistica1
                mFprintf [ptrArchivo], formatoNumero, [primer_oficial_posicion]
                mFprintf [ptrArchivo], formatoNumero, [primer_oficial_capturas]
                mFprintf [ptrArchivo], formatoNumero, [primer_oficial_movimientos]
                mFprintf [ptrArchivo], formatoString, saltoDeLinea
 
                mFprintf [ptrArchivo], formatoString, tituloEstadistica2
                mFprintf [ptrArchivo], formatoNumero, [segundo_oficial_posicion]
                mFprintf [ptrArchivo], formatoNumero, [segundo_oficial_capturas]
                mFprintf [ptrArchivo], formatoNumero, [segundo_oficial_movimientos]
                mFprintf [ptrArchivo], formatoString, saltoDeLinea

        guardarConfiguracion:
                mFprintf [ptrArchivo], formatoString, tituloConfig
                mFprintf [ptrArchivo], formatoCaracter, [turno]
                mFprintf [ptrArchivo], formatoCaracter, [orientacion]
                mFprintf [ptrArchivo], formatoCaracter, [soldado]
                mFprintf [ptrArchivo], formatoCaracter, [oficial]
                mFprintf [ptrArchivo], formatoString, saltoDeLinea

        mFclose [ptrArchivo]
        mov rdi, msg_guardar_partida
        mPuts
        jmp finGuardarRecuperar

recuperarPartida:
        sub rsp, 8
        call pedirNombreDeArchivo
        add rsp, 8

        mFopen nombreArchivo, modoLectura
        cmp rax, 0
        jle errorDeApertura

        mov qword[ptrArchivo], rax
        mov qword[indiceElementoActualTablero], 0
        mov byte[cantElementosCopiadosEnFila], 0

        mFgets lineaLeida, 100, [ptrArchivo]     ; ---> Titulo leido
        recuperarTablero:
        cmp qword[indiceElementoActualTablero], 48
        jg recuperarEstadisticas

        recuperarFilaTablero:
                cmp byte[cantElementosCopiadosEnFila], 7
                je leerProximaFila

                mFgets elementoLeido, 2, [ptrArchivo]   ; ---> Leo elemento

                sub rsp, 8
                call guardarElementoEnTablero
                add rsp, 8
                
                mFgets elementoLeido, 2, [ptrArchivo]   ; ---> Leo coma
                inc qword[indiceElementoActualTablero]
                inc byte[cantElementosCopiadosEnFila]

                jmp recuperarTablero

        leerProximaFila:
                mFgets elementoLeido, 2, [ptrArchivo]   ; ---> Leo salto de linea
                mov byte[cantElementosCopiadosEnFila], 0
                jmp recuperarTablero

        recuperarEstadisticas:
                mFgets elementoLeido, 2, [ptrArchivo]
                mFgets lineaLeida, 100, [ptrArchivo] ; ---> Titulo leido
                mFgets lineaLeida, 100, [ptrArchivo]
                mov rdi, lineaLeida
                mov rsi, lineaDeEstadistica
                mov rdx, primer_oficial_posicion
                mov rcx, primer_oficial_capturas
                mov r8, primer_oficial_movimientos
                mSscanf

                mFgets lineaLeida, 100, [ptrArchivo] ; ---> Titulo leido
                mFgets lineaLeida, 100, [ptrArchivo]
                mov rdi, lineaLeida
                mov rsi, lineaDeEstadistica
                mov rdx, segundo_oficial_posicion
                mov rcx, segundo_oficial_capturas
                mov r8, segundo_oficial_movimientos
                mSscanf

        recuperarConfiguracion:
                mFgets lineaLeida, 100, [ptrArchivo] ; ---> Titulo leido
                mFgets lineaLeida, 100, [ptrArchivo]
                mov rdi, lineaLeida
                lea rsi, lineaDeConfig
                mov rdx, turno
                mov rcx, orientacion
                mov r8, soldado
                mov r9, oficial
                mSscanf

        mFclose [ptrArchivo]
        mov rdi, msg_recuperar_partida
        mPuts
        jmp finGuardarRecuperar


pedirNombreDeArchivo:
        mov rdi, msg_ingresar_nombre_archivo
        mPuts
        mov rdi, nombreArchivo
        mGets
        ret

obtenerElementoDeTablero:
        mov rax, tablero
        add rax, [indiceElementoActualTablero]
        imul rax, LONG_ELEMENTO
        mov bl, [rax]
        mov [elementoActualTablero], bl
        ret

guardarElementoEnTablero: ; ----> aca esta el problema
        mov rax, tablero
        add rax, [indiceElementoActualTablero]
        imul rax, LONG_ELEMENTO
        mov bl, [elementoLeido]
        mov [rax], bl
        ret

errorDeApertura:
        mov rdi, msg_error_al_abrir_archivo
        mPuts

finGuardarRecuperar:
        ret