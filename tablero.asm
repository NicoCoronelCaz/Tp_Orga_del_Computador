%macro Puts 1
        mov rdi,%1
        mPuts
%endmacro

%macro Printf 2
        mov rdi,%1
        mov rsi,%2
        mPrintf
%endmacro

global imprimirTablero

section .data
        CANT_COLUMNAS             EQU 7
        LONG_ELEMENTO             EQU 1

        FORTALEZA_DERECHA         EQU '2'
        FORTALEZA_ARRIBA          EQU '3'
        FORTALEZA_IZQUIERDA       EQU '4'

        VERDADERO                 EQU 1
        FALSO                     EQU 0

        REPRESENTACION_NULO       EQU ' '
        REPRESENTACION_SOLDADO    EQU 'X'
        REPRESENTACION_OFICIAL    EQU 'O'
        REPRESENTACION_VACIO      EQU '-'

        formatoComun              db ` %c ║`,0
        formatoFortaleza          db `\e[48;5;238m %c \e[0m║`,0
        formatoSoldadoRojo        db `\e[38;5;9m %c \e[0m║`,0

        espacioVacio              db ` `,0

        coordY1Izq                db `%i         ║`,0
        coordY2Izq                db `%i ║`,0
        coordY3Izq                db `          ║`,0
        coordY4Izq                db `  ║`,0
        coordY1Der                db `          %i`,0
        coordY2Der                db `  %i`,0

        coordenadasX1             db `    1   2   3   4   5   6   7  \n`,0
        coordenadasX2             db `    7   6   5   4   3   2   1  \n`,0
        coordenadasX3             db ``,0
        coordenadasX4             db `\n`,0
        coordenadasX5             db `    1   2   3   4   5   6   7  \n\n`,0
        coordenadasX6             db `    7   6   5   4   3   2   1  \n\n`,0

        pisoAlto                  db   `          ╔═══╦═══╦═══╗        `,0
        entreFila1                db `\n          ╠═══╬═══╬═══╣        `,0
        entreFila2                db `\n  ╔═══╦═══╬═══╬═══╬═══╬═══╦═══╗`,0
        entreFila3                db `\n  ╠═══╬═══╬═══╬═══╬═══╬═══╬═══╣`,0
        entreFila4                db `\n  ╚═══╩═══╬═══╬═══╬═══╬═══╩═══╝`,0
        pisoBajo                  db `\n          ╚═══╩═══╩═══╝        `,0

section .bss
        filaActual                  resb 1
        colActual                   resb 1
        elementoActual              resb 1

        indiceElementoActual        resq 1
        distanciaAlProxElemento     resq 1

        indicePrimerElementoDeFila  resq 1
        distanciaAProxFila          resq 1
        filaAImprimir               resq 1
        distanciaAProxFilaAImprimir resq 1

        ptrCoordXArriba             resq 1
        ptrCoordXAbajo              resq 1

        ptrCoordY1Izq               resq 1
        ptrCoordY2Izq               resq 1
        ptrCoordY1Der               resq 1
        ptrCoordY2Der               resq 1

        ptrFormato                  resq 1
        coordActualCaeEnFortaleza   resq 1
        elementoActualEsSoldadoRojo resq 1

section .text

imprimir_tablero:
        imprimir_mensaje msg_tablero_actual
        sub rsp, 1
        call inicializarSegunOrientacion
        add rsp, 1

        mov rdi, [ptrCoordXArriba]
        mPrintf
        Puts pisoAlto

        imprimirFila:
                cmp byte[filaActual], 8
                je finTablero

                mov rdi, [ptrCoordY1Izq]
                mov rsi, [ptrCoordY2Izq]
                sub rsp,8
                call imprimirCoordenadaY
                add rsp,8

                imprimirElemento:
                        cmp byte[colActual], 8
                        je avanzarFila

                        sub rsp,8
                        call obtenerElemento
                        add rsp,8

                        sub rsp,8
                        call establecerFormato
                        add rsp,8

                        mov al, [indiceElementoActual]
                        add al, [distanciaAlProxElemento]
                        mov [indiceElementoActual], al
                        inc byte[colActual]

                        cmp byte[elementoActual], REPRESENTACION_NULO
                        je imprimirEspacioNulo
                        cmp byte[elementoActual], REPRESENTACION_SOLDADO
                        je imprimirSoldado
                        cmp byte[elementoActual], REPRESENTACION_VACIO
                        je imprimirEspacioVacio
                        cmp byte[elementoActual], REPRESENTACION_OFICIAL
                        je imprimirOficial

                        imprimirEspacioNulo:
                                jmp imprimirElemento

                        imprimirSoldado:
                                Printf [ptrFormato], [soldado]
                                jmp imprimirElemento

                        imprimirEspacioVacio:
                                Printf [ptrFormato], [espacioVacio]
                                jmp imprimirElemento

                        imprimirOficial:
                                Printf [ptrFormato], [oficial]
                                jmp imprimirElemento
                
        avanzarFila:
                mov rdi, [ptrCoordY1Der]
                mov rsi, [ptrCoordY2Der]
                sub rsp,8
                call imprimirCoordenadaY
                add rsp,8

                mov rax, [filaAImprimir]
                add rax, [distanciaAProxFilaAImprimir]
                mov [filaAImprimir], rax

                mov rax, [indicePrimerElementoDeFila]
                add rax, [distanciaAProxFila]
                mov [indicePrimerElementoDeFila], rax
                mov [indiceElementoActual], rax
                inc byte[filaActual]
                mov byte[colActual], 1

                cmp byte[filaActual], 2
                je printEntreFila1
                cmp byte[filaActual], 3
                je printEntreFila2
                cmp byte[filaActual], 5
                jle printEntreFila3
                cmp byte[filaActual], 6
                je printEntreFila4
                cmp byte[filaActual], 8
                je imprimirFila
                
                printEntreFila1:
                        Puts entreFila1
                        jmp imprimirFila
                        
                printEntreFila2:
                        Puts entreFila2
                        jmp imprimirFila

                printEntreFila3:
                        Puts entreFila3
                        jmp imprimirFila

                printEntreFila4:
                        Puts entreFila4
                        jmp imprimirFila

        finDeFila:
                inc byte[filaActual]
                jmp imprimirFila

inicializarSegunOrientacion:
        mov byte[filaActual], 1
        mov byte[colActual], 1

        cmp byte[orientacion], FORTALEZA_DERECHA
        je inicializarConFortalezaDerecha
        cmp byte[orientacion], FORTALEZA_ARRIBA
        je inicializarConFortalezaArriba
        cmp byte[orientacion], FORTALEZA_IZQUIERDA
        je inicializarConFortalezaIzquierda

        inicializarConFortalezaAbajo:
                lea rax, [coordenadasX1]
                mov [ptrCoordXArriba], rax
                lea rax, [coordenadasX4]
                mov [ptrCoordXAbajo], rax

                lea rax, [coordY1Izq]
                mov [ptrCoordY1Izq], rax
                lea rax, [coordY2Izq]
                mov [ptrCoordY2Izq], rax

                lea rax, [espacioVacio]
                mov [ptrCoordY1Der], rax
                mov [ptrCoordY2Der], rax

                mov qword[filaAImprimir], 1
                mov qword[distanciaAProxFilaAImprimir], 1

                mov qword[indiceElementoActual], 0
                mov qword[indicePrimerElementoDeFila], 0
                mov qword[distanciaAlProxElemento], 1
                mov qword[distanciaAProxFila], 7
                jmp finInicializarSegunOrientacion

        inicializarConFortalezaIzquierda:
                lea rax, [coordenadasX2]
                mov [ptrCoordXArriba], rax
                lea rax, [coordenadasX4]
                mov [ptrCoordXAbajo], rax

                lea rax, [coordY1Der]
                mov [ptrCoordY1Der], rax
                lea rax, [coordY2Der]
                mov [ptrCoordY2Der], rax

                lea rax, [coordY3Izq]
                mov [ptrCoordY1Izq], rax
                lea rax, [coordY4Izq]
                mov [ptrCoordY2Izq], rax

                mov qword[filaAImprimir], 1
                mov qword[distanciaAProxFilaAImprimir], 1

                mov qword[indiceElementoActual], 42
                mov qword[indicePrimerElementoDeFila], 42
                mov qword[distanciaAlProxElemento], -7
                mov qword[distanciaAProxFila], 1
                jmp finInicializarSegunOrientacion

        inicializarConFortalezaDerecha:
                lea rax, [coordenadasX3]
                mov [ptrCoordXArriba], rax
                lea rax, [coordenadasX5]
                mov [ptrCoordXAbajo], rax

                lea rax, [coordY1Izq]
                mov [ptrCoordY1Izq], rax
                lea rax, [coordY2Izq]
                mov [ptrCoordY2Izq], rax

                lea rax, [espacioVacio]
                mov [ptrCoordY1Der], rax
                mov [ptrCoordY2Der], rax

                mov qword[filaAImprimir], 7
                mov qword[distanciaAProxFilaAImprimir], -1

                mov qword[indiceElementoActual], 6
                mov qword[indicePrimerElementoDeFila], 6
                mov qword[distanciaAlProxElemento], 7
                mov qword[distanciaAProxFila], -1
                jmp finInicializarSegunOrientacion

        inicializarConFortalezaArriba:
                lea rax, [coordenadasX3]
                mov [ptrCoordXArriba], rax
                lea rax, [coordenadasX6]
                mov [ptrCoordXAbajo], rax

                lea rax, [coordY1Der]
                mov [ptrCoordY1Der], rax
                lea rax, [coordY2Der]
                mov [ptrCoordY2Der], rax

                lea rax, [coordY3Izq]
                mov [ptrCoordY1Izq], rax
                lea rax, [coordY4Izq]
                mov [ptrCoordY2Izq], rax

                mov qword[filaAImprimir], 7
                mov qword[distanciaAProxFilaAImprimir], -1

                mov qword[indiceElementoActual], 48
                mov qword[indicePrimerElementoDeFila], 48
                mov qword[distanciaAlProxElemento], -1
                mov qword[distanciaAProxFila], -7

        finInicializarSegunOrientacion:
                ret

imprimirCoordenadaY:
        cmp byte[filaActual], 2
        jle printCoordY1
        cmp byte[filaActual], 5
        jle printCoordY2

        printCoordY1:
                Printf rdi, [filaAImprimir]
                jmp finImprimirCoordenadaY

        printCoordY2:
                Printf rsi, [filaAImprimir]
                jmp finImprimirCoordenadaY

        Printf rdi, [filaAImprimir]

        finImprimirCoordenadaY:
                ret

obtenerElemento:
        mov rax, tablero
        add rax, [indiceElementoActual]
        imul rax, LONG_ELEMENTO
        mov bl, [rax]
        mov [elementoActual], bl
        ret


establecerFormato:
        sub rsp,8
        call verificarCoordEnFortaleza
        add rsp,8

        sub rsp,8
        call verificarSoldadoRojo
        add rsp,8

        cmp qword[coordActualCaeEnFortaleza], VERDADERO
        je cambiarAFormatoDeFortaleza

        cmp qword[elementoActualEsSoldadoRojo], VERDADERO
        je cambiarAFormatoDeSoldadoRojo

        mov rax, formatoComun
        mov [ptrFormato], rax
        jmp finEstablecerFormato

        cambiarAFormatoDeFortaleza:
                mov rax, formatoFortaleza
                mov [ptrFormato], rax
                jmp finEstablecerFormato

        cambiarAFormatoDeSoldadoRojo:
                mov rax, formatoSoldadoRojo
                mov [ptrFormato], rax
        
        finEstablecerFormato:
                ret

verificarCoordEnFortaleza:
        mov qword[coordActualCaeEnFortaleza], FALSO

        cmp byte[orientacion], FORTALEZA_DERECHA
        je formatoFortalezaDerecha
        cmp byte[orientacion], FORTALEZA_ARRIBA
        je formatoFortalezaArriba
        cmp byte[orientacion], FORTALEZA_IZQUIERDA
        je formatoFortalezaIzquierda

        formatoFortalezaAbajo:
                cmp byte[colActual], 3
                je verificarFilasDeFortalezaAbajo
                cmp byte[colActual], 4
                je verificarFilasDeFortalezaAbajo
                cmp byte[colActual], 5
                je verificarFilasDeFortalezaAbajo
                jmp finDeVerificacionDeFortaleza

                verificarFilasDeFortalezaAbajo:
                        cmp byte[filaActual], 5
                        je confirmarCoordEnFortaleza
                        cmp byte[filaActual], 6
                        je confirmarCoordEnFortaleza
                        cmp byte[filaActual], 7
                        je confirmarCoordEnFortaleza
                        jmp finDeVerificacionDeFortaleza

        formatoFortalezaDerecha:
                cmp byte[colActual], 5
                je verificarFilasDeFortalezaDerecha
                cmp byte[colActual], 6
                je verificarFilasDeFortalezaDerecha
                cmp byte[colActual], 7
                je verificarFilasDeFortalezaDerecha
                jmp finDeVerificacionDeFortaleza

                verificarFilasDeFortalezaDerecha:
                        cmp byte[filaActual], 3
                        je confirmarCoordEnFortaleza
                        cmp byte[filaActual], 4
                        je confirmarCoordEnFortaleza
                        cmp byte[filaActual], 5
                        je confirmarCoordEnFortaleza
                        jmp finDeVerificacionDeFortaleza

        formatoFortalezaArriba:
                cmp byte[colActual], 3
                je verificarFilasDeFortalezaArriba
                cmp byte[colActual], 4
                je verificarFilasDeFortalezaArriba
                cmp byte[colActual], 5
                je verificarFilasDeFortalezaArriba
                jmp finDeVerificacionDeFortaleza

                verificarFilasDeFortalezaArriba:
                        cmp byte[filaActual], 1
                        je confirmarCoordEnFortaleza
                        cmp byte[filaActual], 2
                        je confirmarCoordEnFortaleza
                        cmp byte[filaActual], 3
                        je confirmarCoordEnFortaleza
                        jmp finDeVerificacionDeFortaleza

        formatoFortalezaIzquierda:
                cmp byte[colActual], 1
                je verificarFilasDeFortalezaIzquierda
                cmp byte[colActual], 2
                je verificarFilasDeFortalezaIzquierda
                cmp byte[colActual], 3
                je verificarFilasDeFortalezaIzquierda
                jmp finDeVerificacionDeFortaleza

                verificarFilasDeFortalezaIzquierda:
                        cmp byte[filaActual], 3
                        je confirmarCoordEnFortaleza
                        cmp byte[filaActual], 4
                        je confirmarCoordEnFortaleza
                        cmp byte[filaActual], 5
                        je confirmarCoordEnFortaleza
                        jmp finDeVerificacionDeFortaleza

        confirmarCoordEnFortaleza:
                mov qword[coordActualCaeEnFortaleza], VERDADERO

        finDeVerificacionDeFortaleza:
                ret

verificarSoldadoRojo:
        mov qword[elementoActualEsSoldadoRojo], FALSO

        cmp byte[elementoActual], REPRESENTACION_SOLDADO
        je verificarCoordSoldadoRojo
        jmp finDeVerificacionSoldadoRojo

        verificarCoordSoldadoRojo:
                cmp byte[orientacion], FORTALEZA_DERECHA
                je formatoSoldadoConFortalezaDerecha
                cmp byte[orientacion], FORTALEZA_ARRIBA
                je formatoSoldadoConFortalezaArriba
                cmp byte[orientacion], FORTALEZA_IZQUIERDA
                je formatoSoldadoConFortalezaIzquierda
                                
                formatoSoldadoConFortalezaAbajo:
                        cmp byte[colActual], 1
                        je verificarFilasDeSoldadoConFortalezaAbajo

                        cmp byte[colActual], 2
                        je verificarFilasDeSoldadoConFortalezaAbajo

                        cmp byte[colActual], 6
                        je verificarFilasDeSoldadoConFortalezaAbajo

                        cmp byte[colActual], 7
                        je verificarFilasDeSoldadoConFortalezaAbajo
                        jmp finDeVerificacionSoldadoRojo

                        verificarFilasDeSoldadoConFortalezaAbajo:
                                cmp byte[filaActual], 5
                                je confirmarCoordSoldadoRojo
                                jmp finDeVerificacionSoldadoRojo

                formatoSoldadoConFortalezaDerecha:
                        cmp byte[colActual], 5
                        je verificarFilasDeSoldadoConFortalezaDerecha
                        jmp finDeVerificacionSoldadoRojo

                        verificarFilasDeSoldadoConFortalezaDerecha:
                                cmp byte[filaActual], 1
                                je confirmarCoordSoldadoRojo

                                cmp byte[filaActual], 2
                                je confirmarCoordSoldadoRojo

                                cmp byte[filaActual], 6
                                je confirmarCoordSoldadoRojo

                                cmp byte[filaActual], 7
                                je confirmarCoordSoldadoRojo
                                jmp finDeVerificacionSoldadoRojo
                                
                formatoSoldadoConFortalezaArriba:
                        cmp byte[colActual], 1
                        je verificarFilasDeSoldadoConFortalezaArriba

                        cmp byte[colActual], 2
                        je verificarFilasDeSoldadoConFortalezaArriba

                        cmp byte[colActual], 6
                        je verificarFilasDeSoldadoConFortalezaArriba

                        cmp byte[colActual], 7
                        je verificarFilasDeSoldadoConFortalezaArriba
                        jmp finDeVerificacionSoldadoRojo

                        verificarFilasDeSoldadoConFortalezaArriba:
                                cmp byte[filaActual], 3
                                je confirmarCoordSoldadoRojo
                                jmp finDeVerificacionSoldadoRojo

                formatoSoldadoConFortalezaIzquierda:
                        cmp byte[colActual], 3
                        je verificarFilasDeSoldadoConFortalezaIzquierda
                        jmp finDeVerificacionSoldadoRojo

                        verificarFilasDeSoldadoConFortalezaIzquierda:
                                cmp byte[filaActual], 1
                                je confirmarCoordSoldadoRojo

                                cmp byte[filaActual], 2
                                je confirmarCoordSoldadoRojo

                                cmp byte[filaActual], 6
                                je confirmarCoordSoldadoRojo

                                cmp byte[filaActual], 7
                                je confirmarCoordSoldadoRojo
                                jmp finDeVerificacionSoldadoRojo

        confirmarCoordSoldadoRojo:
                mov qword[elementoActualEsSoldadoRojo], VERDADERO
        
        finDeVerificacionSoldadoRojo:
                ret

finTablero:
        Puts pisoBajo
        mov rdi, [ptrCoordXAbajo]
        mPrintf
        ret