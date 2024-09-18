.MODEL SMALL
.STACK 100H
.DATA
    num1 DD 3.1, 2.1        ; First floating-point number
    num2 Dw 2        ; Second floating-point number

    ;floating point display data
    factor DW 100       ; Scaling factor for displaying
    result DW ?         ; Storage for integer result
    strResult DB 12 DUP ('$')  ; Buffer to store the string representation

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    MOV DI,4
    ; Load the floating-point values into the FPU and multiply
    FLD DWORD PTR [num1[DI]]  ; Load num1 into the FPU stack
    FILD WORD PTR [num2]  ; Load num2 into the FPU stack
    FMUL                  ; Multiply num1 * num2
    FILD WORD PTR [factor] ; Load factor
    FMUL                  ; Multiply result by factor to scale
    FISTP result          ; Store integer part in result

    ; Convert integer to string and display
    MOV AX, result
    ; Convert the integer in AX to a null-terminated string in strResult
    XOR CX, CX          ; Clear CX (counter)
    MOV BX, 10          ; Divisor (10)

convertLoop:
    XOR DX, DX          ; Clear DX before division
    DIV BX              ; Divide AX by 10
    ADD DL, '0'         ; Convert remainder to ASCII
    PUSH DX             ; Store character on stack
    INC CX              ; Increment counter
    OR AX, AX           ; Check if AX is zero
    JNZ convertLoop     ; If not, loop

    MOV DI, OFFSET strResult ; Destination string

    ; Insert the decimal point before the last two digits
    POP AX
    MOV [DI], AL
    INC DI
    MOV BYTE PTR [DI], '.'  ; Insert decimal point
    INC DI

outputLoop:
    POP AX              ; Pop characters from stack
    MOV [DI], AL        ; Store in string
    INC DI              ; Move to next character
    LOOP outputLoop     ; Repeat for all characters

    MOV BYTE PTR [DI], '$' ; Null terminator for INT 21h function 09h

    ; Display the string
    MOV DX, OFFSET strResult
    MOV AH, 09H
    INT 21H                ; Display the string

    ; Exit program
    MOV AX,4C00H
    INT 21H
MAIN ENDP
END MAIN
