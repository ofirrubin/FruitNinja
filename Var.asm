; ~Program variabels~
; Prints:
CurrentX dw 00d
CurrentY dw 00d
XWidth dw 0060d
YHeight dw 0060d
TimesToCenter db 0000
include "Objects.asm"
;-------------------
; BMP Variables:
menu db "menub.bmp", 0
help db  "helpb.bmp", 0
gameover db "GameOver.bmp",0
fileHandle dw ?
Header db 54 dup (0)
Palette db 256*4 dup (0)
ScrLine db 320 dup (0)
ErrorMsg db 'Error',13, 10,'$'
;-------------------
; Random number
RandomNumber dw 0000d
RandomSeed db 17h
;------------------
; Game variables
; UI:

scoreMsg db "Score: $" ; Score message
HsMsg db "H. Score: $" ; High score message
HighScore dw 0000 ; High Score - Number

Life db 3d
Score dw 00000d ; Score - Number


SString db 5 dup('0'),'$' ; Score string
HFile db "High.txt",0 ; The name of the file that saves the highest score

CFFruit dw 00 ; Current Full Fruit
CBFruit dw 00; Current Broken Fruit

; Tool Variables:
TimesTouched db 0000