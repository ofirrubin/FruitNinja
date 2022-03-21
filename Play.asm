

	; Print the background of the game:
	push 0006d ; Color
	push 0320d ; Width
	push 0200d ; Hight
	push 0000d ;X
	push 0020d ;Y
	call PrintProc
	
	; Get into mouse mode:
	mov ax,0h
	int 33h
	
	mov ax, 1h
	int 33h

	call PrintBanner
	mov [Life],0003d
	mov [Score], 0000d
	
MainLoop:
	
	call RandomFruit ; The procedure will choose the current fruit
	
	cmp [Life], 0d ; Compare the current life counter - if it's equal to 0 means the game over, exit.
	jne GameStarts 
	jmp ExitPlay

GameStarts:	
	mov [TimesTouched], 0000d ; Reset the number of times the user touched the object because there is a new one
	mov [TimesToCenter],0000d ; Reset TimesToCenter (Can't xor a var)
	
	call process_xRandom ; Create a new random x
	cmp [CurrentX], 160d ; if the x is above 160 that means we are on the right side, else on the left
	ja RightSide
	jmp LeftSide

 RightSide:
		
		call process_yRandom ; Create a new random y indicator - if the indicator equal to 1 - down, 0 -up
		cmp [CurrentY], 1
		je SetRightDown

	mov [CurrentY], 00000d ; Start from up
	RightUp:
			call process_Frame ; Process the current frame
			dec [CurrentX] ; Increase the current X
			inc [CurrentY] ; Increase the current Y
			cmp [TimesToCenter], 70d ; Compare time to center to 70 - I chose 
			jb RightUp 
		
			mov [TimesToCenter],0000d ; Reset TimesToCenter (Can't xor a var)
			call FallingFruit ; The procedure calls "process_Frame" with inc [CurrentY] tile getting out of the screen
			jmp ExitLoops
		
	SetRightDown:
		add [CurrentX], 10d ; To make it look center add 10 to the x (I don't want it to add too much)
		mov [CurrentY], 200d ; The random got down so set as down.
	RightDown:
			call process_Frame ; Process the current frame
			dec [CurrentX] ; Increase the current X
			dec [CurrentY] ; Increase the current Y
			cmp [TimesToCenter], 90d ; Compare time to center to 90 - I chose 
			jb RightDown 
			 
			mov [TimesToCenter],0000d ; Reset TimesToCenter (Can't xor a var)
			call FallingFruit; The procedure calls "process_Frame" with inc [CurrentY] tile getting out of the screen
			jmp ExitLoops

	LeftSide:
	
		call process_yRandom ; Create a new y indicator- if equal to 1- down, 0 - up
		cmp [CurrentY], 0 
		je SetLeftUp
		
		mov [CurrentY], 200d ; Set as down
			LeftDown:
			call process_Frame ; Process the current frame
			inc [CurrentX] ; Increase the current X
			dec [CurrentY] ; Increase the current Y
			cmp [TimesToCenter], 120d ; Compare time to center to 120 - I chose 
			jb LeftDown 
		 
			call FallingFruit ; The procedure calls "process_Frame" with inc [CurrentY] tile getting out of the screen
			jmp ExitLoops

		SetLeftUp:
			mov [CurrentY], 0000d ; Set as up
		
			LeftUp:
			call process_Frame ; Process the current frame
			inc [CurrentX] ; Increase the current X
			inc [CurrentY] ; Increase the current Y
			cmp [TimesToCenter], 90d ; Compare time to center to 90 - I chose 
			jb LeftUp 
		 
			mov [TimesToCenter],0000d ; Reset TimesToCenter (Can't xor a var)
			call FallingFruit ; The procedure calls "process_Frame" with inc [CurrentY] tile getting out of the screen
					
				
ExitLoops:
	
	cmp [TimesTouched],6d ; I chose that less than 6 touches the user failed hit the fruit because he need to swipe.
	jb Failed

	inc [Score] ; Increase the score
	jmp MainLoop
Failed:	
	dec [Life] ; Decrease the life counter
	; Fix the life indicator - delete old life icon
	push 0000d ;Color
	push 0100d ; Width
	push 0018d ; Hight
	push 0260d ; X
	push 0000d ; Y

	call PrintProc
	
	jmp MainLoop
	
ExitPlay:
	call CompareScore