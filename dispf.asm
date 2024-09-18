.MODEL SMALL
.STACK 100H
.DATA
    EXTRN result:WORD
    strResult DB 7 DUP('$')  ; Define a buffer for storing the string result
    tempStr DB 6 DUP('$')    ; Temporary storage for the number conversion

.CODE
PUBLIC DISPF
DISPF PROC
    ; Preserve registers
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    ; Load the result into AX
    MOV AX, result
    
    ; Convert integer part
    XOR CX, CX              ; Clear CX (counter)
    MOV BX, 10              ; Divisor (10)

convertLoop:
    XOR DX, DX              ; Clear DX before division
    DIV BX                  ; Divide AX by 10
    ADD DL, '0'             ; Convert remainder to ASCII
    PUSH DX                 ; Store character on stack
    INC CX                  ; Increment counter
    OR AX, AX               ; Check if AX is zero
    JNZ convertLoop         ; If not, loop

    ; Insert the decimal point before the last two digits
    MOV SI, OFFSET tempStr
    MOV DI, OFFSET strResult
    MOV AL, '$'
    STOSB                    ; Insert the string terminator
    
    ; Load digits
    MOV AL, '0'
    STOSB                    ; Default zero in case of leading decimal

    POP AX
    MOV [DI], AL             ; Store last digit
    INC DI

    MOV BYTE PTR [DI], '.'   ; Insert decimal point
    INC DI

outputLoop:
    POP AX                   ; Pop characters from stack
    MOV [DI], AL             ; Store in string
    INC DI                   ; Move to next character
    LOOP outputLoop          ; Repeat for all characters

    ; Display the string
    MOV DX, OFFSET strResult
    MOV AH, 09H
    INT 21H                  ; Display the string

    ; Restore registers
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
DISPF ENDP
END
