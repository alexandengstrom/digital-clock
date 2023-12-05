;
; digital-clock.asm
;
; Created: 2023-12-05 16:22:28
; Author : Alexander Engström
;

.dseg

TIME:	.byte 4
POS:	.byte 1 

.cseg

.org  $0000
	rjmp	SETUP

.org INT0addr
	jmp	BCD

.org INT1addr
	jmp	MUX

SETUP:
	ldi	r16, HIGH(RAMEND)
	out	SPH, r16
	ldi	r16, LOW(RAMEND)
	out	SPL, r16

	ldi	r16, $FF
	out	DDRB, r16
	ldi	r16, $07
	out	DDRA, r16

	ldi	r16, (1 << ISC11) | (1 << ISC10) | (1 << ISC01) | (1 << ISC00)
	out	MCUCR, r16
	ldi	r16, (1 << INT0) | (1 << INT1)
	out	GICR, r16
	sei

	ldi	r16, $00
	sts	TIME, r16
	sts	TIME + 1, r16
	sts	TIME + 2, r16
	sts	TIME + 3, r16

	sts	POS, r16

	clr	r2

MAIN:
	rjmp	MAIN

BCD:
	push	r16
	push	r17
	in	r16, SREG
	push	r16

	ldi	r16, 4
	ldi	XL, LOW(TIME)
	ldi	XH, HIGH(TIME)
BCD_LOOP:
	ld	r17, X
	inc	r17
	sbrc	r16, 0
	rjmp	HANDLE_ODD
	cpi	r17, $0A
	breq	RESET_DIGIT
	rjmp	BCD_END
HANDLE_ODD:
	cpi	r17, $06
	breq	RESET_DIGIT
	rjmp	BCD_END
RESET_DIGIT:
	clr	r17
BCD_NEXT:
	st	X+, r17
	dec	r16
	brne	BCD_LOOP
BCD_END:
	st	X, r17
	pop	r16
	out	SREG, r16
	pop	r17
	pop	r16
	reti

MUX:
	push	r16
	push	r17
	in	r16, SREG
	push	r16

	lds	r17, POS
	inc	r17
	rcall	LOAD_NEXT_DIGIT
	rcall	TRANSLATE_DIGIT
	out	PORTB, r2
	out	PORTA, r17
	out	PORTB, r16

	sts	POS, r17
	pop	r16
	out	SREG, r16

	pop	r17
	pop	r16
	reti

LOAD_NEXT_DIGIT:
	ldi	XL, LOW(TIME)
	ldi	XH, HIGH(TIME)
	andi	r17, $03
	add	XL, r17
	adc	XH, r2
	ld	r16, X
	ret

TRANSLATE_DIGIT:
	ldi	ZL, LOW(2*NUMBERS)
	ldi	ZH, HIGH(2*NUMBERS)
	add	ZL, r16
	adc	ZH, r2
	lpm	r16, Z
	ret

NUMBERS:
	.db $3F, $06, $5B, $4F, $66, $6D, $7D, $07, $7F, $67

