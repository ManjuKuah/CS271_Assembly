TITLE Extra Credit     (ArrowGame.asm)

; Author: Manju Kuah
; Course / Project ID  Arrow Clicking game      Date: 3/18/19
; Description:

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data

intro1			BYTE		"Extra Credit Game			Programmed by Manju Kuah" , 0
intro2			BYTE		"The goal of the game is to reach the required score by pressing the correct arrow key. You have three lives." , 0
scoredisplay	BYTE		"Score: " , 0
score			DWORD		0		
random			DWORD		?
continue		BYTE		"Press any key to begin level..." , 0
level			DWORD		1
leveldisplay	BYTE		"Current Level: " , 0
goal			DWORD		30
goaldisplay		BYTE		"Goal: " , 0
space			BYTE		"	" , 0
seconds			DWORD		?
overmessage		BYTE		"Game Over!" , 0
highestlevel	BYTE		"Your highest level is: " , 0
lives			BYTE		"Lives: ", 0
livesNum		DWORD		3
spaces			BYTE		"		", 0

endl			EQU			<0dh,0ah>	; end of line sequence
RightArrow		LABEL BYTE
				BYTE		"		    .		  ",endl
				BYTE		"	............;;.   ",endl
				BYTE		"	::::::::::::;;;;. ",endl
				BYTE		"	::::::::::::;;:'  ",endl
				BYTE		"		    :'		  ",endl
messageSize		DWORD		($-RightArrow)
consoleHandle	HANDLE		0     ; handle to standard output device
bytesWritten	DWORD		?      ; number of bytes written

LeftArrow		LABEL BYTE
				BYTE		"	   .			  ",endl
				BYTE		"	 .;;.............  ",endl
				BYTE		"	.;;;;::::::::::::  ",endl
				BYTE		"	':;;:::::::::::::  ",endl
				BYTE		"	  ':			  ",endl
UpArrow			LABEL BYTE
				BYTE	"		     .		",endl
				BYTE	"		   .:;:.	",endl
				BYTE	"		 .:;;;;;:.	",endl
				BYTE	"		   ;;;;;	",endl
				BYTE	"		   ;;;;;	",endl
				BYTE	"		   ;;;;;	",endl
				BYTE	"		   ;;;;;	",endl
				BYTE	"		   ;;;;;	",endl
DownArrow		LABEL BYTE
				BYTE	"		   ;;;;;	",endl
				BYTE	"		   ;;;;;	",endl
				BYTE	"		   ;;;;;	",endl
				BYTE	"		   ;;;;;	",endl
				BYTE	"		 ..;;;;;..	",endl
				BYTE	"		  ':::::'	",endl
				BYTE	"		    ':'		",endl
downSize		DWORD		($-DownArrow)





.code

intro PROC					;procedure to display intro
mov		edx, OFFSET	intro1
call	WriteString			; write a string pointed to by EDX
call	Crlf				; new line
mov		edx, OFFSET intro2
call	WriteString			; write a string pointed to by EDX
call	Crlf				; new line
call	Crlf				; new line
ret
intro ENDP

game PROC		;main game procedure
NextLevel:
mov		edx, OFFSET leveldisplay
call	WriteString			; write a string pointed to by EDX
mov		eax, level
call	WriteDec			; write the level
mov		edx, OFFSET space
call	WriteString			; write a string pointed to by EDX
mov		edx, OFFSET goaldisplay
call	WriteString			; write a string pointed to by EDX
mov		eax, goal
call	WriteDec			;Write the goal
call	Crlf				; new line

mov		edx, OFFSET continue
call	WriteString			; write a string pointed to by EDX
call	Crlf				; new line
call	ReadChar			;wait for a userinput

mov		edx, OFFSET scoredisplay
call	WriteString			; write a string pointed to by EDX
mov		eax, score
call	WriteDec
mov		edx, OFFSET spaces
call	WriteString			; write a string pointed to by EDX
mov		edx, OFFSET lives
call	WriteString			; write a string pointed to by EDX
mov		eax, livesNum
call	WriteDec
call	Crlf				; new line
call	Crlf				; new line

Generate:				;Generate a random arrow direction
;Part of code for generate random number from 0 until 3
mov		eax, 4			;get random 0 to 3
call	Randomize		;re-seed generator
call	RandomRange   
mov		random, eax		;save random number

cmp		random, 0		
je		displayRight	;if random = 0, jump
cmp		random, 1
je		displayLeft		;if random = 1, jump
cmp		random, 2
je		displayUp		;if random = 2, jump
cmp		random, 3
je		displayDown		;if random = 3, jump

displayRight:						;If rng is 0
	INVOKE WriteConsole,
		consoleHandle,				;console output handle
		ADDR RightArrow,       		; string pointer
		messageSize,				; string length
		ADDR bytesWritten,			; returns num bytes written
		0							; not used
	jmp		Start

displayLeft:						;If rng is 1
	INVOKE WriteConsole,
		consoleHandle,				;console output handle
		ADDR LeftArrow,       		; string pointer
		messageSize,				; string length
		ADDR bytesWritten,			; returns num bytes written
		0							; not used
	jmp		Start
displayUp:							;If rng is 2
	INVOKE WriteConsole,
		consoleHandle,				;console output handle
		ADDR UpArrow,       		; string pointer
		messageSize,				; string length
		ADDR bytesWritten,			; returns num bytes written
		0							; not used
	jmp		Start

displayDown:						;If rng is 3
	INVOKE WriteConsole,
		consoleHandle,				;console output handle
		ADDR DownArrow,       		; string pointer
		downSize,				; string length
		ADDR bytesWritten,			; returns num bytes written
		0							; not used
	jmp		Start




Start:								;Start of game where player inputs a direction
	call	ReadChar				;Read an input
	cmp		ah, 48H					; Up Arrow Key.
	je		Up					
	cmp		ah, 50H					; Down Arrow Key
	je		Down
	cmp		ah, 4DH					; Right Arrow Key
	je		Right
	cmp		ah, 4BH					; Left Arrow Key
	je		Left
	jmp		Start

Right:
	cmp		random, 0				;Test to see if input is correct
	je		Correct
	jmp		Wrong
Left:
	cmp		random, 1				;Test to see if input is correct
	je		Correct
	jmp		Wrong
Up:
	cmp		random, 2				;Test to see if input is correct
	je		Correct
	jmp		Wrong

Down:
	cmp		random, 3				;Test to see if input is correct
	je		Correct
	jmp		Wrong

Correct:								;If the player input correctly
	call	Crlf						; new line
	inc		score						; add 1 to score
	mov		eax, score					;move score to eax
	cmp		eax, goal					; test to see if score = goal
	jge		Next						;Jump if player has reached the goal
	mov		edx, OFFSET scoredisplay
	call	WriteString					;Display String
	mov		eax, green					;Green Color for correct
	call	SetTextColor
	mov		eax, score
	call	WriteDec					;Write the current score
	mov		eax, white					;Reset text to White Color
	call	SetTextColor
	mov		edx, OFFSET spaces
	call	WriteString	
	mov		edx, OFFSET lives
	call	WriteString	
	mov		eax, livesNum
	call	WriteDec
	call	Crlf						;new line
	jmp		Generate					;Loop back to generate a new arrow


Wrong:						;If the player gives a wrong input
	dec		livesNum
	call	Crlf			;new line
	cmp		livesNum, 0		;Check to see if the player has enough lives
	je		Gameover		;End game if dead
	cmp		score, 0		;Check if score is still 0
	je		Zero			;jump if score is 0
	dec		score
	mov		edx, OFFSET scoredisplay
	call	WriteString
	mov		eax, red		;Set Red Text Color for incorrect
	call	SetTextColor			
	mov		eax, score
	call	WriteDec
	mov		eax, white		;Reset to White Color
	call	SetTextColor
	mov		edx, OFFSET spaces
	call	WriteString	
	mov		edx, OFFSET lives
	call	WriteString	
	mov		eax, livesNum
	call	WriteDec
	call	Crlf					
	jmp		Generate
Zero:						;If player score is already zero
	dec		livesNum
	mov		edx, OFFSET scoredisplay
	call	WriteString
	mov		eax, red		;Set Text Color
	call	SetTextColor			
	mov		eax, score		;move score to eax
	call	WriteDec		;display score
	call	Crlf			;new line
	mov		eax, white		;White Color
	call	SetTextColor	;Set text color back to white
	mov		edx, OFFSET spaces
	call	WriteString	
	mov		edx, OFFSET lives
	call	WriteString	
	mov		eax, livesNum
	call	WriteDec
	call	Crlf					
	jmp		Generate
Next:						;If the player has reached the goal and is going to the next level
	inc		level			;increment the level
	mov		score, 0		;set score back to 0
	mov		eax, goal		;moves goal to eax
	add		eax, 5			;add 5 to eax
	mov		goal, eax		;save eax back to goal
	jmp		NextLevel




Gameover:
	ret
game ENDP

GameFinish	PROC	;procedure when the player loses the game
mov		edx, OFFSET overmessage
call	WriteString
call	Crlf
mov		edx, OFFSET highestlevel
call	WriteString
mov		eax, level
call	WriteDec
call	Crlf

ret
GameFinish	ENDP


main PROC
; Get the console output handle:
INVOKE GetStdHandle, STD_OUTPUT_HANDLE
mov consoleHandle,eax

call intro
call game
call GameFinish



	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
