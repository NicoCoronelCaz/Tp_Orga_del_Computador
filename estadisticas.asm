section .data
	formatoCaptura 	    db ` %i \n\n`,0
	tituloMovimientos1  db ` ARRIBA-IZQ  |   ARRIBA  | ARRIBA-DER `,0
	formatoMovimientos1 db `     %hhi       |     %hhi     |      %hhi     \n`,0
	tituloMovimientos2  db `  IZQUIERDA  |           |   DERECHA  `,0
	formatoMovimientos2 db `     %hhi       |           |      %hhi     \n`,0
	tituloMovimientos3  db ` ABAJO-IZQ   |   ABAJO   |  ABAJO-DER `,0
	formatoMovimientos3 db `     %hhi       |     %hhi     |      %hhi     \n`,0
	separador	    db `--------------------------------------`,0
	separadorFinal	    db `--------------------------------------\n`,0

section .bss

section .text

mostrar_estadisticas:
	; IMPRIMO CAPTURAS
	imprimir_mensaje msg_estadisticas_capturas
	
	imprimir_mensaje msg_estadisticas_oficial1
	xor eax, eax
	mov rdi, formatoCaptura
	movzx esi, byte[primer_oficial_capturas]
	mPrintf
	imprimir_mensaje msg_estadisticas_oficial2
	xor eax, eax
	mov rdi, formatoCaptura
	movzx esi, byte[segundo_oficial_capturas]
	mPrintf

	; IMPRIMO MOVIMIENTOS OFICIAL 1
	imprimir_mensaje msg_estadisticas_movimientos

	imprimir_mensaje msg_estadisticas_oficial1
	imprimir_mensaje separador
	imprimir_mensaje tituloMovimientos1
	xor eax, eax
	mov rdi, formatoMovimientos1
	mov rsi, [primer_oficial_movs_arriba_izq]
	mov rdx, [primer_oficial_movs_arriba]
	mov rcx, [primer_oficial_movs_arriba_der]
	mPrintf
	imprimir_mensaje separador

	imprimir_mensaje tituloMovimientos2
	xor eax, eax
	mov rdi, formatoMovimientos2
	mov rsi, [primer_oficial_movs_izquierda]
	mov rdx, [primer_oficial_movs_derecha]
	mPrintf
	imprimir_mensaje separador

	imprimir_mensaje tituloMovimientos3
	xor eax, eax
	mov rdi, formatoMovimientos3
	mov rsi, [primer_oficial_movs_abajo_izq]
	mov rdx, [primer_oficial_movs_abajo]
	mov rcx, [primer_oficial_movs_abajo_der]
	mPrintf
	imprimir_mensaje separadorFinal

	; IMPRIMO MOVIMIENTOS OFICIAL 2
	imprimir_mensaje msg_estadisticas_oficial2
	imprimir_mensaje separador
	imprimir_mensaje tituloMovimientos1
	xor eax, eax
	mov rdi, formatoMovimientos1
	mov rsi, [segundo_oficial_movs_arriba_izq]
	mov rdx, [segundo_oficial_movs_arriba]
	mov rcx, [segundo_oficial_movs_arriba_der]
	mPrintf
	imprimir_mensaje separador

	imprimir_mensaje tituloMovimientos2
	xor eax, eax
	mov rdi, formatoMovimientos2
	mov rsi, [segundo_oficial_movs_izquierda]
	mov rdx, [segundo_oficial_movs_derecha]
	mPrintf
	imprimir_mensaje separador

	imprimir_mensaje tituloMovimientos3
	xor eax, eax
	mov rdi, formatoMovimientos3
	mov rsi, [segundo_oficial_movs_abajo_izq]
	mov rdx, [segundo_oficial_movs_abajo]
	mov rcx, [segundo_oficial_movs_abajo_der]
	mPrintf
	imprimir_mensaje separadorFinal

	ret