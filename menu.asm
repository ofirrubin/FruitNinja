ResetMouse:
	; Get into Mouse mode again - Decrease the lag and reset the mouse
	mov ax, 0h
	int 33h
	mov ax, 1h
	int 33h
	
MenuComp:
	; Check mouse details:
	xor bx,bx
	
	mov ax,3h
	int 33h
	
	; Check click:
	cmp bx, 01h
	jne MenuComp
	
	shr cx, 1 ; The button returns in 640x200, div the X by two to get the "real" one
	
	; All buttons have the same X, Check if the mouse between:
	cmp cx,94d 
	jb MenuComp
	cmp cx, 226d 
	ja MenuComp
	
	; Check Y:
	;if it's above 102, he is not hitting any button
	cmp dx,70d
	jb MenuComp
	cmp dx, 97d
	; if he is hitting above 122 means he hit between 102-122: Clicked on play
	jb ClickedPlay
	; If he is above 122 and below 134 he hit the background - Go back
	cmp dx, 106d
	jb MenuComp
	; If he hit above 134 and below 154: Clicked on help
	cmp dx,134d
	jb ClickedHelp	
	; If the user clicked above 170 and below 143, the user clicked exit
	cmp dx,143d
	jb MenuComp
	cmp dx, 170d
	ja CompareReset
	jmp ClickedExit
CompareReset:
	cmp dx, 175d
	jb MenuComp
	cmp dx, 198d
	ja MenuComp 
	
	mov [HighScore], 0000d
	call OpenRWFile
	call WriteToFile
	call CloseFile
	jmp MenuComp
	
ClickedHelp:
	mov ax, 2d
	int 33h
	call CloseFile
	process_bmp help
	
	
	;WaitForKey:
	mov   ah,01H
	int   21h
	call CloseFile
	process_bmp menu
	jmp ResetMouse ; After rewrite the menu jump to wait a key 
	
	
ClickedPlay:
	; Graphic mode:
	mov ax, 13h
	int 10h
	
	include "Play.asm"
	mov ax, 2d
	int 33h
	process_bmp gameover
	;WaitForKey:
	mov   ah,01h
	int   21h
	call CloseFile
	process_bmp menu
	jmp ResetMouse ; After rewrite the menu jump to wait a key 