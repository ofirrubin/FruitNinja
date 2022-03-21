IDEAL
MODEL small
P186
STACK 100h
DATASEG
include "Var.asm"
CODESEG
include "Procs.asm"
start:
	mov ax, @data
	mov ds, ax
	
	; Get the last highest score from the "high.txt" file into HScore variable
	push offset HFile ; (Choose the file by giving it the adress)
	call OpenFile ; Open the file - Read only
	call ReadFile ; Get the data into HScore
	call CloseFile ; Close "high.txt"

	; Graphic mode:
	mov ax, 13h
	int 10h

	process_bmp menu
	
	include "menu.asm" ; The file includes all the menu stuff and includes the play file

ClickedExit: ; If the user clicked exit, close the bmp and return to text mode:

	; Close the menu bmp:
	call CloseFile
	
	; Exit the graphics mode:
	mov ah, 0
	mov al, 2
	int 10h
exit:
	mov ax, 4c00h ; End the process with return code
	int 21h
END start


