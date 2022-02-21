; ReCoMox Monitor Timer V1.0

;File		Timer10.asm
;Version	V1.0
;Date		2022/02/02
;Content	Timer Functions for the ReCoMox Monitor
;-------------------------------------------------------------------------

;timerInit
;intTIMER_COMP
;intTIMER_OVF

timerInit:
	push	af
	push	hl

	ld	a,IfCmdDWrOCR		;write to Output Compare Register (16- Bit)
	call	ifWordWrite

	ld	hl,0			;TCNT
	ld	a,IfCmdWrTCNT		;write to Timer/Counter (16- Bit)
	call	ifWordWrite

	ld	l,bmIfOCF+bmIfTOV	;Clear Compare Match Interrupt Flag and Overflow Interrupt Flag
	ld	a,IfCmdWrTIFR		;write to Timer/Counter Interrupt Flag Register
	call	ifByteWrite

	ld	l,bmIfOCIE;bmIfTOIE	;Enable Compare Match Interrupt and disable Overflow Interrupt
	ld	a,IfCmdWrTIMSK		;write to Timer/Counter Interrupt Mask Register
	call	ifByteWrite

	ld	l,bmIfCs8		;Clock Select /8 -> 400Hz / 8 = 50Hz
	ld	a,IfCmdWrTCCRB		;write to Timer/Counter Control Register B
	call	ifByteWrite

;	ld	l,bmIfFOC		;Force Output Compare
;	ld	a,IfCmdWrTCCRC		;write to Timer/Counter Control Register C
;	call	ifByteWrite

	pop	hl
	pop	af
	ret

intTIMER_COMP:
;	call	uartManageTxBuffer
	ld	hl,s50			;1/50 sec
	dec	(hl)
	jr	nz,timeOk

	ld 	(hl),50			;reset s50
	inc	hl
	ld	a,(hl)			;get sec
	inc	a
	daa
	ld	(hl),a
	cp	&60
	jr	c,timeOk

	ld	(hl),0			;reset sec
	inc	hl
	ld	a,(hl)			;get min
	inc	a
	daa	
	ld	(hl),a
	cp	&60
	jr	c,timeOk

	ld	(hl),0			;reset min
	inc	hl
	ld	a,(hl)			;get hour
	inc	a
	daa	
	cp	&24
	ld	(hl),a
	jr	c,timeOk

	ld	(hl),0			;reset hour
	inc	hl
	inc	hl
	ld	a,(hl)			;get month
	dec	hl
	cp	2			;is it february?
	jr	nz,noFeb
	ld	b,&29			;set max. Days to 28
	jr	february
noFeb:
	dec	a
	cp	7
	adc	a,0
	and	1
	add	a,&31
	ld	b,a
february:
	ld	a,(hl)			;get day
	inc	a
	daa	
	cp	b			;31,28,31,30,31,30,31,31,30,31,30,31
	ld	(hl),a
	jr	c,timeOk

	ld	(hl),1			;month
	inc	hl
	ld	a,(hl)
	inc	a
	daa	
	cp	&13
	ld	(hl),a
	jr	c,timeOk

	ld	(hl),1			;year low
	inc	hl
	ld	a,(hl)
	inc	a
	daa	
	cp	&9a
	ld	(hl),a
	jr	c,timeOk

	ld	(hl),0			;year high
	inc	hl
	ld	a,(hl)
	inc	a
	daa	
	cp	&9a
	ld	(hl),a
	jr	c,timeOk

	ld	(hl),0	
timeOk:
	ret

intTIMER_OVF:
	ret
