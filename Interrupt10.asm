; ReCoMox Monitor Interrupt V1.0

;File		Interrupt10.asm
;Version	V1.0
;Date		2022/02/02
;Content	Interrupt Functions for the ReCoMox Monitor
;-------------------------------------------------------------------------

;intEntry


intVectBase:
	defw	intUSART_RX,intUSART_UDRE,intUSART_TX,intUndef,intTIMER_COMP,intTIMER_OVF,intUndef,intUndef

intEntry:
	push	af
	push	bc
	ld	bc,pIfCmd
	in	a,(c)
	dec	a
	cp	7
	jr	nc,intVectInvalid
	push	de
	push	hl
	ld	hl,intVectBase
	add	a,a
	ld	c,a
	ld	b,0
	add	hl,bc
	ld	bc,intRet
	push	bc
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	push	bc
	ret
intRet:
	pop	hl
	pop	de	
intVectInvalid:	
	pop	bc
	pop	af
	ei
	ret

intUndef:
	ret
