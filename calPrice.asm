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

	;Book Price
	WhispersP    DB 1
    EchP        DB 25
	LocketP      DB 16
	WillowP     DB 17
	RendezvousP  DB 10
	CrimsonP     DB 12
	ShadowsP     DB 13
	MemoriesP    DB 15
	SerenadeP    DB 19
	DreamP       DB 13

	PRICE DB 1,25,16,17,10,12,13,15,19,13
	
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
	
	
	;General Display DATA
	NL DB 0AH,0DH,"$"
	PMETHOD DB "Payment Method$"
	PROMPOPT DB "Enter your selection: $"
	PINVALID DB "Invalid Input!!!$"
	QUIT DB "Quit$"
	ENTAGN DB "Enter again$"

	;Payment Method DATA
	PAYMT DB ?
	EACHAMOUNT DW 10 DUP(0)
	TOTALAMOUNT DW ?
	SEL DB ?
	SEL2 DB ?
	BOOKN DB "  BOOK NAME : $"
	BOOKEP DB "  BOOK PRICE : $"
	BOOKQ DB "   QUANTITY : $"
	EACHAD DB "  AMOUNT : $"
	
	;Dummy Data 
	BUYQ DB 0,9,1,0,2,3,0,0,7,1
	TEN DB 10
	HUN DB 100
	LC DB ?
	

.CODE

	PUBLIC CALPRICE
	EXTRN ASS:NEAR

CALPRICE PROC
	MOV AX,@DATA
	MOV DS,AX
;TO CALCULATE TOTAL

MOV SI,0
MOV LC,10
MOV DI,0
L1:

	CMP BUYQ[DI],0
	JNE SHT

	JMP AGAIN

	SHT:

	MOV BL,BUYQ[DI]
	MOV AX,0H
	MOV AL,BL
	MOV DL,PRICE[DI]
	MUL DL
	MOV BX,AX
	MOV EACHAMOUNT[DI],BX

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

	MOV AX,0H
	MOV AL,Price[DI]
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
	LEA DX,BOOKQ
	INT 21H

	MOV AX,0H
	MOV AL,BUYQ[DI]
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

	MOV AX,EACHAMOUNT[DI]
	DIV HUN
	MOV BX,AX

	MOV AH,02H
	MOV DL,BL
	ADD DL,30H
	INT 21H

	MOV AX,0H 
	MOV AL,BH
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
	LEA DX,NL
	INT 21H

	AGAIN:

		ADD SI,2
		INC DI
	
		DEC LC
		CMP LC,0
		JE FINISH
	
	JMP L1

	FINISH:

; display the payment method here, follow by date and time

; perform payment, if success display success, then deduct the amount of book, if failed, display payment failed




; maybe do add in random number generator for card number, and tng account number

; the the waiting stuff for processing if using tng and card?

	RET
CALPRICE ENDP
END CALPRICE