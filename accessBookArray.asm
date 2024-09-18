.MODEL SMALL
.STACK 100
.DATA

    ; Book names
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

    ; Array of pointers to book names
    BOOK DD Whispers,Echo,Locket,Willow,Rendezvous,Crimson,Shadows,Memories,Serenade,Dream

    NL DB 0DH,0AH,"$"  ; New line characters for printing new line

.CODE
MAIN PROC
    MOV AX,@DATA
    MOV DS,AX

    LEA BX, BOOK  ; Load the base address of BOOK array into BX
    MOV CX, 10    ; Loop through all 10 books

    MOV SI, 0     ; Start with the first book (index 0)

PrintNextBook:
    ; Access the pointer for the book at index SI
    MOV DI, [BX + SI*4]  ; Load the pointer for BOOK[SI] into DI

    ; Print the book name
    MOV AH, 09H
    MOV DX, DI          ; DX gets the address of the string to print
    INT 21H

    ; Print new line
    MOV AH, 09H
    LEA DX, NL
    INT 21H

    ; Increment to the next book
    INC SI
    LOOP PrintNextBook  ; Repeat for all books

    ; End program
    MOV AX, 4C00H
    INT 21H
MAIN ENDP
END MAIN
