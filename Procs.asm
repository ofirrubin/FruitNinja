 ; ____   ____    ___      __    ___  ___    __ __  ____     ___   _____     __ __   ____  ____   ____   ____  ____   _        ___   _____
; |    \ |    \  /   \    /  ]  /  _]|   \  |  |  ||    \   /  _] / ___/    |  |  | /    ||    \ |    | /    ||    \ | |      /  _] / ___/
; |  o  )|  D  )|     |  /  /  /  [_ |    \ |  |  ||  D  ) /  [_ (   \_     |  |  ||  o  ||  D  ) |  | |  o  ||  o  )| |     /  [_ (   \_ 
; |   _/ |    / |  O  | /  /  |    _]|  D  ||  |  ||    / |    _] \__  |    |  |  ||     ||    /  |  | |     ||     || |___ |    _] \__  |
; |  |   |    \ |     |/   \_ |   [_ |     ||  :  ||    \ |   [_  /  \ |    |  :  ||  _  ||    \  |  | |  _  ||  O  ||     ||   [_  /  \ |
; |  |   |  .  \|     |\     ||     ||     ||     ||  .  \|     | \    |     \   / |  |  ||  .  \ |  | |  |  ||     ||     ||     | \    |
; |__|   |__|\_| \___/  \____||_____||_____| \__,_||__|\_||_____|  \___|      \_/  |__|__||__|\_||____||__|__||_____||_____||_____|  \___|
                                                                                                                                        
                                                      

ObjAddr  equ [bp + 12] ; Print object procedure gets the variable offset via push.
fileAddr equ [bp+4]
Color equ [bp+12] ; The procedure PrintProc gets the color via the push.
; The printing procedures - PrintProc, PrintObject gets
; the width, hight, startx, starty via the following pushes:
widthPram equ [bp + 10] 
hightPram equ [bp +8]
startX 	  equ [bp +6]
startY    equ [bp +4]

 ; ____   ____   ____  ____   ______      ____   ____    ___      __    ___  ___    __ __  ____     ___ 
; |    \ |    \ |    ||    \ |      |    |    \ |    \  /   \    /  ]  /  _]|   \  |  |  ||    \   /  _]
; |  o  )|  D  ) |  | |  _  ||      |    |  o  )|  D  )|     |  /  /  /  [_ |    \ |  |  ||  D  ) /  [_ 
; |   _/ |    /  |  | |  |  ||_|  |_|    |   _/ |    / |  O  | /  /  |    _]|  D  ||  |  ||    / |    _]
; |  |   |    \  |  | |  |  |  |  |      |  |   |    \ |     |/   \_ |   [_ |     ||  :  ||    \ |   [_ 
; |  |   |  .  \ |  | |  |  |  |  |      |  |   |  .  \|     |\     ||     ||     ||     ||  .  \|     |
; |__|   |__|\_||____||__|__|  |__|      |__|   |__|\_| \___/  \____||_____||_____| \__,_||__|\_||_____|
                                                                                                      


; -	The procedure gets the width, hight, startx, starty and the color from pushes            -
; -                                                                                          -
; --------------------------------------------------------------------------------------------
; Changes: None

; The procedure is using: 
;Color equ [bp+12]
; widthPram equ [bp + 10]
; hightPram equ [bp +8]
; startX 	  equ [bp +6]
; startY    equ [bp +4]
proc PrintProc
	push bp ; Get last location into bp register
	mov bp, sp
	
	push ax 
	push bx 
	push cx
	push dx
    push si
	push di
	
	mov ax, Color
	xor si, si ; Reset si
	mov cx, startX ; Set a new X
	mov dx, startY ; Set a new Y
PrintSolid:
	mov bh, 0h ; Print
	mov ah, 0ch
	
	cmp dx, 199d
	ja EndProc
	
	int 10h
	
	inc si ; Increase si- Times of loop
	inc cx ; Increase X
	cmp si, widthPram ; Compare the width [X] to what necessary ---------Compare
	jne PrintSolid ; If not equal jump to complete the line
	mov cx, startX ; Get orginal X
	mov si, startY ; get the orginal Y into si
	add si, hightPram ; Add [Number] to highet you want
	cmp dx, si ; Compare the current Y to the complete one -------Compare
	je Endproc ; If equal get out of the procedure
	xor si, si ; If it's not equal, reset si to count the X again
	inc dx ; Increase Y
	jmp PrintSolid ; Jump to Print again.
	
Endproc: ; If went into the last [X,Y] retrun to the program

    pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax

	pop bp
	ret 10
endp PrintProc


 ; ____   ___ ___  ____       ____   ____    ___      __    ___  ___    __ __  ____     ___   _____
; |    \ |   |   ||    \     |    \ |    \  /   \    /  ]  /  _]|   \  |  |  ||    \   /  _] / ___/
; |  o  )| _   _ ||  o  )    |  o  )|  D  )|     |  /  /  /  [_ |    \ |  |  ||  D  ) /  [_ (   \_ 
; |     ||  \_/  ||   _/     |   _/ |    / |  O  | /  /  |    _]|  D  ||  |  ||    / |    _] \__  |
; |  O  ||   |   ||  |       |  |   |    \ |     |/   \_ |   [_ |     ||  :  ||    \ |   [_  /  \ |
; |     ||   |   ||  |       |  |   |  .  \|     |\     ||     ||     ||     ||  .  \|     | \    |
; |_____||___|___||__|       |__|   |__|\_| \___/  \____||_____||_____| \__,_||__|\_||_____|  \___|
                                                                                                 


; The procedures will hanges: ax, cx, dx, bx, si, es, di


;fileAddr equ [bp + 4]

; Open File procedure will open the file, if the file is the high score file and he did not find it the procedure will create a new file
proc OpenFile

	push bp
	mov bp , sp
	
	; Try open the file
    mov ah, 3Dh
    xor al, al
    mov dx, fileAddr
    int 21h

    jc CompareBMP ; if failed, check if it bmp
    mov [filehandle], ax
	pop bp
    ret 2

CompareBMP:
	cmp dx, offset HFile ; If the file the user tried to open is not bmp
	jne openerror ; Give him an error message
	
	; If it's equal to HFile the program will generagte a new one:
	 mov dx, offset HFile
	 mov cx, 0
	 mov ah, 3Ch
	 int 21h
	 mov [filehandle], ax
	 jc openerror
	 
	 mov ah, 3Eh
	 mov bx, [filehandle]
	 int 21h
	 pop bp
	 ret 2
	
	; Error message if the user failed:
openerror:
    mov dx, offset ErrorMsg
    mov ah, 9h
    int 21h
	pop bp
    ret 2
endp OpenFile

proc ReadHeader

    ; Read BMP file header, 54 bytes

    mov ah,3fh
    mov bx, [filehandle] 
    mov cx,54 ; The size
    mov dx,offset Header
    int 21h
    ret
    endp ReadHeader
	
    proc ReadPalette

    ; Read BMP file color palette, 256 colors * 4 bytes (400h)

    mov ah,3fh
    mov cx,400h
    mov dx,offset Palette
    int 21h
    ret
endp ReadPalette

proc CopyPal

    ; Copy the colors palette to the video memory
    ; The number of the first color should be sent to port 3C8h
    ; The palette is sent to port 3C9h

    mov si,offset Palette
    mov cx,256
    mov dx,3C8h
    mov al,0

    ; Copy starting color to port 3C8h

    out dx,al    ; outputs data from a given register (al) to a given output port (dx)

    ; Copy palette itself to port 3C9h

    inc dx
    PalLoop:

    ; Note: Colors in a BMP file are saved as BGR values rather than RGB.

    mov al,[si+2] ; Get red value.
    shr al,2 ; Max. is 255, but video palette maximal

    ; value is 63. Therefore dividing by 4.

    out dx,al ; Send it.
    mov al,[si+1] ; Get green value.
    shr al,2
    out dx,al ; Send it.
    mov al,[si] ; Get blue value.
    shr al,2
    out dx,al ; Send it.
    add si,4 ; Point to next color.

    ; (There is a null chr. after every color.)

    loop PalLoop
    ret
endp CopyPal

proc CopyBitmap

    ; BMP graphics are saved upside-down.
    ; Read the graphic line by line (200 lines in VGA format),
    ; displaying the lines from bottom to top.

    mov ax, 0A000h
    mov es, ax
    mov cx,200
    PrintBMPLoop:
    push cx

    ; di = cx*320, point to the correct screen line

    mov di,cx
    shl cx,6
    shl di,8
    add di,cx

    ; Read one line

    mov ah,3fh
    mov cx,320
    mov dx,offset ScrLine
    int 21h

    ; Copy one line into video memory

    cld 

    ; Clear direction flag, for movsb

    mov cx,320
    mov si,offset ScrLine
    rep movsb 

    ; Copy line to the screen
    ;rep movsb is same as the following code:
    ;mov es:di, ds:si
    ;inc si
    ;inc di
    ;dec cx
    ;loop until cx=0

    pop cx
    loop PrintBMPLoop
    ret
endp CopyBitmap

; ------------------------------------------------
; 				 Print Help / Menu
; ------------------------------------------------
; The macro is using the bmp procedures to open a specific bmp 
; Changes: None - The OpenFile procedure is doing ret 2 to stable the stack 
;from the filename offset
	macro process_bmp filename
		push offset filename
		call OpenFile
		call ReadHeader
        call ReadPalette
		call CopyPal
		call CopyBitMap
	endm


;/////////////////////////////////////////////
; The procedure gets data from pushes :
; fileAdrr  equ [bp + 12]
; widthPram equ [bp + 10]
; hightPram equ [bp +8]
; startX 	  equ [bp +6]
; startY    equ [bp +4]

; ----------------------------------------
;			 Print Fruit Procedure
; ----------------------------------------
; Changes: None

proc PrintObject
	push bp
	mov bp, sp
	
	push ax 
	push bx 
	push cx
	push dx
    push si
	push di
	
	xor di, di ; Used for color indecator
	xor si, si ; Used for new line indecator
	xor bx, bx ; Used to save fileAdrr for the color
	
	mov cx, startX ; Get the current Y
	mov dx, startY ; Get the current Y
	
	
Print:
	; To hide the fruit from getting on the life/ score compare it to 199, if above exit the procedure.
	;In addition, This procedure is used to print the life too so compare bx - that has the current array offset with life array offset,
	;if they are equal that means that you need to print it. 
	mov bx,ObjAddr
	cmp bx, offset LifeVar
	je EquLife
	
	; If this is not the life array you should not print above y -199d , y- below 21, x- 360,x- 00  
	cmp dx, 199d
	ja endPrintObject

	cmp dx, 21d
	jb endPrintObject
	
	cmp cx, 359d
	ja endPrintObject

	cmp cx, 01d
	jb endPrintObject
	
EquLife:
	mov al, [bx+di]
	mov bh, 0h ; Print
	mov ah, 0ch	
	int 10h
	
	inc cx ; inc x
	inc di ; inc color
	inc si ; inc line indicator
	
	cmp si, widthPram ; check line indicator to the width
	jne Print ; if not equal go back to print
	mov cx, startX ; mov cx the line beginning x
	inc dx ; increase y
	
	; Compare Y:
	xor si, si
	mov si, startY
	add si, hightPram
	cmp dx,si
	je endPrintObject ; if it's above go out
	xor si, si ; reset the counter
	jmp Print ; jump to Print

endPrintObject:

	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax


pop bp 
ret 10
endp PrintObject
	

	
	
; -------------------------------------------------
;            Print Object By Type
; -------------------------------------------------
; The procedure compares "TimesTouched"- above 6 touches = success
; if success -> Print broken fruit, else- Print the complete fruit
	proc process_Fruit
		
		push bp
		mov bp,sp
		
		cmp [TimesTouched], 6d
		jb PushFull 
		
		push [CBFruit]
		jmp PrintFruitLabel
	PushFull:
		push [CFFruit]
	
PrintFruitLabel:
		mov [XWidth], 60d
		mov [YHeight], 60d
		
		push [XWidth]
		push [YHeight]
		push [CurrentX]
		push [CurrentY]
		call PrintObject
		
EndProcessFruit:
		pop bp
		ret 
	endp process_Fruit
	

;-------------------------------------------------------------------------------------------------------------------
;			Procedure- Processing the current frame
; The procedure will print& delete the fruit, delay by the score, compare the mouse hit by calling other procedures
;-------------------------------------------------------------------------------------------------------------------
; Changes: Nothing
proc process_Frame
	
	call process_fruit ; Print the fruittd
	call CompareMouseHit ; Compare if the user hit the fruit 
	call DelayMe; Delay the printing for natural looking
	call DeleteFruit ; Delete the fruit
	call PrintBanner ; Print the banner again (Decrease the chances will be shown up)
	inc [TimesToCenter] ; Increase the time the loop is centering
	
	ret 
endp process_Frame

	
	
	
;------------------------------------------------
;			Print Life Procedure
;------------------------------------------------
	
	proc process_Life
	
	push bp
	mov bp, sp
	
		;Comparing 2 lifes beacsue there are 3 options - one life, two lifes or three lifes.
		cmp [Life], 2d
		jb L1
		je L2
		
	L3: ; 3 lifes
	push offset LifeVar
	push 0020d ;[XWidth]
	push 0020d ;[YHeight]
	push 0260d ;[CurrentX]
	push 0000d ;[CurrentY]
	call PrintObject
	
	L2: ; 2 lifes
	push offset LifeVar
	push 0020d ;[XWidth]
	push 0020d ;[YHeight]
	push 0280d ;[CurrentX]
	push 0000d ;[CurrentY]
	call PrintObject
	L1: ; 1 life
	push offset LifeVar	
	push 0020d ;[XWidth]
	push 0020d ;[YHeight]
	push 0300d ;[CurrentX]
	push 0000d ;[CurrentY]
	call PrintObject	

	pop bp
	ret 
endp process_Life


; -------------------------------------------------
			; Print Banner Procedure:
; -------------------------------------------------
; The procedure will print black banner to clear the up part, then will call print the life
; icons by the number of life you got. In addition, the procedure will print the current score
; and the highest score ever riched 
; Changes: Nothing

	proc PrintBanner	
		
		pusha ; Backup the registers
		
		call process_Life
		
		; Get into the beginning of the line:
		
		mov ah, 2
		mov bh, 0
		mov dh, 0
		mov dl, 0
		int 10h
		; Print the string "Score: "
		mov dx, offset scoreMsg
		mov ah, 9
		int 21h
		
		push [Score]
		push offset SString
		call Num2String
		mov dx, offset SString
		mov ah, 9
		int 21h
		
		; New line
		mov dl, 10
		mov ah, 02
		int 21h
		; Beginnning of line:
		mov dl, 13
		mov ah, 02h
		int 21h
		
		mov dx, offset HsMsg
		mov ah, 9
		int 21h
		
		push [HighScore]
		push offset SString
		call Num2String
		mov dx, offset SString
		mov ah,9
		int 21h
			
		popa; recover the registers		
		ret
	endp PrintBanner
	
	
; -------------------------------------------
 ; ___      ___  _       ____  __ __      ____   ____    ___      __    ___  ___    __ __  ____     ___ 
; |   \    /  _]| |     /    ||  |  |    |    \ |    \  /   \    /  ]  /  _]|   \  |  |  ||    \   /  _]
; |    \  /  [_ | |    |  o  ||  |  |    |  o  )|  D  )|     |  /  /  /  [_ |    \ |  |  ||  D  ) /  [_ 
; |  D  ||    _]| |___ |     ||  ~  |    |   _/ |    / |  O  | /  /  |    _]|  D  ||  |  ||    / |    _]
; |     ||   [_ |     ||  _  ||___, |    |  |   |    \ |     |/   \_ |   [_ |     ||  :  ||    \ |   [_ 
; |     ||     ||     ||  |  ||     |    |  |   |  .  \|     |\     ||     ||     ||     ||  .  \|     |
; |_____||_____||_____||__|__||____/     |__|   |__|\_| \___/  \____||_____||_____| \__,_||__|\_||_____|
                                                                                                      
; -------------------------------------------

proc DelayMe

	pusha ; Backup the registers
	
	cmp [Score], 5d ; If the user didn't reach the score of 20 use a big delay - slower game
	jb NormalSpeed
	cmp [Score], 10d ; If he riched 20 but didn't riched 40 use a bit less delay- will fast his game
	jb Fast
	cmp [Score], 20d ; If he got below 70 he is an advanced player - Make it faster
	jb Faster
	cmp [Score], 30d
	jb ReallyFast
	cmp [Score], 40d
	jb Flash
	jmp Fastest ; Do it the fastest- Still using a delay for natural looking and option to get a score
	
NormalSpeed:
	mov cx, 0
	mov dx, 4450h
	mov ah, 86h
	int 15h
	jmp EndDelayMe
Fast:
	mov cx, 0
	mov dx, 4365h
	mov ah, 86h
	int 15h
	jmp EndDelayMe
Faster:
	mov cx, 0
	mov dx, 3400h
	mov ah, 86h
	int 15h
	jmp EndDelayMe
	
ReallyFast:
	mov cx, 0
	mov dx, 2400h
	mov ah, 86h
	int 15h
	jmp EndDelayMe
	
Flash:
	mov cx, 0
	mov dx, 0478h
	mov ah, 86h
	int 15h
	
Fastest:
	mov cx, 0
	mov dx, 0478h
	mov ah, 86h
	int 15h

EndDelayMe:	
	popa ; Recover the registers
	ret
endp DelayMe
	
	
; ----------------------------------------
;			 "Delete" Fruit
; ----------------------------------------
	
proc DeleteFruit
	push bp
	mov bp, sp
	
	push si
	push di
	
	xor si, si ; reset si for count x
	xor di, di ; reset di for count y
	
	 ; Becasue the mouse hover sometimes the fruit is smeared (נמרח). To fix it I will print around the fruit too.
	mov cx, [CurrentX]
	sub cx, 20d
	mov dx, [CurrentY]
	sub dx, 20d
	
DeleteMyFruit:
	mov al, 6d
	mov bh, 0h ; Print
	mov ah, 0ch
	
	cmp dx, 20d
	jb endDeleteFruit
	cmp dx, 199d
	ja endDeleteFruit
	
	
	int 10h
	
	inc si ; inc counter
	inc cx ; inc cx
	cmp si, 80d ; The fruit length is 60+ 20 in addition to fix the mouse issue
	jne DeleteMyFruit
	mov cx, [CurrentX]
	xor si, si
	inc di
	inc dx
	cmp di, 80d  ;The fruit height is 60+ 20 in addition to fix the mouse issue
	jne DeleteMyFruit
	
endDeleteFruit:	
	pop di
	pop si
	
	pop bp
	ret 
endp DeleteFruit
	




 ; ____    ____  ____   ___     ___   ___ ___  ____  _____    ___      ____   ____    ___      __    ___  ___    __ __  ____     ___   _____
; |    \  /    ||    \ |   \   /   \ |   |   ||    ||     |  /  _]    |    \ |    \  /   \    /  ]  /  _]|   \  |  |  ||    \   /  _] / ___/
; |  D  )|  o  ||  _  ||    \ |     || _   _ | |  | |__/  | /  [_     |  o  )|  D  )|     |  /  /  /  [_ |    \ |  |  ||  D  ) /  [_ (   \_ 
; |    / |     ||  |  ||  D  ||  O  ||  \_/  | |  | |   __||    _]    |   _/ |    / |  O  | /  /  |    _]|  D  ||  |  ||    / |    _] \__  |
; |    \ |  _  ||  |  ||     ||     ||   |   | |  | |  /  ||   [_     |  |   |    \ |     |/   \_ |   [_ |     ||  :  ||    \ |   [_  /  \ |
; |  .  \|  |  ||  |  ||     ||     ||   |   | |  | |     ||     |    |  |   |  .  \|     |\     ||     ||     ||     ||  .  \|     | \    |
; |__|\_||__|__||__|__||_____| \___/ |___|___||____||_____||_____|    |__|   |__|\_| \___/  \____||_____||_____| \__,_||__|\_||_____|  \___|
                                                                                                                                          

; Creates a random number by the system hour (int 21h) miliseconds (1/100 of seconds)
; Changes: The random number is in DX

proc Randomize

	push bp
	mov bp, sp
	
	; backup the registers:
	push bx
	push cx
	push si
	
	xor dx,dx
	
	mov ah, 2ch
	int 21h
	mov al, dh ;1/100 of Seconds
	mul [RandomSeed]	;ax = al*17h
	
	xor bx, bx
	mov bl, al
	mul bx ;dx:ax = al*al
	
	; Recover the registers:
	pop si
	pop cx
	pop bx
	
	pop bp
	ret 
endp Randomize


; Create a new random x via Randomize proc:
; Chanages: CurrentX
proc process_xRandom
	pusha ; Save registers
	call Randomize
	mov bx, 321 ; (max - min + 1) + min == (320 - 0 +1 ) +0
	div bx ;dx has the random number
	mov [CurrentX], dx
	popa ; Recover registers
endp process_xRandom

; Create a new incidator for a random y via Randomize proc:
; Changes: CurrentY
proc process_yRandom
	pusha ; Save registers
	call Randomize
	shr dx, 1
	jc UpY
	mov [CurrentY], 0
	jmp EndprocessY
UpY:
	mov [CurrentY], 1

EndprocessY:
	popa ; Recover registers
	ret
endp process_yRandom 

proc RandomFruit
	pusha ; Backup the registers
	
	call Randomize
	mov bx, 321d
	div bx
	
	cmp dx, 100d
	jb WaterMelon
	cmp dx, 200d
	jb EqLemon
	cmp dx, 320d
	jb EqApple
	
	jmp EndProcessFruit
WaterMelon:
	mov [CFFruit], offset WM
	mov [CBFruit], offset WMB
	jmp EndRandomFruit
EqLemon:
	mov [CFFruit], offset Lemon
	mov [CBFruit], offset BLemon
	jmp EndRandomFruit
EqApple:
	mov [CFFruit], offset Apple
	mov [CBFruit], offset BApple
	
EndRandomFruit:
	popa
	ret
endp RandomFruit

;--------------------------------------------------------
 ; _____   ____  _      _      ____  ____    ____      _____  ____   __ __  ____  ______ 
; |     | /    || |    | |    |    ||    \  /    |    |     ||    \ |  |  ||    ||      |
; |   __||  o  || |    | |     |  | |  _  ||   __|    |   __||  D  )|  |  | |  | |      |
; |  |_  |     || |___ | |___  |  | |  |  ||  |  |    |  |_  |    / |  |  | |  | |_|  |_|
; |   _] |  _  ||     ||     | |  | |  |  ||  |_ |    |   _] |    \ |  :  | |  |   |  |  
; |  |   |  |  ||     ||     | |  | |  |  ||     |    |  |   |  .  \|     | |  |   |  |  
; |__|   |__|__||_____||_____||____||__|__||___,_|    |__|   |__|\_| \__,_||____|  |__|  
                                                                                       
; Every time the fruit is getting in, it suppose to get down and exit.
; I made a universal procedure that will do it to me
; Changes: None


proc FallingFruit

	push bp
	mov bp, sp
	
FallLoop:
	call process_Frame
	inc [CurrentY]
	cmp [CurrentY], 201d 
	jb FallLoop
	
	pop bp
	ret 
	endp FallingFruit

 ; ___ ___   ___   __ __   _____   ___      __ __  ____  ______ 
; |   |   | /   \ |  |  | / ___/  /  _]    |  |  ||    ||      |
; | _   _ ||     ||  |  |(   \_  /  [_     |  |  | |  | |      |
; |  \_/  ||  O  ||  |  | \__  ||    _]    |  _  | |  | |_|  |_|
; |   |   ||     ||  :  | /  \ ||   [_     |  |  | |  |   |  |  
; |   |   ||     ||     | \    ||     |    |  |  | |  |   |  |  
; |___|___| \___/  \__,_|  \___||_____|    |__|__||____|  |__|  
                                                              
; Comparing mouse click and mouse position by int 33h:
; If the user did left click on the object location, Increase "TimesTouched"
; Changing: TimesTouched
	
proc CompareMouseHit
	push bp
	mov bp, sp
	
	; Backup the registers
	push ax 
	push bx 
	push cx
	push dx
    push si
	push di

	; mov ax, 1h
	; int 33h

	xor bx,bx
	
	mov ax,3h
	int 33h
	
	and bx, 00000001b ; Check left mouse click, If didn't there is no reason to continue
	jz ExitCompareMouseHit
	
	; cmp bx, 1
	; jne ExitCompareMouseHit
	
	; cx points the X *2, To fix it I will use:
	shr cx,1
	; dx points the Y
		
	;Compare to the minumum X:
	cmp cx, [CurrentX]
	jb ExitCompareMouseHit
	; Compare to the maximum X:
	mov ax, [CurrentX]
	add ax, [XWidth]
	cmp cx, ax
	ja ExitCompareMouseHit
	
	; Compare to the minimum Y:
	cmp dx, [CurrentY] 
	jb ExitCompareMouseHit 
	; Compare to the maximum Y:
	mov ax, [CurrentY] 
	add ax, [YHeight]
	cmp dx, ax
	ja ExitCompareMouseHit
	
	; If the mouse have clicked inside the fruit zone, add the point and change the variable to clicked

	inc [TimesTouched]
	
ExitCompareMouseHit:
	; Recover the registers
    pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	
	pop bp 	
	ret
endp CompareMouseHit
	


  ; _____ ______  ____   ____  ____    ____      ______   ___       ____   __ __  ___ ___  ____     ___  ____  
 ; / ___/|      ||    \ |    ||    \  /    |    |      | /   \     |    \ |  |  ||   |   ||    \   /  _]|    \ 
; (   \_ |      ||  D  ) |  | |  _  ||   __|    |      ||     |    |  _  ||  |  || _   _ ||  o  ) /  [_ |  D  )
 ; \__  ||_|  |_||    /  |  | |  |  ||  |  |    |_|  |_||  O  |    |  |  ||  |  ||  \_/  ||     ||    _]|    / 
 ; /  \ |  |  |  |    \  |  | |  |  ||  |_ |      |  |  |     |    |  |  ||  :  ||   |   ||  O  ||   [_ |    \ 
 ; \    |  |  |  |  .  \ |  | |  |  ||     |      |  |  |     |    |  |  ||     ||   |   ||     ||     ||  .  \
  ; \___|  |__|  |__|\_||____||__|__||___,_|      |__|   \___/     |__|__| \__,_||___|___||_____||_____||__|\_|
                                                                                                             
 ; (0-65536)
;-------------------------------------------------
; The procedure takes the number and split the number every time in the loop, 
;adding 48d (which is the ascii code of 0) and adding
;it in the reserved way in the array (Because then it shows the opposite way)
; Changes: None

Number equ [bp+6]
StringAdd equ [bp+4]

proc Num2String
	
	push bp
	mov bp,sp
	;Backup the registers:
	push ax
	push bx
	push dx
	push si
	; ---------------------------
	
	
	xor si, si
	xor bx, bx
	xor cx, cx
	
	mov si, 5d
	mov ax, Number ; Move the first number ax - There he will be divided
numLoop:
	xor dx, dx ; Reset dx from old data
	mov bx, 10d ; move the dividor into bx
	div bx ; Divide bx ax
	dec si ; Decrease the current place
	mov bx, StringAdd ; Get the array offset into bx - will be used to copy
	mov [byte ptr bx+si], 48d ; The same place is used many times- to fix it, reset the current place at the array to '0'
	add [byte ptr bx+si], dl ; Add the digit to the array
	cmp si, 0000d ; Compare to the end of the array - if didn't finish jump to numLoop
	jne numLoop
	
	; ----------------------------
	;Recover the registers:
	pop si
	pop dx
	pop bx
	pop ax
	
	pop bp
	ret 4
endp Num2String


  ; _____    __   ___   ____     ___      ____   ____    ___      __    ___  ___    __ __  ____     ___   _____
 ; / ___/   /  ] /   \ |    \   /  _]    |    \ |    \  /   \    /  ]  /  _]|   \  |  |  ||    \   /  _] / ___/
; (   \_   /  / |     ||  D  ) /  [_     |  o  )|  D  )|     |  /  /  /  [_ |    \ |  |  ||  D  ) /  [_ (   \_ 
 ; \__  | /  /  |  O  ||    / |    _]    |   _/ |    / |  O  | /  /  |    _]|  D  ||  |  ||    / |    _] \__  |
 ; /  \ |/   \_ |     ||    \ |   [_     |  |   |    \ |     |/   \_ |   [_ |     ||  :  ||    \ |   [_  /  \ |
 ; \    |\     ||     ||  .  \|     |    |  |   |  .  \|     |\     ||     ||     ||     ||  .  \|     | \    |
  ; \___| \____| \___/ |__|\_||_____|    |__|   |__|\_| \___/  \____||_____||_____| \__,_||__|\_||_____|  \___|
                                                                                                             

;----------------------------------------------------------
; Opens the high score file via int 21 to write and read
; If some how the file is deleted, create a new one
;----------------------------------------------------------
; Changes: None

proc OpenRWFile 
pusha
 mov  ah, 3Dh 
 mov  al, 2 
 mov  dx, offset HFile
 int  21h 
 jc CreateAfile
 mov  [filehandle], ax 
 popa
 ret 
CreateAfile: 

 mov dx, offset HFile
 mov cx, 0
 mov ah, 3Ch
 int 21h
 mov [filehandle], ax
 jc error_msg
 
 mov ah, 3Eh
 mov bx, [filehandle]
 int 21h
 popa
 ret
error_msg: 
 mov dx, offset ErrorMsg 
 mov ah, 9h 
 int 21h
 
 
popa 
 ret  
endp OpenRWFile

;-----------------------------------------------------------
; Use int 21h to write the array into the file - Procedure
;-----------------------------------------------------------

proc WriteToFile
pusha  
; Write message to file 
 mov ah,40h 
 mov bx, [filehandle] 
 mov cx,5 ; Bytes 
 mov  dx,offset Score 
 int  21h                      
 popa
 ret 
endp WriteToFile  


;---------------------------------------------------------
; 			Read File using int 21h
;---------------------------------------------------------
proc ReadFile  
pusha
; Read file 
 mov ah,3Fh 
 mov bx, [filehandle]
 mov cx,5
 mov  dx,offset HighScore
 int  21h  
popa 
 ret 
endp ReadFile


;---------------------------------------------
; 		Compare High score with current - Procedure
;----------------------------------------------

proc CompareScore
	
	pusha ; Backup registers
	
	xor ax, ax
	mov ax, [Score]
	cmp [HighScore], ax
	ja ExitCompareScore
	
	mov [HighScore], ax
	call OpenRWFile
	call WriteToFile
	call CloseFile
ExitCompareScore:
	popa ; Recover registers
	ret
endp CompareScore
;--------------------------------------------------------------
    ; __  _       ___    _____   ___      _____  ____  _        ___   _____
   ; /  ]| |     /   \  / ___/  /  _]    |     ||    || |      /  _] / ___/
  ; /  / | |    |     |(   \_  /  [_     |   __| |  | | |     /  [_ (   \_ 
 ; /  /  | |___ |  O  | \__  ||    _]    |  |_   |  | | |___ |    _] \__  |
; /   \_ |     ||     | /  \ ||   [_     |   _]  |  | |     ||   [_  /  \ |
; \     ||     ||     | \    ||     |    |  |    |  | |     ||     | \    |
 ; \____||_____| \___/   \___||_____|    |__|   |____||_____||_____|  \___|
                                                                         
;----------------------------------------------
proc CloseFile
  ; Backup the registers:
  pusha ; Equal to push ax, cx, dx, bx, sp, bp, si, di
  
  ; Close the file by int 21h:
  mov ah,3Eh
  mov bx, [filehandle]
  int 21h
  
  ; Recover the registers:
  popa ; Equal to pop di, si, bp, sp, bx, dx, cx, ax
  ret
endp CloseFile