extern puts
extern gets
extern printf
extern atoi
extern sscanf


%macro mPuts 0
    sub     rsp,8
    call    puts
    add     rsp,8
%endmacro

%macro mGets 0
    sub     rsp,8
    call    gets
    add    rsp,8
%endmacro

%macro mPrintf 0
    sub     rsp,8
    call    printf
    add     rsp,8
%endmacro

%macro mAtoi 0
    sub     rsp, 8             ; Alineación de la pila antes de llamar
    call    atoi               ; Llamamos a atoi
    add     rsp, 8             ; Restauramos la pila después de la llamada
%endmacro

%macro mSscanf 0
    sub     rsp, 8             ; Alineación de la pila antes de llamar
    call    sscanf               ; Llamamos a atoi
    add     rsp, 8             ; Restauramos la pila después de la llamada
%endmacro