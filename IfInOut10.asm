; ReCoMox Monitor Interface In Out V1.0

;File		IfInOut10.asm
;Version	V1.0
;Date		2022/02/02
;Content	Interface In Out Functions for the ReCoMox Monitor
;-------------------------------------------------------------------------

;ifBitSet	set bits defined as 1 in L at interface address A
;ifBitClear	clear bits defined as 0 in L at interface address A
;ifByteWrite	write L to interface address A
;ifWordWrite	write HL to interface address A
;ifByteRead	Read from interface address A and return value in A
;ifWordRead	Read from interface address A and return value in HL

ifBitSet:					;set bits defined as 1 in L at interface address A
	push	af
	push	bc
	push	hl
	ld	bc,pIfCmd			;Interface command port
	ld	h,a				;safe Interface Address to modify in H
	and	%01111111			;read from interface
	out	(c),a
	ld	c,pIfData mod 256		;Interface data port
	in	a,(c)				;get actual interface data
	or	l				;set required bits
	out	(c),a				;write new interface data
	ld	a,h
	or	%10000000			;prepare interface to write new data to actual address
	ld	c,pIfCmd mod 256		;Interface command port
	out	(c),a				;write data to interface
	pop	hl
	pop	bc
	pop	af
	ret

ifBitClear:					;clear bits defined as 0 in L at interface address A
	push	af
	push	bc
	push	hl
	ld	bc,pIfCmd			;Interface command port
	ld	h,a				;safe Interface Address to modify in H
	and	%01111111			;read from interface
	out	(c),a
	ld	c,pIfData mod 256		;Interface data port
	in	a,(c)				;get actual interface data
	and	l				;clear required bits
	out	(c),a				;write new interface data
	ld	a,h
	or	%10000000			;prepare interface to write new data to actual address
	ld	c,pIfCmd mod 256		;Interface command port
	out	(c),a				;write data to interface
	pop	hl
	pop	bc
	pop	af
	ret

ifByteWrite:					;write L to interface address A
	push	bc
	ld	bc,pIfData			;Interface data port
	out	(c),l
	ld	c,pIfCmd mod 256		;Interface command port
	or	%10000000
	out	(c),a
	pop	bc
	ret

ifWordWrite:					;write HL to interface address A
	push	bc
	ld	bc,pIfData			;Interface data port
	out	(c),l
	out	(c),h
	ld	c,pIfCmd mod 256		;Interface command port
	or	%10000000
	out	(c),a
	pop	bc
	ret

ifByteRead:					;Read from interface address A and return value in A
	push	bc
	ld	bc,pIfCmd			;Interface command port
	and	%01111111
	out	(c),a
	ld	c,pIfData mod 256		;Interface data port
	in	a,(c)
	pop	bc
	ret					

ifWordRead:					;Read from interface address A and return value in HL
	push	af
	push	bc
	ld	bc,pIfCmd			;Interface command port
	and	%01111111
	out	(c),a
	ld	c,pIfData mod 256		;Interface data port
	in	h,(c)
	in	l,(c)
	pop	bc
	pop	af
	ret
