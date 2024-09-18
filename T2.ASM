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

	Price DB 10,25,16,17,10,12,13,15,19,13
	
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

	LeftQuantity DW 155,288,123,262,165,256,278,132,265,164


	;Genre
	H DB "Horror$"
	R DB "Romance$"
	A DB "Adventure$"
	NF DB "Non-fiction$"
	E DB "Education$"

	Genre DW R,H,A,E,R,NF,H,R,A,E


	;Author
	KWY DB "Koh Win Yee$"
	CJY DB "Chiam Jian Yu$"
	LZY DB "Lau Zi Lin$"
	LXY DB "Loke Xin Yee$"

	Author DW KWY,KWY,CJY,CJY,LZY,LZY,LXY,LXY


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
	DOT DB ". $"
	
	;Payment Method DATA
	PAYMT DB ?
	EACHAMOUNT DW ?
	TOTALAMOUNT DW ?
	SEL DB ?
	SEL2 DB ?
	
	;Dummy Data 
	BUYQ DB 0,9,12,0,2,3,0,0,7,1
	TEN DB 10
	HUN DB 100
	LC DB ?
	

.CODE
MAIN PROC
	MOV AX,@DATA
	MOV DS,AX

MOV SI,0
MOV CX,10

L1:

	MOV AH,09H
	LEA DX,NL
	INT 21H

	MOV AH,09H 
	MOV DX,BOOK[SI]
	INT 21H

	ADD SI,2
	
LOOP L1

	FINISH:

	MOV AX,4C00H
	INT 21H
MAIN ENDP
END MAIN