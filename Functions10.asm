; ReCoMox Monitor Helper Functions V1.0

;File		Functions10.asm
;Version	V1.0
;Date		2022/02/11
;Content	Helper Functions for the ReCoMox Monitor
;-------------------------------------------------------------------------

;skipBlanks
;upper
;nibble2hex
;hex2Buffer8					input -> A=value, HL=pointer to write to
;hex2Buffer16
;stringCopy					copy from (HL) to (DE) until AsciiNUL is detected 

skipBlanks:
	ld	a,(hl)
	cp	' '
	jr	nz,noMoreBlank
blankFound:
	inc	hl
	jr	skipBlanks
noMoreBlank:
	ret

upper:
	cp	'a'
	jr	c,noSmallLetter
	cp	'z'+1
	jr	nc,noSmallLetter
	sub	'a'-'A'
noSmallLetter
	ret

nibble2hex:
	and	&0f
	add	'0'
	cp	'9'+1
	ret	c
	add	'A'-'9'-1
	ret

hex2Buffer8:
	push	af
	rrca
	rrca
	rrca
	rrca
	call	nibble2hex
	ld	(hl),a
	inc	hl
	pop	af
	push	af
	call	nibble2hex
	ld	(hl),a
	inc	hl
	pop	af
	ret

hex2Buffer16:
	ld	a,d
	call	hex2Buffer8
	ld	a,e
	jp	hex2Buffer8

stringCopy:
	push	af
stringCopyLoop:
	ld	a,(hl)
	ld	(de),a
	or	a
	jr	z,stringCopyQuit
	inc	hl
	inc	de	
	jr	stringCopyLoop
stringCopyQuit:
	pop	af
	ret
