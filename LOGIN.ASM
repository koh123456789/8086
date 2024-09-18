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
	PASS DB "1234$"
	PASSLENGTH DB 4
	
	
	;General Display DATA
	NL DB 0AH,0DH,"$"
	PTITLE DB "Book Lego Guy Book POS$"
	PROMPUSN DB "Enter username: $"
	PINVALID DB "Invalid Input!!!$"
	PROMPPASS DB "Ente password: $"
	PROMPOPT DB "Enter your selection: $"
	SUC DB "LOGIN SUCCESSFULLY!$"
	INV DB "Invalid Username or Password!!!$"
	QUIT DB "Quit$"
	ENTAGN DB "Enter again$"
	DOT DB ". $"

	;Payment Method DATA
	PAYMT DB ?
	EACHAMOUNT DW 10 DUP(0)
	TOTALAMOUNT DW ?
	SEL DB ?
	SEL2 DB ?
	BOOKN DB "  BOOK NAME : $"
	BOOKEP DB "  BOOK PRICE : $"
	
	STRU LABEL BYTE
	MAXNU DB 20
	ACTNU DB ?
	INPUTUSN DB 20 DUP("$")
	
	STRP LABEL BYTE
	MAXNP DB 20
	ACTNP DB ?
	INPUTPASS DB 20 DUP("$")
	
	;Dummy Data 
	BUYQ DB 0,9,1,0,2,3,0,0,7,1
	TEN DB 10
	HUN DB 100
	LC DB ?
	TOTALP DW 0

.CODE
MAIN PROC
	MOV AX,@DATA
	MOV DS,AX

	MOV AH,09H
	LEA DX,PTITLE
	INT 21H

LOGIN:
	MOV AH,09H
	LEA DX,NL
	INT 21H

	LEA DX,PROMPUSN
	INT 21H

	MOV AH,0AH
	LEA DX,STRU
	INT 21H
	
	MOV AH,09H  
	LEA DX,NL
	INT 21H
	
	LEA DX,PROMPPASS
	INT 21H
	
	MOV AH,0AH
	LEA DX,STRP
	INT 21H

	MOV AH,09H
	LEA DX,NL
	INT 21H
	
	;LOOP TO CHECK USER NAME FIRST
	MOV SI,0
	MOV CX,0H
	MOV CL,ACTNU
	VERIFYU:
		MOV BL,INPUTUSN[SI]
		CMP USERNAME[SI],BL
		JNE INVALID
		
		INC SI
		
	LOOP VERIFYU

	;NOW LOOP TO CHECK PASSWORD
	MOV SI,0
	MOV CX,0H
	MOV CL,ACTNP
	VERIFYP:

		MOV BL,INPUTPASS[SI]
		CMP PASS[SI],BL
		JNE INVALID
		
		INC SI
		
	LOOP VERIFYP

	MOV Al,PASSLENGTH
	CMP ACTNP,Al
	JNE INVALID
	
	MOV AH,09H
	LEA DX,SUC
	INT 21H
	JMP FINISH

	INVALID:
		MOV AH,09H
		LEA DX,INV
		INT 21H

		;IF INVALID,PROMPT CONTINUE?
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
		JNE FINISH ;QUIT
		JMP LOGIN

	FINISH:

	MOV AX,4C00H
	INT 21H
MAIN ENDP
END MAIN
