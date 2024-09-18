.MODEL SMALL
.STACK 100
.DATA

	 ; Table-style header using ASCII characters
    top_left_corner db 218 ; ASCII code for top-left corner (┌)
    top_right_corner db 191 ; ASCII code for top-right corner (┐)
    bottom_left_corner db 192 ; ASCII code for bottom-left corner (└)
    bottom_right_corner db 217 ; ASCII code for bottom-right corner (┘)
    horizontal_line db 196  ; ASCII code for horizontal line (─)
    vertical_line db 179    ; ASCII code for vertical line (│)
    logo_line db 0Dh, 0Ah, 0

    ; Dynamic content for table
    header_title db ' Book Lego Guy ', 0
    separator_line db '-----------------------------------------------', 10, 0
    logo_text1 db '         _               _        _                ', 10, 0
    logo_text2 db '        | |             | |      | |               ', 10, 0
    logo_text3 db '   _   _| |__  _   _ ___| |_ __ _| |__   __ _ ___   ', 10, 0
    logo_text4 db '  | | | | `_ \| | | / __| __/ _` | `_ \ / _` / __|  ', 10, 0
    logo_text5 db '  | |_| | |_) | |_| \__ \ || (_| | | | | (_| \__ \  ', 10, 0
    logo_text6 db '   \__,_|_.__/ \__,_|___/\__\__,_|_| |_|\__,_|___/  ', 10, 0

    newline db 0Dh, 0Ah, 0  ; Newline (CR + LF)


.CODE
MAIN PROC
	MOV AX,@DATA
	MOV DS,AX
	
	; PrINT top border (┌──────┐)
    MOV AX, 4                ; syscall number for SYS_WRITE
    MOV BX, 1                ; file descriptor 1 (stdout)
    MOV CX, top_left_corner   ; prINT top-left corner (┌)
    MOV DX, 1                ; prINT 1 character
    INT 21H                  ; make the syscall

    ; PrINT horizontal line (──────)
    MOV CX, horizontal_line  ; prINT horizontal line (─)
    MOV DX, 40               ; length of the line
    INT 21H

    ; PrINT top-right corner (┐)
    MOV CX, top_right_corner  ; prINT top-right corner (┐)
    MOV DX, 1                ; prINT 1 character
    INT 21H

    ; Newline
    MOV CX, newline
    MOV DX, 2
    INT 21H

    ; PrINT vertical border and title
    MOV CX, vertical_line    ; prINT left vertical line (│)
    MOV DX, 1
    INT 21H

    MOV CX, header_title     ; prINT title
    MOV DX, 16
    INT 21H

    MOV CX, vertical_line    ; prINT right vertical line (│)
    MOV DX, 1
    INT 21H

    ; Newline
    MOV CX, newline
    MOV DX, 2
    INT 21H

    ; PrINT separator (└──────┘)
    MOV CX, bottom_left_corner  ; prINT bottom-left corner (└)
    MOV DX, 1
    INT 21H

    MOV CX, horizontal_line  ; prINT horizontal line (─)
    MOV DX, 40
    INT 21H

    MOV CX, bottom_right_corner ; prINT bottom-right corner (┘)
    MOV DX, 1
    INT 21H

    ; Newline
    MOV CX, newline
    MOV DX, 2
    INT 21H

    ; PrINT the logo line by line
    MOV AX, 4
    MOV BX, 1
    MOV CX, logo_text1
    MOV DX, 56
    INT 21H

    MOV CX, logo_text2
    MOV DX, 56
    INT 21H

    MOV CX, logo_text3
    MOV DX, 56
    INT 21H

    MOV CX, logo_text4
    MOV DX, 56
    INT 21H

    MOV CX, logo_text5
    MOV DX, 56
    INT 21H

    MOV CX, logo_text6
    MOV DX, 56
    INT 21H

	MOV AX,4C00H
	INT  21H
MAIN ENDP
END MAIN