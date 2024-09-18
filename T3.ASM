.MODEL SMALL
.STACK 100
.DATA

    newline db 0Dh, 0Ah, '$'   ; DOS newline (carriage return + line feed)
    date_msg db 'Date: ', '$'  ; Message for date
    year_str db 'Year: 0000', 0Dh, 0Ah, '$'    ; Placeholder for year
    month_str db 'Month: 00', 0Dh, 0Ah, '$'    ; Placeholder for month
    day_str db 'Day: 00', 0Dh, 0Ah, '$'        ; Placeholder for day


.CODE
MAIN PROC
	MOV AX,@DATA
	MOV DS,AX

	; Get the system date
    mov ah, 2Ah        ; Function to get date
    int 21h            ; Call DOS interrupt
    
    ; After the interrupt:
    ; CX = Year, DH = Month, DL = Day

    ; --- Convert and print year ---
    mov ax, cx          ; Year is in CX
    call print_year     ; Convert year to ASCII and print it

    ; --- Convert and print month ---
    mov al, dh          ; Month is in DH
    call print_month    ; Convert month to ASCII and print it

    ; --- Convert and print day ---
    mov al, dl          ; Day is in DL
    call print_day      ; Convert day to ASCII and print it

    ; Exit program
    mov ah, 4Ch
    int 21h

; --- Conversion routines and print functions ---

print_year:
    ; AX contains the year (e.g., 2024)
    ; Convert it to ASCII and store in `year_str`
    mov si, year_str + 6  ; Point to first digit of year placeholder
    call convert_word     ; Convert word in AX to ASCII
    mov ah, 09h           ; DOS print string function
    mov dx, year_str      ; Print the "Year: " message with the year
    int 21h
    ret

print_month:
    ; AL contains the month (1 to 12)
    mov si, month_str + 7  ; Point to first digit of month placeholder
    call convert_byte      ; Convert byte in AL to ASCII
    mov ah, 09h            ; DOS print string function
    mov dx, month_str      ; Print the "Month: " message with the month
    int 21h
    ret

print_day:
    ; AL contains the day (1 to 31)
    mov si, day_str + 6    ; Point to first digit of day placeholder
    call convert_byte      ; Convert byte in AL to ASCII
    mov ah, 09h            ; DOS print string function
    mov dx, day_str        ; Print the "Day: " message with the day
    int 21h
    ret

; --- Helper function to convert word to ASCII (for year) ---
convert_word:
    ; Convert the word in AX into a 4-digit ASCII representation
    mov bx, 10
    mov cx, 1000          ; Start with the thousands place
convert_loop_word:
    xor dx, dx            ; Clear DX for division
    div cx                ; AX / CX, quotient in AX, remainder in DX
    add al, '0'           ; Convert number to ASCII
    mov [si], al          ; Store ASCII character in the string
    inc si                ; Move to next character
    mov ax, dx            ; Remainder is now the new AX
    mov cx, bx            ; Move to next divisor (100, 10, 1)
    cmp cx, 1
    jnz convert_loop_word
    ret

; --- Helper function to convert byte to ASCII (for month/day) ---
convert_byte:
    ; Convert the byte in AL into a 2-digit ASCII representation
    mov ah, 0             ; Clear high byte
    mov bx, 10
    div bx                ; AL / 10, quotient in AL, remainder in AH
    add al, '0'           ; Convert the quotient to ASCII
    mov [si], al          ; Store first digit
    inc si
    add ah, '0'           ; Convert the remainder to ASCII
    mov [si], ah          ; Store second digit
    ret

	

	MOV AX,4C00H
	INT 21H
MAIN ENDP
END MAIN