.MODEL SMALL
.STACK 100H
.DATA
    EXTRN result:WORD
    EXTRN strResult:BYTE

.CODE
displayFloat PROC
    ; Preserve registers
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    ; Convert integer to string and display
    MOV AX, result
    ; Convert the integer in AX to a null-terminated string in strResult
    XOR CX, CX                 ; Clear CX (counter)
    MOV BX, 10                 ; Divisor (10)

convertLoop:
    XOR DX, DX                 ; Clear DX before division
    DIV BX                     ; Divide AX by 10
    ADD DL, '0'                ; Convert remainder to ASCII
    PUSH DX                    ; Store character on stack
    INC CX                     ; Increment counter
    OR AX, AX                  ; Check if AX is zero
    JNZ convertLoop            ; If not, loop

    MOV DI, OFFSET strResult   ; Destination string

    ; Insert the decimal point before the last two digits
    POP AX
    MOV [DI], AL
    INC DI
    MOV BYTE PTR [DI], '.'     ; Insert decimal point
    INC DI

outputLoop:
    POP AX                     ; Pop characters from stack
    MOV [DI], AL               ; Store in string
    INC DI                     ; Move to next character
    LOOP outputLoop            ; Repeat for all characters

    MOV BYTE PTR [DI], '$'     ; Null terminator for INT 21h function 09h

    ; Display the string
    MOV DX, OFFSET strResult
    MOV AH, 09H
    INT 21H                    ; Display the string

    ; Restore registers
    POP DX
    POP CX
    POP BX
    POP AX
    RET
displayFloat ENDP

END
