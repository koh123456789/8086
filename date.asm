.MODEL SMALL
.STACK 100
.DATA

output db      "The current date is: "
date db      "00/00/0000", 0dh, 0ah
    db      "The current time is: "
time db      "00:00:00", 0dh, 0ah, '$'

ArrDate DB 10 DUP(20 DUP(0))
	
.CODE
MAIN PROC
	MOV AX,@DATA
	MOV DS,AX

	; Main program.

;getDate:
    mov     ah, 04h             ; get date from bios.
    int     1ah

    mov     bx, offset date     ; do day.
    mov     al, dl
    push    ax                  ; temporary save for low nybble.
    shr     ax, 4               ; get high nybble as digit.
    and     ax, 0fh
    add     ax, '0'
    mov     [bx], al            ; store that to string.
    inc     bx
    pop     ax                  ; recover low nybble.

    and     ax, 0fh             ; make it digit and store.
    add     ax, '0'
    mov     [bx], al

    inc     bx                  ; leave bx pointing at next char.

    inc     bx                  ; do month.
    mov     al, dh
    push    ax                  ; temporary save for low nybble.
    shr     ax, 4               ; get high nybble as digit.
    and     ax, 0fh
    add     ax, '0'
    mov     [bx], al            ; store that to string.
    inc     bx
    pop     ax                  ; recover low nybble.

    and     ax, 0fh             ; make it digit and store.
    add     ax, '0'
    mov     [bx], al

    inc     bx                  ; leave bx pointing at next char.

    inc     bx                  ; do year.
    mov     al, ch
    push    ax                  ; temporary save for low nybble.
    shr     ax, 4               ; get high nybble as digit.
    and     ax, 0fh
    add     ax, '0'
    mov     [bx], al            ; store that to string.
    inc     bx
    pop     ax                  ; recover low nybble.

    and     ax, 0fh             ; make it digit and store.
    add     ax, '0'
    mov     [bx], al

    inc     bx                  ; leave bx pointing at next char.
    mov     al, cl
    push    ax                  ; temporary save for low nybble.
    shr     ax, 4               ; get high nybble as digit.
    and     ax, 0fh
    add     ax, '0'
    mov     [bx], al            ; store that to string.
    inc     bx
    pop     ax                  ; recover low nybble.

    and     ax, 0fh             ; make it digit and store.
    add     ax, '0'
    mov     [bx], al

    inc     bx                  ; leave bx pointing at next char.

;getTime:
    mov     ah, 02h             ; get time from bios.
    int     1ah

    mov     bx, offset time     ; do hour.
    mov     al, ch
    push    ax                  ; temporary save for low nybble.
    shr     ax, 4               ; get high nybble as digit.
    and     ax, 0fh
    add     ax, '0'
    mov     [bx], al            ; store that to string.
    inc     bx
    pop     ax                  ; recover low nybble.

    and     ax, 0fh             ; make it digit and store.
    add     ax, '0'
    mov     [bx], al

    inc     bx                  ; leave bx pointing at next char.

    inc     bx                  ; do minute.
    mov     al, cl
    push    ax                  ; temporary save for low nybble.
    shr     ax, 4               ; get high nybble as digit.
    and     ax, 0fh
    add     ax, '0'
    mov     [bx], al            ; store that to string.
    inc     bx
    pop     ax                  ; recover low nybble.

    and     ax, 0fh             ; make it digit and store.
    add     ax, '0'
    mov     [bx], al

    inc     bx                  ; leave bx pointing at next char.

    inc     bx                  ; do second.
    mov     al, dh
    push    ax                  ; temporary save for low nybble.
    shr     ax, 4               ; get high nybble as digit.
    and     ax, 0fh
    add     ax, '0'
    mov     [bx], al            ; store that to string.
    inc     bx
    pop     ax                  ; recover low nybble.

    and     ax, 0fh             ; make it digit and store.
    add     ax, '0'
    mov     [bx], al

    inc     bx                  ; leave bx pointing at next char.

    lea     dx, output          ; then output the string.
    mov     ah, 09h
    int     21h

    mov     ax, 4c00h           ; exit program.
    int     21h

 
	MOV AX,4C00H
	INT 21H
MAIN ENDP
END MAIN