;	PROG - 2: STACK CALCULATOR
;	NAME: SHAMITH ACHANTA  (shamith2)
;	PARTNERS: ahossa5 , bryanfk2

; starting at address x3000

				.ORIG x3000

; clearing all registers
	
				AND R0, R0, #0
				AND R1, R1, #0
				AND R2, R2, #0
				AND R3, R3, #0
				AND R4, R4, #0
				AND R5, R5, #0
				AND R6, R6, #0

; starting evalution subroutine
				
				JSR EVALUATE_1

SAVE_R7			.FILL x0000

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;R3- value to print in hexadecimal
PRINT_HEX
; subroutine for priting result
; in hexadecimal notation
	
			ST R7, SAVE_R7			
			AND R1, R1, #0
			AND R2, R2, #0
			AND R4, R4, #0

			ADD R1, R1, #4
DIGIT_LOOP  ADD R2, R2, #4	; group bits into 4
			BRnzp #2
BIT_LOOP    ADD R3, R3, R3
			ADD R4, R4, R4	; loop for individual bits
			ADD R3, R3, #0
			BRn ADD_NEG
			ADD R4, R4, #0
			BRnzp #1

ADD_NEG     ADD R4, R4, #1
			ADD R2, R2, #-1
			BRnp BIT_LOOP
			ADD R5, R4, #-9
			BRnz PRINT
			AND R5, R5, #0
			LD R5, NUM_1
			ADD R0, R4, R5
			OUT
			AND R5, R5, #0
			BRnzp OUTER_LOOP

PRINT       AND R5, R5, #0
			LEA R0, SPACE_1
			PUTS			; printing space before every bit
			AND R0, R0, #0
			LD R5, NUM_2
			ADD R0, R4, R5
			OUT				; priting one bit of result
							; at a time

			AND R5, R5, #0
OUTER_LOOP  AND R0, R0, #0
			AND R4, R4, #0
			ADD R3, R3, R3
			ADD R1, R1, #-1
			BRnp DIGIT_LOOP

			LD R5, FINAL_RESULT
			LD R7, SAVE_R7
			HALT

NUM_1 .FILL #55
NUM_2 .FILL #48
SPACE_1 .STRINGZ " "

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;R0 - character input from keyboard
;R6 - current numerical output
;
;
EVALUATE_1
			
;	print " ->" before starting the calculator
			
			ST R7, SAVE_R7
			LEA R0, SPACE_2
			PUTS

EVALUATE
; subroutine for checking operators
; (+, -, *, /, ^) and calculating accordingly
						
			ST R7, SAVE_R7			; printing space before priting every input
			LEA R0, SPACE_1
			PUTS
			AND R0, R0, #0
		
			GETC					; priting out the input
			OUT
			
			LD R1, ADDN				; check for plus sign and if true, jump to PLUS
			NOT R1, R1
			ADD R1, R1, #1
			ADD R1, R1, R0
			BRnp #2
			JSR PLUS
			JSR EVALUATE

			LD R1, MINUS			; check for " - " sign and if true, jump to MIN
			NOT R1, R1				; 	(subtraction)
			ADD R1, R1, #1
			ADD R1, R1, R0
			BRnp #2
			JSR MIN
			JSR EVALUATE
	
			LD R1, MULT				; check for " * " sign and if true, jump to MUL
			NOT R1, R1				;  (multiplication)
			ADD R1, R1, #1
			ADD R1, R1, R0
			BRnp #2
			JSR MUL
			JSR EVALUATE
	
			LD R1, DIVIDE			; check for " / " sign and if true, jump to DIV			
			NOT R1, R1				;  (division)
			ADD R1, R1, #1
			ADD R1, R1, R0
			BRnp #2
			JSR DIV
			JSR EVALUATE
	
			LD R1, EXPONENT	         ; check for " ^ " sign and if true, jump to EXP	
			NOT R1, R1				 ;   (exponential)
			ADD R1, R1, #1
			ADD R1, R1, R0
			BRnp #2
			JSR EXP
			JSR EVALUATE
  
			LD R1, SPACE             ; check for space and if true, go back to EVALUATE			
			NOT R1, R1				 
			ADD R1, R1, #1
			ADD R1, R1, R0
			BRz EVALUATE
	
			LD R1, EQUAL             ; check for " = " sign and if true, jump to STACK_CHECK			
			NOT R1, R1
			ADD R1, R1, #1
			ADD R1, R1, R0
			BRz STACK_CHECK
			
			LD R1, Zero
			NOT R1, R1				; check for validity of input
			ADD R1, R1, #1
			ADD R1, R1, R0
			BRn WARNING
 			ADD R1, R1, #-10		;  0 <= input <= 10
			BRzp WARNING
			LD R1, Zero
			NOT R1, R1
			ADD R1, R1, #1
			ADD R0, R0, R1
			JSR PUSH
			JSR EVALUATE
			
			LD R7, SAVE_R7
			RET

			
			
ADDN		.FILL x002B
MINUS		.FILL x002D
MULT		.FILL x002A
DIVIDE		.FILL x002F
EQUAL		.FILL x003D
EXPONENT	.FILL x005E
SPACE       .FILL x0020
ZERO		.FILL x0030
SPACE_2		.STRINGZ " -> "

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4 (R3 + R4)
;out R0
PLUS	
; subroutine for addition
			
			ST R7, SAVE_R7			
			JSR POP
			ADD R5, R5, #0	; if POP not successful, replace
			BRp RET_1		; value to stack and warn
			ADD R3, R0, #0
			JSR POP
			ADD R4, R0, #0		
			ADD R5, R5, #0	; if POP not successful, replace
			BRp RESTORE_1	; value to stack and warn
			ADD R0, R3, R4	; ADD 
			JSR PUSH
			LD R7, SAVE_R7
			
RET_1		RET
RESTORE_1 	ADD R6, R6, #-1
			JSR WARNING
			
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4 (R3 - R4)
;out R0
MIN	
; subroutine for subtraction

			ST R7, SAVE_R7			
			JSR POP
			ADD R5, R5, #0	; if POP not successful, replace
			BRp RET_2		; value to stack and warn
			ADD R3, R0, #0
			NOT R3, R3
			ADD R3, R3, #1	; making R3 -> -(R3)
			JSR POP
			ADD R4, R0, #0
			ADD R5, R5, #0	; if POP not successful, replace
			BRp RESTORE_2	; value to stack and warn

			ADD R0, R3, R4	; SUBTRACT 
			JSR PUSH
			LD R7, SAVE_R7
			
			
RET_2		RET
RESTORE_2 	ADD R6, R6, #-1
			JSR WARNING

	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4 (R3 * R4)
;out R0
MUL	
; subroutine for multiplication
		
			ST R7, SAVE_R7			
			JSR POP
			ADD R5, R5, #0	; if POP not successful, replace
			BRp RET_3		; value to stack and warn
			ADD R3, R0, #0
			JSR POP			
			ADD R4, R0, #0	; if POP not successful, replace
			ADD R5, R5, #0	; value to stack and warn
			BRp RESTORE_3
			AND R0, R0, #0

MULTIPLY_1	ADD R0, R0, R3	; MULTIPLY
			ADD R4, R4, #-1
			BRp MULTIPLY_1
 
			JSR PUSH
			LD R7, SAVE_R7
			
RET_3		RET
RESTORE_3	ADD R6, R6, #-1
			JSR WARNING
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4 (R3 / R4)
;out R0-quotient

DIV
; subroutine for division
	
			ST R7, SAVE_R7			
			JSR POP
			ADD R5, R5, #0	; if POP not successful, replace
			BRp RET_4		; value to stack and warn
			ADD R3, R0, #0
			NOT R3,R3
			ADD R3, R3, #1	; making R3 -> -(R3)
			JSR POP
			ADD R4, R0, #0
			BRz RESTORE_4	; if R4 == 0, warn 
			ADD R5, R5, #0	; if POP not successful, replace
			BRp RESTORE_4	; value to stack and warn
 
			AND R0, R0, #0
	        ADD R0, R0, #-1

SUBTRACT_1	ADD R0, R0, #1
			ADD R4, R3, R4	; divide through subtraction
			BRzp SUBTRACT_1
	
			JSR PUSH
			LD R7, SAVE_R7
			
RET_4		RET
RESTORE_4 	ADD R6, R6, #-1
			JSR WARNING
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4  (R3 ^ R4)
;out R0
EXP
; subroutine for exponential

			ST R7, SAVE_R7			
			JSR POP
			ADD R5, R5, #0	; if POP not successful, replace
			BRp RET_5		; value to stack and warn
			ADD R4, R0, #0	
			JSR POP
			ADD R3, R0, #0
			ADD R5, R5, #0	; if POP not successful, replace
			BRp RESTORE_5	; value to stack and warn

			ST R2, SAVE_R2
			ADD R4, R4, #-1
			AND R2, R2, #0
			ADD R2, R3, #0
			AND R0, R0, #0

MULTIPLY_2	ADD R0, R0, R3		; EXPONENTIAL
			ADD R2, R2, #-1		; through multiplication
			BRp MULTIPLY_2

EXPO		AND R2, R2, #0
			ADD R2, R3, #0
			ADD R4, R4, #-1
			BRp MULTIPLY_2
			
			LD R2, SAVE_R2
			JSR PUSH
			LD R7, SAVE_R7

RET_5		RET
RESTORE_5	ADD R6, R6, #-1
			JSR WARNING

WARNING		
; subroutine for warning statement when 
; calculator doesnot function as required

	ST R7, SAVE_R7
	LEA R0, WARNING_1
	PUTS
	LD R7, SAVE_R7
	HALT

SAVE_R2		.BLKW #1
	
;IN:R0, OUT:R5 (0-success, 1-fail/overflow)
;R3: STACK_END R4: STACK_TOP
;
PUSH	
	ST R3, PUSH_SaveR3	;save R3
	ST R4, PUSH_SaveR4	;save R4
	AND R5, R5, #0		;
	LD R3, STACK_END	;
	LD R4, STACk_TOP	;
	ADD R3, R3, #-1		;
	NOT R3, R3		;
	ADD R3, R3, #1		;
	ADD R3, R3, R4		;
	BRz OVERFLOW		;stack is full
	STR R0, R4, #0		;no overflow, store value in the stack
	ADD R4, R4, #-1		;move top of the stack
	ST R4, STACK_TOP	;store top of stack pointer
	BRnzp DONE_PUSH		;
OVERFLOW
	ADD R5, R5, #1		;
DONE_PUSH
	LD R3, PUSH_SaveR3	;
	LD R4, PUSH_SaveR4	;
	RET


PUSH_SaveR3	.BLKW #1	;
PUSH_SaveR4	.BLKW #1	;


;OUT: R0, OUT R5 (0-success, 1-fail/underflow)
;R3 STACK_START R4 STACK_TOP
;
POP	
	ST R3, POP_SaveR3	;save R3
	ST R4, POP_SaveR4	;save R3
	AND R5, R5, #0		;clear R5
	LD R3, STACK_START	;
	LD R4, STACK_TOP	;
	NOT R3, R3		    ;
	ADD R3, R3, #1		;
	ADD R3, R3, R4		;
	BRz UNDERFLOW		;
	ADD R4, R4, #1		;
	LDR R0, R4, #0		;
	ST R4, STACK_TOP	;
	BRnzp DONE_POP		;
UNDERFLOW
	ADD R5, R5, #1		;
DONE_POP
	LD R3, POP_SaveR3	;
	LD R4, POP_SaveR4	;
	RET

STACK_CHECK
; subroutine for checking stack
		
	JSR POP
	AND R3, R3, #0
	ADD R3, R3, R0
	JSR POP
	ADD R5, R5, #0
	BRz RESTORE_6
	AND R5, R5, #0
	ADD R5, R5, R3
	ST R5, FINAL_RESULT
	JSR PRINT_HEX

RESTORE_6	ADD R6, R6, #-1
			JSR WARNING
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

POP_SaveR3	.BLKW #1	;
POP_SaveR4	.BLKW #1	;
FINAL_RESULT .BLKW #1
STACK_END	.FILL x3FF0	;
STACK_START	.FILL x4000	;
STACK_TOP	.FILL x4000	;
WARNING_1	.STRINGZ " >> INVALID STATEMENT !! << "


.END
