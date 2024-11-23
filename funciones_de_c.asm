extern puts
extern gets
extern printf
extern atoi
extern sscanf
extern fopen
extern fclose
extern fprintf
extern fgets

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
    sub     rsp, 8             
    call    atoi               
    add     rsp, 8             
%endmacro

%macro mSscanf 0
    sub     rsp, 8             
    call    sscanf             
    add     rsp, 8            
%endmacro

%macro mFopen 2
    mov     rdi, %1
    mov     rsi, %2
    sub     rsp,8
    call    fopen
    add     rsp,8
%endmacro

%macro mFclose 1
    mov     rdi, %1
    sub     rsp,8
    call    fclose
    add     rsp,8
%endmacro

%macro mFprintf 3
    mov     rdi, %1
    mov     rsi, %2
    mov     rdx, %3
    sub     rsp,8
    call    fprintf
    add     rsp,8
%endmacro

%macro mFgets 3
    mov     rdi, %1
    mov     rsi, %2
    mov     rdx, %3
    sub     rsp,8
    call    fgets
    add     rsp,8
%endmacro