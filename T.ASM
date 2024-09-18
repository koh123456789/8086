.MODEL SMALL
.STACK 100
.DATA

    ;Book
    Whispers    DB "Whispers$",0
    Echo        DB "Echo$",0
    Locket      DB "Locket$",0
    Willow      DB "Willow$",0
    Rendezvous  DB "Rendezvous$",0
    Crimson     DB "Crimson$",0
    Shadows     DB "Shadows$",0
    Memories    DB "Memories$",0
    Serenade    DB "Serenade$",0
    Dream       DB "Dream$",0

    BOOK DD Whispers,Echo,Locket,Willow,Rendezvous,Crimson,Shadows,Memories,Serenade,Dream

.CODE
MAIN PROC
    MOV AX,@DATA
    MOV DS,AX

    ; Access the 3rd book (Locket)
    LEA BX, BOOK           ; Load the base address of BOOK into BX

    ; Load the 3rd pointer (index 2 because it's 0-based)
    MOV SI, [BX + 2*4]     ; Load the pointer from BOOK[2] (Locket's address) into SI

    ; Display the string at the address in SI
    MOV AH, 09H
    MOV DX, SI             ; DX holds the address of the string
    INT 21H

    ; End the program
    MOV AX, 4C00H
    INT 21H
MAIN ENDP
END MAIN
