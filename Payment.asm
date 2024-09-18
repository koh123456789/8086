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

	BOOK DW OFFSET Whispers, OFFSET Echo, OFFSET Locket, OFFSET Willow
         DW OFFSET Rendezvous, OFFSET Crimson, OFFSET Shadows
         DW OFFSET Memories, OFFSET Serenade, OFFSET Dream

;Book Price(Floating number)
	WhispersP    DD 10.5
    EchP        DD 25.3
	LocketP      DD 16.0
	WillowP     DD 17.9
	RendezvousP  DD 10.5
	CrimsonP     DD 12.2
	ShadowsP     DD 13.0
	MemoriesP    DD 15.4
	SerenadeP    DD 19.8
	DreamP       DD 13.9

	Price DD 10.5, 25.3, 16.0, 17.9, 10.5, 12.2, 13.0, 15.4, 19.8, 13.9

	;Book left quantity
   	WhispersQ    DW 155
	EchQ        DW 288
	LocketQ      DW 123
	WillowQ      DW 262
	RendezvousQ  DW 165
	CrimsonQ     DW 256
	ShadowsQ     DW 278
	MemoriesQ    DW 132
	SerenadeQ    DW 265
	DreamQ       DW 164

	LeftQuantity DW OFFSET WhispersQ, OFFSET EchQ, OFFSET LocketQ, OFFSET WillowQ
         DW OFFSET RendezvousQ, OFFSET CrimsonQ, OFFSET ShadowsQ
         DW OFFSET MemoriesQ, OFFSET SerenadeQ, OFFSET DreamQ

 
	BuyQuantity DW 10 DUP(0)


	;Genre
	H DB "Horror$",0
	R DB "Romance$",0
	A DB "Adventure$",0
	NF DB "Non-fiction$",0
	E DB "Education$",0

	Genre DW OFFSET R,OFFSET H,OFFSET A,OFFSET E,OFFSET R,OFFSET NF,OFFSET H,OFFSET R,OFFSET A,OFFSET E


	;Author
	KWY DB "Koh Win Yee$"
	CJY DB "Chiam Jian Yu$"
	LZY DB "Lau Zi Lin$"
	LXY DB "Loke Xin Yee$"

	Author DW OFFSET KWY,OFFSET KWY,OFFSET CJY,OFFSET CJY,OFFSET LZY,OFFSET LZY,OFFSET LXY,OFFSET LXY


	;Payment method
	TNG DB "Touch N Go$"
	CARD DB "Card$"
	CASH DB "Cash$"

	;Sales
	SALES DW 10000

	;Account
	USERNAME DB "LegoGuy$"
	PASS DW 1234

	;floating point display data
    factor DW 10       ; Scaling factor for displaying
	result DW 0       ; Define the result variable as a 16-bit word
	strResult DB 12 DUP('$')  ; Define a buffer for storing the string result

	ADDRESS DW ?
	ADDRESSEA DW ?

	;General Display DATA
	NL DB 0AH,0DH,"$"
	PMETHOD DB "Payment Method$"
	PROMPOPT DB "Enter your selection: $"
	PINVALID DB "Invalid Input!!!$"
	QUIT DB "Quit$"
	ENTAGN DB "Enter again$"
	DOT DB ". $"

	;Payment Method DATA
	PAYMT DB ?
	EACHAMOUNT DD 10 DUP(0.0)
	TOTALAMOUNT DD 0.0
	SEL DB ?
	SEL2 DB ?
	BOOKN DB "  BOOK NAME : $"
	BOOKEP DB "  BOOK PRICE : $"
	BOOKQ DB "   QUANTITY : $"
	EACHAD DB "  AMOUNT : $"
	TOTALD DB "  TOTAL AMOUNT : $"
	PROMPTPAY DB "	ENTER AMOUNT PAID : $"
	
	;Dummy Data 
	BUYQ DW 0,10,1,0,2,3,0,0,80,1
	BOOKC DB 0
	TEN DB 10
	HUN DB 100
	THO DW 1000
	TTH DW 10000
	LC DB ?
	TOTALP DD 10 DUP(0.0)

	;User Input pay amount if using cash
	PAIDAMOUNTS DB 10 DUP(0)
	PAIDAMOUNTD DW 0

	;TEMP REGISTERS?
	TAX DB ?
	TBX DB ?
	TCX DB ?
	TDX DB ?
	TDI DW ?
	TSI DW ?
	TAA DB ?

.CODE

MAIN PROC
	MOV AX,@DATA
	MOV DS,AX

	    ;FLDZ
		FINIT
		FLDZ                          ; Load 0.0 into FPU stack
		FSTP DWORD PTR [TOTALAMOUNT]  ; Store 0.0 in TOTALAMOUNT


;TO CALCULATE TOTAL
MOV ADDRESS,0
MOV ADDRESSEA,0
MOV SI,0
MOV LC,10
MOV DI,0
L1:

	CMP BUYQ[SI],0
	JNE SHT

	JMP AGAIN

	SHT:
	INC BOOKC
	MOV AX,0H

	FILD WORD PTR [BUYQ[SI]] ;LOAD QUANTITY

		MOV TDI,DI
		MOV DI,ADDRESS

   	FLD DWORD PTR [PRICE[DI]]  ; Load num1 into the FPU stack
	FMUL

		MOV DI,ADDRESSEA

	FSTP DWORD PTR [EACHAMOUNT[DI]]

		MOV DI,TDI
		
	MOV CX,72
	DASH:
			MOV AH,02H
			MOV DL,'-'
			INT 21H
			
	LOOP DASH

; display the quantity, name, and total here

	MOV AH,09H
	LEA DX,NL
	INT 21H

	MOV AH,09H 
	LEA DX,BOOKN	
	INT 21H

	; Load the pointer to the book name from the BOOK array
	MOV AH,09H 
	MOV DX,BOOK[SI] ; DX gets the address of the string to print
	INT 21H             ; Display the string

	MOV AH,09H 
	LEA DX,BOOKEP
	INT 21H

		MOV TDI,DI
		MOV DI,ADDRESS

  	FLD DWORD PTR [PRICE[DI]]  ; Load num1 into the FPU stack

		MOV DI,TDI

    FILD WORD PTR [factor] ; Load factor
    FMUL                  ; Multiply result by factor to scale
    FISTP result          ; Store integer part in result
	 
	CALL DISPF

	;;;;;;;

	MOV AH,09H 
	LEA DX,BOOKQ
	INT 21H

	MOV AX,0H
	MOV AX,BUYQ[SI]
	DIV TEN
	MOV BX,AX

	MOV AH,02H
	MOV DL,BL
	ADD DL,30H
	INT 21H

	MOV AH,02H
	MOV DL,BH
	ADD DL,30H
	INT 21H

	MOV AH,09H 
	LEA DX,EACHAD
	INT 21H

		MOV TDI,DI
		MOV DI,ADDRESSEA

  	FLD DWORD PTR [EACHAMOUNT[DI]]  ; Load num1 into the FPU stack

  	FLD DWORD PTR [TOTALAMOUNT]

 	FADD

	FSTP DWORD PTR [TOTALAMOUNT]    ; Store the result back into TOTALAMOUNT
	FINIT
	FLD DWORD PTR [EACHAMOUNT[DI]]  ; Load num1 into the FPU stack
	FILD WORD PTR [factor] ; Load factor
	FMUL
	FISTP result          ; Store integer part in result


	CALL DISPF

	MOV DI,TDI

	MOV BX,4
	ADD ADDRESSEA,BX
	
	;;;;

	MOV AH,09H
	LEA DX,NL
	INT 21H

	AGAIN:

		ADD SI,2
		INC DI
		MOV BX,4
		ADD ADDRESS,BX
	
		DEC LC
		CMP LC,0
		JE FINISH
	
	JMP L1

	FINISH:
	FINIT
	; Store total amount in TOTALAMOUNT
	MOV DI,0
	FSTP DWORD PTR [TOTALP[DI]]  ; Store 0.0 in TOTALAMOUNT
	FLD DWORD PTR [TOTALAMOUNT] 
    FSTP DWORD PTR [TOTALP[DI]]

	MOV AH,09H 
	LEA DX,TOTALD
	INT 21H
	
	FINIT
	; Display the total amount
	FLD DWORD PTR [TOTALP[DI]]
	FILD WORD PTR [FACTOR] ; Load factor
	FMUL
	FISTP result          ; Store integer part in result
	CALL DISPF

	MOV AH,09H
	LEA DX,NL
	INT 21H

	MOV AH,02H
	MOV DL,'='
	INT 21H

	CALL CHOOSEPAY

	MOV AX,4C00H
	INT 21H
MAIN ENDP

DISPF PROC
    ; Preserve registers
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH DI
    PUSH SI

    ; Load the value of 'result' into AX (assuming result is 16-bit)
    MOV AX, result       ; AX now holds the value, e.g., 15000

    ; Division by 10000 to extract the ten-thousands place
    MOV CX, TTH         ; Divisor for ten-thousands
    XOR DX, DX            ; Clear DX to avoid overflow
    DIV CX                ; AX = AX / 10000, DX = remainder
    MOV TAX, AL         ; Store the ten-thousands digit in TAX
    MOV AX, DX            ; AX now holds the remainder

    ; Division by 1000 to extract the thousands place
    MOV CX, THO          ; Divisor for thousands
    XOR DX, DX            ; Clear DX
    DIV CX                ; AX = AX / 1000, DX = remainder
    MOV TBX, AL         ; Store the thousands digit in TBX
    MOV AX, DX            ; AX now holds the remainder

    ; Division by 100 to extract the hundreds place
	XOR CX,CX
    MOV CL, HUN           ; Divisor for hundreds
    XOR DX, DX            ; Clear DX
    DIV CX                ; AX = AX / 100, DX = remainder
    MOV TCX, AL         ; Store the hundreds digit in TCX
    MOV AX, DX            ; AX now holds the remainder

    ; Division by 10 to extract the tens place
	XOR CX,CX
    MOV CL, TEN            ; Divisor for tens
    XOR DX, DX            ; Clear DX
    DIV CX                ; AX = AX / 10, DX = remainder
    MOV TDX, AL         ; Store the tens digit in TDX
    MOV TAA, DL         ; Store the remainder (units place) in TSI

    ; Print the ten-thousands digit (if it's not zero)
    CMP TAX, 0
    JZ SkipTenThousands   ; If the ten-thousands digit is 0, skip it
    MOV AL, TAX         ; Load the ten-thousands digit
    ADD AL, '0'           ; Convert to ASCII
    MOV AH, 02H
    MOV DL, AL
    INT 21H               ; Print the character

SkipTenThousands:

    ; Print the thousands digit
    CMP TBX, 0
    JZ SkipThousands      ; If the thousands digit is 0, skip it (after 10000 case)
    MOV AL, TBX         ; Load the thousands digit
    ADD AL, '0'           ; Convert to ASCII
    MOV AH, 02H
    MOV DL, AL
    INT 21H               ; Print the character

SkipThousands:

    ; Print the hundreds digit
    CMP TCX, 0
    JZ SkipHundreds       ; If the hundreds digit is 0, skip it (after 1000 case)
    MOV AL, TCX         ; Load the hundreds digit
    ADD AL, '0'           ; Convert to ASCII
    MOV AH, 02H
    MOV DL, AL
    INT 21H               ; Print the character

SkipHundreds:

    ; Print the tens digit
    MOV AL, TDX         ; Load the tens digit
    ADD AL, '0'           ; Convert to ASCII
    MOV AH, 02H
    MOV DL, AL
    INT 21H               ; Print the character

	;Print the decimal point (for floating-point representation, if needed)
    MOV AH, 02H
    MOV DL, '.'
    INT 21H

    ; Print the units digit
    MOV AL, TAA         ; Load the units digit
    ADD AL, '0'           ; Convert to ASCII
    MOV AH, 02H
    MOV DL, AL
    INT 21H               ; Print the character

	MOV AH,02H
	MOV DL,'0'
	INT 21H

    ; Restore registers
    POP SI
    POP DI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
DISPF ENDP


CHOOSEPAY PROC
	; Preserve registers
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH DI
    PUSH SI

	;Prompt Payment Method
	MAINP:
	MOV AH,09H
	LEA DX,PMETHOD
	INT 21H
	
	LEA DX,NL
	INT 21H
	
	;Option TNG
	MOV AH,02H
	MOV DL,1
	ADD DL,30H
	INT 21H
	
	MOV AH,09H
	LEA DX,DOT
	INT 21H
	
	LEA DX,TNG
	INT 21H
	
	LEA DX,NL
	INT 21H
	
	;Option CARD
	MOV AH,02H
	MOV DL,2
	ADD DL,30H
	INT 21H
	
	MOV AH,09H
	LEA DX,DOT
	INT 21H
	
	LEA DX,CARD
	INT 21H
	
	LEA DX,NL
	INT 21H
	
	;Option CASH
	MOV AH,02H
	MOV DL,3
	ADD DL,30H
	INT 21H
	
	MOV AH,09H
	LEA DX,DOT
	INT 21H
	
	LEA DX,CASH
	INT 21H
	
	LEA DX,NL
	INT 21H
	
	;Prompt User Input
	LEA DX,PROMPOPT
	INT 21H
	
	MOV AH,01H
	INT 21H
	MOV SEL,AL
	
	MOV AH,09H
	
	;Compare User Input
	
	;Check Valid
	CMP SEL,'1'
	JE TGO
	CMP SEL,'2'
	JE CAD
	CMP SEL,'3'
	JE CAH
	
	;IF INVALID,PROMPT CONTINUE?
		;MOV AH,09H
		LEA DX,NL
		INT 21H
		
		LEA DX,PINVALID
		INT 21H
		
		LEA DX,NL
		INT 21H
		
		;Enter Again?
		MOV AH,02H
		MOV DL,'1'
		INT 21H
		
		MOV AH,09H
		LEA DX,DOT
		INT 21H
		
		LEA DX,ENTAGN
		INT 21H
		
		LEA DX,NL
		INT 21H
		
		;Quit?
		MOV AH,02H
		MOV DL,'2'
		INT 21H
		
		MOV AH,09H
		LEA DX,DOT
		INT 21H
		
		LEA DX,QUIT
		INT 21H
		
		LEA DX,NL
		INT 21H
		
		;PROMT USER INPUT 
		LEA DX,PROMPOPT
		INT 21H
		
		MOV AH,01H
		INT 21H	
		MOV SEL2,AL
		
		CMP SEL2,'1'
		JNE FINISHPM ;QUIT
		JMP MAINP
	
	TGO:
		;MOV AH,09H
		LEA DX,NL
		INT 21H
		
		LEA DX,TNG
		INT 21H
		JMP FINISHPM
	
	CAD:
		;MOV AH,09H
		LEA DX,NL
		INT 21H
		
		LEA DX,CARD
		INT 21H
		JMP FINISHPM
	
	CAH:
		;MOV AH,09H
		LEA DX,NL
		INT 21H
		
		LEA DX,CASH
		INT 21H
		CALL CASHCHANGE
		JMP FINISHPM
		
		
	FINISHPM:
    ; Restore registers
    POP SI
    POP DI
    POP DX
    POP CX
    POP BX
    POP AX
	RET
CHOOSEPAY ENDP



CASHCHANGE PROC
    ; Preserve registers
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH DI
    PUSH SI

    ; Prompt the user to input payment amount
    MOV AH, 09H
    LEA DX, PROMPTPAY
    INT 21H

	XOR DX,DX
	XOR AX,AX
	XOR CX,CX
	MOV SI,0
	LOOP_INPUT_CASH:

		MOV AH,01H
		INT 21H
		SUB AL,30H
		MOV PAIDAMOUNTS[SI],AL

		CMP AL,0
		JL END_OF_CASH_INPUT
		CMP AL,9
		JG END_OF_CASH_INPUT

		ADD PAIDAMOUNTD,AL
		MOV AX,PAIDAMOUNTD
		MUL TEN
		MOV PAIDAMOUNTD,AX

	LOOP LOOP_INPUT_CASH		

	END_OF_CASH_INPUT:

    ; Display the result
    MOV RESULT, AX
    CALL DISPF

    ; Restore registers
    POP SI
    POP DI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
CASHCHANGE ENDP





DEDUCTBOOK PROC
	; Preserve registers
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH DI
    PUSH SI

	MOV CX,0
	MOV SI,0
	DEDUCT:
		MOV BX,BUYQ[SI]
		SUB LeftQuantity[SI],BX
		ADD BuyQuantity[SI],BX
		
		ADD SI,2
	LOOP DEDUCT

    ; Restore registers
    POP SI
    POP DI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
DEDUCTBOOK ENDP



END MAIN

