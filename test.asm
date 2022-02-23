	org	&8000

write "disAssTest.bin"

l0000:
L8000:	nop			;OK
	ld	bc,&0201	;OK
	ld	(bc),a		;OK
	inc	bc		;OK
	inc	b		;OK
	dec	b		;OK
	ld	b,&03		;OK
	rlca			;OK

	ex	af,af'		;OK
	add	hl,bc		;OK
	ld	a,(bc)		;OK
	dec	bc		;OK
	inc	c		;OK
	dec	c		;OK
	ld	c,&04		;OK
	rrca			;OK
L8014:
	djnz	&8000		;OK
	ld	de,&0706	;OK
	ld	(de),a		;OK
	inc	de		;OK
	inc	d		;OK
	dec	d		;OK
	ld	d,&08		;OK
	rla			;OK

	jr	&8020		;OK
	add	hl,de		;OK
	ld	a,(de)		;OK
	dec	de		;OK
	inc	e		;OK
	dec	e		;OK
	ld	e,&0a		;OK 
	rra			;OK
L802A:
	jr	nz,&802c	;OK
	ld	hl,&0d0c	;OK
	ld	(&0f0e),hl	;OK
	inc	hl		;OK
	inc	h		;OK
	dec	h		;OK
	ld	h,&10		;OK
	daa			;OK

	jr	z,&8040		;OK
	add	hl,hl		;OK
	ld	hl,(&1312)	;OK
	dec	hl		;OK
	inc	l		;OK
	dec	l		;OK
	ld	l,&14		;OK
	cpl			;OK
L8044:
	jr	nc,&8060	;OK
	ld	sp,&1716	;OK
	ld	(&1918),a	;OK
	inc	sp		;OK
	inc	(hl)		;OK
	dec	(hl)		;OK
	ld	(hl),&1a	;OK
	scf			;OK

	jr	c,&8080		;OK
	add	hl,sp		;OK
	ld	a,(&1d1c)	;OK
	dec	sp		;OK
	inc	a		;OK
	dec	a		;OK
	ld	a,&1e		;OK
	ccf			;OK
L0001:
L805E:	ld	b,b		;OK
	ld	b,c		;OK
	ld	b,d		;OK
	ld	b,e		;OK
	ld	b,h		;OK
	ld	b,l		;OK
	ld	b,(hl)		;OK
	ld	b,a		;OK

	ld	c,b		;OK
	ld	c,c		;OK
	ld	c,d		;OK
	ld	c,e		;OK
	ld	c,h		;OK
	ld	c,l		;OK
	ld	c,(hl)		;OK
	ld	c,a		;OK
L806E:
	ld	d,b		;OK
	ld	d,c		;OK
	ld	d,d		;OK
	ld	d,e		;OK
	ld	d,h		;OK
	ld	d,l		;OK
	ld	d,(hl)		;OK
	ld	d,a		;OK

	ld	e,b		;OK
	ld	e,c		;OK
	ld	e,d		;OK
	ld	e,e		;OK
	ld	e,h		;OK
	ld	e,l		;OK
	ld	e,(hl)		;OK
	ld	e,a		;OK
L807E:
	ld	h,b		;OK
	ld	h,c		;OK
	ld	h,d		;OK
	ld	h,e		;OK
	ld	h,h		;OK
	ld	h,l		;OK
	ld	h,(hl)		;OK
	ld	h,a		;OK

	ld	l,b		;OK
	ld	l,c		;OK
	ld	l,d		;OK
	ld	l,e		;OK
	ld	l,h		;OK
	ld	l,l		;OK
	ld	l,(hl)		;OK
	ld	l,a		;OK
L808E:
	ld	(hl),b		;OK
	ld	(hl),c		;OK
	ld	(hl),d		;OK
	ld	(hl),e		;OK
	ld	(hl),h		;OK
	ld	(hl),l		;OK
	halt			;OK
	ld	(hl),a		;OK

	ld	a,b		;OK
	ld	a,c		;OK
	ld	a,d		;OK
	ld	a,e		;OK
	ld	a,h		;OK
	ld	a,l		;OK
	ld	a,(hl)		;OK
	ld	a,a		;OK
L0010:
L809E:	add	a,b		;OK
	add	a,c		;OK
	add	a,d		;OK
	add	a,e		;OK
	add	a,h		;OK
	add	a,l		;OK
	add	a,(hl)		;OK
	add	a,a		;OK

	adc	a,b		;OK
	adc	a,c		;OK
	adc	a,d		;OK
	adc	a,e		;OK
	adc	a,h		;OK
	adc	a,l		;OK
	adc	a,(hl)		;OK
	adc	a,a		;OK
L80AE:
	sub	a,b		;OK
	sub	a,c		;OK
	sub	a,d		;OK
	sub	a,e		;OK
	sub	a,h		;OK
	sub	a,l		;OK
	sub	a,(hl)		;OK
	sub	a,a		;OK

	sbc	a,b		;OK
	sbc	a,c		;OK
	sbc	a,d		;OK
	sbc	a,e		;OK
	sbc	a,h		;OK
	sbc	a,l		;OK
	sbc	a,(hl)		;OK
	sbc	a,a		;OK
L80BE:
	and	a,b		;OK
	and	a,c		;OK
	and	a,d		;OK
	and	a,e		;OK
	and	a,h		;OK
	and	a,l		;OK
	and	a,(hl)		;OK
	and	a,a		;OK

	xor	a,b		;OK
	xor	a,c		;OK
	xor	a,d		;OK
	xor	a,e		;OK
	xor	a,h		;OK
	xor	a,l		;OK
	xor	a,(hl)		;OK
	xor	a,a		;OK
L80CE:
	or	a,b		;OK
	or	a,c		;OK
	or	a,d		;OK
	or	a,e		;OK
	or	a,h		;OK
	or	a,l		;OK
	or	a,(hl)		;OK
	or	a,a		;OK

	cp	a,b		;OK
	cp	a,c		;OK
	cp	a,d		;OK
	cp	a,e		;OK
	cp	a,h		;OK
	cp	a,l		;OK
	cp	a,(hl)		;OK
	cp	a,a		;OK
L0011:
L80DE:	ret	nz		;OK
	pop	bc		;OK
	jp	nz,&201f	;OK
	jp	&2221		;OK
	call	nz,&2423	;OK
	push	bc		;OK
	add	a,&25		;OK
	rst	&00		;OK

	ret	z		;OK
	ret			;OK
	jp	z,&2726		;OK
	;&cb		
	call	z,&2928		;OK
	call	&2b2a		;OK
	adc	a,&2c		;OK
	rst	&08		;OK
L80FB:
	ret	nc		;OK
	pop	de		;OK
	jp	nc,&2e2d	;OK
	out	(&2f),a		;OK
	call	nc,&3130	;OK
	push	de		;OK
	sub	a,&32		;OK
	rst	&10		;OK

	ret	c		;OK
	exx			;OK
	jp	c,&3433		;OK
	in	a,(&35)		;OK
	call	c,&3736		;OK
	;&dd
	sbc	a,&38		;OK
	rst	&18		;OK
L8116:
	ret	po		;OK
	pop	hl		;OK
	jp	po,&3a39	;OK
	ex	(sp),hl		;OK
	call	po,&3c3b	;OK
	push	hl		;OK
	and	a,&3d		;OK
	rst	&20		;OK

	ret	pe		;OK
	jp	(hl)		;OK
	jp	pe,&3f3e	;OK
	ex	de,hl		;OK
	call	pe,&4140	;OK
	;&ed
	xor	a,&42		;OK
	rst	&28		;OK
L812f:
	ret	p		;OK
	pop	af		;OK
	jp	p,&4443		;OK
	di			;OK
	call	p,&4645		;OK
	push	af		;OK
	or	a,&47		;OK
	rst	&30		;OK

	ret	m		;OK
	ld	sp,hl		;OK
	jp	m,&4948		;OK
	ei			;OK
	call	m,&4b4a		;OK
	;&fd
	cp	a,&4c		;OK
	rst	&38		;OK
LCB00:
L8148:	rlc	b		;OK
	rlc	c		;OK
	rlc	d		;OK
	rlc	e		;OK
	rlc	h		;OK
	rlc	l		;OK
	rlc	(hl)		;OK
	rlc	a		;OK

	rrc	b		;OK
	rrc	c		;OK
	rrc	d		;OK
	rrc	e		;OK
	rrc	h		;OK
	rrc	l		;OK
	rrc	(hl)		;OK
	rrc	a		;OK
L8168:
	rl	b		;OK
	rl	c		;OK
	rl	d		;OK
	rl	e		;OK
	rl	h		;OK
	rl	l		;OK
	rl	(hl)		;OK
	rl	a		;OK

	rr	b		;OK
	rr	c		;OK
	rr	d		;OK
	rr	e		;OK
	rr	h		;OK
	rr	l		;OK
	rr	(hl)		;OK
	rr	a		;OK
L8188:
	sla	b		;OK
	sla	c		;OK
	sla	d		;OK
	sla	e		;OK
	sla	h		;OK
	sla	l		;OK
	sla	(hl)		;OK
	sla	a		;OK

	sra	b		;OK
	sra	c		;OK
	sra	d		;OK
	sra	e		;OK
	sra	h		;OK
	sra	l		;OK
	sra	(hl)		;OK
	sra	a		;OK
L81A8:
	sll	b		;OK
	sll	c		;OK
	sll	d		;OK
	sll	e		;OK
	sll	h		;OK
	sll	l		;OK
	sll	(hl)		;OK
	sll	a		;OK

	srl	b		;OK
	srl	c		;OK
	srl	d		;OK
	srl	e		;OK
	srl	h		;OK
	srl	l		;OK
	srl	(hl)		;OK
	srl	a		;OK
LCB01:
L81C8:	bit	0,b		;OK
	bit	0,c		;OK
	bit	0,d		;OK
	bit	0,e		;OK
	bit	0,h		;OK
	bit	0,l		;OK
	bit	0,(hl)		;OK
	bit	0,a		;OK

	bit	1,b		;OK
	bit	1,c		;OK
	bit	1,d		;OK
	bit	1,e		;OK
	bit	1,h		;OK
	bit	1,l		;OK
	bit	1,(hl)		;OK
	bit	1,a		;OK
L81E8:
	bit	2,b		;OK
	bit	2,c		;OK
	bit	2,d		;OK
	bit	2,e		;OK
	bit	2,h		;OK
	bit	2,l		;OK
	bit	2,(hl)		;OK
	bit	2,a		;OK

	bit	3,b		;OK
	bit	3,c		;OK
	bit	3,d		;OK
	bit	3,e		;OK
	bit	3,h		;OK
	bit	3,l		;OK
	bit	3,(hl)		;OK
	bit	3,a		;OK
L8208:
	bit	4,b		;OK
	bit	4,c		;OK
	bit	4,d		;OK
	bit	4,e		;OK
	bit	4,h		;OK
	bit	4,l		;OK
	bit	4,(hl)		;OK
	bit	4,a		;OK

	bit	5,b		;OK
	bit	5,c		;OK
	bit	5,d		;OK
	bit	5,e		;OK
	bit	5,h		;OK
	bit	5,l		;OK
	bit	5,(hl)		;OK
	bit	5,a		;OK
L8228:
	bit	6,b		;OK
	bit	6,c		;OK
	bit	6,d		;OK
	bit	6,e		;OK
	bit	6,h		;OK
	bit	6,l		;OK
	bit	6,(hl)		;OK
	bit	6,a		;OK

	bit	7,b		;OK
	bit	7,c		;OK
	bit	7,d		;OK
	bit	7,e		;OK
	bit	7,h		;OK
	bit	7,l		;OK
	bit	7,(hl)		;OK
	bit	7,a		;OK
LCB10:
L8248:	res	0,b		;OK
	res	0,c		;OK
	res	0,d		;OK
	res	0,e		;OK
	res	0,h		;OK
	res	0,l		;OK
	res	0,(hl)		;OK
	res	0,a		;OK

	res	1,b		;OK
	res	1,c		;OK
	res	1,d		;OK
	res	1,e		;OK
	res	1,h		;OK
	res	1,l		;OK
	res	1,(hl)		;OK
	res	1,a		;OK
L8268:
	res	2,b		;OK
	res	2,c		;OK
	res	2,d		;OK
	res	2,e		;OK
	res	2,h		;OK
	res	2,l		;OK
	res	2,(hl)		;OK
	res	2,a		;OK

	res	3,b		;OK
	res	3,c		;OK
	res	3,d		;OK
	res	3,e		;OK
	res	3,h		;OK
	res	3,l		;OK
	res	3,(hl)		;OK
	res	3,a		;OK
L8288:
	res	4,b		;OK
	res	4,c		;OK
	res	4,d		;OK
	res	4,e		;OK
	res	4,h		;OK
	res	4,l		;OK
	res	4,(hl)		;OK
	res	4,a		;OK

	res	5,b		;OK
	res	5,c		;OK
	res	5,d		;OK
	res	5,e		;OK
	res	5,h		;OK
	res	5,l		;OK
	res	5,(hl)		;OK
	res	5,a		;OK
L82A8:
	res	6,b		;OK
	res	6,c		;OK
	res	6,d		;OK
	res	6,e		;OK
	res	6,h		;OK
	res	6,l		;OK
	res	6,(hl)		;OK
	res	6,a		;OK

	res	7,b		;OK
	res	7,c		;OK
	res	7,d		;OK
	res	7,e		;OK
	res	7,h		;OK
	res	7,l		;OK
	res	7,(hl)		;OK
	res	7,a		;OK
LCB11:
L82C8:	set	0,b		;OK
	set	0,c		;OK
	set	0,d		;OK
	set	0,e		;OK
	set	0,h		;OK
	set	0,l		;OK
	set	0,(hl)		;OK
	set	0,a		;OK

	set	1,b		;OK
	set	1,c		;OK
	set	1,d		;OK
	set	1,e		;OK
	set	1,h		;OK
	set	1,l		;OK
	set	1,(hl)		;OK
	set	1,a		;OK
L82E8:
	set	2,b		;OK
	set	2,c		;OK
	set	2,d		;OK
	set	2,e		;OK
	set	2,h		;OK
	set	2,l		;OK
	set	2,(hl)		;OK
	set	2,a		;OK

	set	3,b		;OK
	set	3,c		;OK
	set	3,d		;OK
	set	3,e		;OK
	set	3,h		;OK
	set	3,l		;OK
	set	3,(hl)		;OK
	set	3,a		;OK
L8308:
	set	4,b		;OK
	set	4,c		;OK
	set	4,d		;OK
	set	4,e		;OK
	set	4,h		;OK
	set	4,l		;OK
	set	4,(hl)		;OK
	set	4,a		;OK

	set	5,b		;OK
	set	5,c		;OK
	set	5,d		;OK
	set	5,e		;OK
	set	5,h		;OK
	set	5,l		;OK
	set	5,(hl)		;OK
	set	5,a		;OK
L8328:
	set	6,b		;OK
	set	6,c		;OK
	set	6,d		;OK
	set	6,e		;OK
	set	6,h		;OK
	set	6,l		;OK
	set	6,(hl)		;OK
	set	6,a		;OK

	set	7,b		;OK
	set	7,c		;OK
	set	7,d		;OK
	set	7,e		;OK
	set	7,h		;OK
	set	7,l		;OK
	set	7,(hl)		;OK
	set	7,a		;OK
LDD00:
L8348:	add	ix,bc		;OK
	add	ix,de		;OK
	ld	ix,&4e4d	;OK
	ld	(&504f),ix	;OK
	inc	ix		;OK
	inc	ixh		;OK
	dec	ixh		;OK
	ld	ixh,&51		;OK
	add	ix,ix		;OK
	ld	ix,(&5352)	;OK
	dec	ix		;OK
	inc	ixl		;OK
	dec	ixl		;OK
	ld	ixl,&54		;OK
	inc	(ix+&55)	;OK
	dec	(ix+&56)	;OK
	ld	(ix+&57),&58	;OK
	add	ix,sp		;OK
LDD01:
L8378:	ld	b,ixh		;OK
	ld	b,ixl		;OK
	ld	b,(ix+&59)	;OK
	ld	c,ixh		;OK
	ld	c,ixl		;OK
	ld	c,(ix+&5a)	;OK
	ld	d,ixh		;OK
	ld	d,ixl		;OK
	ld	d,(ix+&5b)	;OK
	ld	e,ixh		;OK
	ld	e,ixl		;OK
	ld	e,(ix+&5c)	;OK
	ld	ixh,b		;OK
	ld	ixh,c		;OK
	ld	ixh,d		;OK
	ld	ixh,e		;OK
L839C:
	ld	ixh,ixh		;OK
	ld	ixh,ixl		;OK
	ld	h,(ix+&5d)	;OK
	ld	ixh,a		;OK
	ld	ixl,b		;OK
	ld	ixl,c		;OK
	ld	ixl,d		;OK
	ld	ixl,e		;OK
	ld	ixl,ixh		;OK
	ld	ixl,ixl		;OK
	ld	l,(ix+&5e)	;OK
	ld	ixl,a		;OK
L83B6:
	ld	(ix+&5f),b	;OK
	ld	(ix+&60),c	;OK
	ld	(ix+&61),d	;OK
	ld	(ix+&62),e	;OK
	ld	(ix+&63),h	;OK
	ld	(ix+&64),l	;OK
	defb	&dd
	halt			;OK
	ld	(ix+&65),a	;OK
	ld	a,ixh		;OK
	ld	a,ixl		;OK
	ld	a,(ix+&66)	;OK
LDD10:
L83D4:	add	a,ixh		;OK
	add	a,ixl		;OK
	add	a,(ix+&67)	;OK
	adc	a,ixh		;OK
	adc	a,ixl		;OK
	adc	a,(ix+&68)	;OK
	sub	a,ixh		;OK
	sub	a,ixl		;OK
	sub	a,(ix+&69)	;OK
	sbc	a,ixh		;OK
	sbc	a,ixl		;OK
	sbc	a,(ix+&6a)	;OK
	and	a,ixh		;OK
	and	a,ixl		;OK
	and	a,(ix+&6b)	;OK
	xor	a,ixh		;OK
	xor	a,ixl		;OK
	xor	a,(ix+&6c)	;OK
	or	a,ixh		;OK
	or	a,ixl		;OK
	or	a,(ix+&6d)	;OK
	cp	a,ixh		;OK
	cp	a,ixl		;OK
	cp	a,(ix+&6e)	;OK
LDD11:
L840C:	pop	ix		;OK
	ex	(sp),ix		;OK
	push	ix		;OK
	jp	(ix)		;OK
	defb	&dd
	ex	de,hl		;OK
	ld	sp,ix		;OK
LDDCB:
L8418:	rlc	(ix+&6f)	;OK
	defb	&dd,&cb,&70,&00	;OK RLC (IX+70),B
	rrc	(ix+&71)	;OK
	defb	&dd,&cb,&72,&09	;OK RRC (IX+72),C
	rl	(ix+&73)	;OK
	defb	&dd,&cb,&74,&12	;OK RL (IX+74),D
	rr	(ix+&75)	;OK
	defb	&dd,&cb,&76,&1b	;OK RR (IX+76),E
	sla	(ix+&77)	;OK
	defb	&dd,&cb,&78,&24	;OK SLA (IX+78),H
	sra	(ix+&79)	;OK
	defb	&dd,&cb,&7a,&2d	;OK SRA (IX+7A),L
	sll	(ix+&7b)	;OK
	defb	&dd,&cb,&7c,&37	;OK SLL (IX+7C),A
	srl	(ix+&7d)	;OK
	defb	&dd,&cb,&7e,&38	;OK SRL (IX+7E),B
L8458:
	bit	0,(ix+&7f)	;OK
	defb	&dd,&cb,&80,&40	;OK BIT 0,(IX-80)
	bit	1,(ix-&7f)	;OK
	defb	&dd,&cb,&82,&49	;OK BIT 1,(IX-7E)
	bit	2,(ix-&7d)	;OK
	defb	&dd,&cb,&84,&52	;OK BIT 2,(IX-7C)
	bit	3,(ix-&7b)	;OK
	defb	&dd,&cb,&86,&5b	;OK BIT 3,(IX-7A)
	bit	4,(ix-&79)	;OK
	defb	&dd,&cb,&88,&64	;OK BIT 4,(IX-78)
	bit	5,(ix-&77)	;OK
	defb	&dd,&cb,&8a,&6d	;OK BIT 5,(IX-76)
	bit	6,(ix-&75)	;OK
	defb	&dd,&cb,&8c,&77	;OK BIT 6,(IX-74)
	bit	7,(ix-&73)	;OK
L8494:
	res	0,(ix-&72)	;OK
	defb	&dd,&cb,&8f,&80	;OK RES 0,(IX-71),B
	res	1,(ix-&70)	;OK
	defb	&dd,&cb,&91,&89	;OK RES 1,(IX-6F),C
	res	2,(ix-&6e)	;OK
	defb	&dd,&cb,&93,&92	;OK RES 2,(IX-6D),D
	res	3,(ix-&6c)	;OK
	defb	&dd,&cb,&95,&9b	;OK RES 3,(IX-6B),E
	res	4,(ix-&6a)	;OK
	defb	&dd,&cb,&97,&a4	;OK RES 4,(IX-69),H
	res	5,(ix-&68)	;OK
	defb	&dd,&cb,&99,&ad	;OK RES 5,(IX-67),L
	res	6,(ix-&66)	;OK
	defb	&dd,&cb,&9b,&b7	;OK RES 6,(IX-65),A
	res	7,(ix-&64)	;OK
L84D0:
	set	0,(ix-&63)	;OK
	defb	&dd,&cb,&9e,&c0	;OK SET 0,(IX-62),B
	set	1,(ix-&61)	;OK
	defb	&dd,&cb,&a0,&c9	;OK SET 1,(IX-60),C
	set	2,(ix-&5f)	;OK
	defb	&dd,&cb,&a2,&d2	;OK SET 2,(IX-5E),D
	set	3,(ix-&5d)	;OK
	defb	&dd,&cb,&a4,&db	;OK SET 3,(IX-5C),E
	set	4,(ix-&5b)	;OK
	defb	&dd,&cb,&a6,&e4	;OK SET 4,(IX-5A),H
	set	5,(ix-&59)	;OK
	defb	&dd,&cb,&a8,&ed	;OK SET 5,(IX-58),L
	set	6,(ix-&57)	;OK
	defb	&dd,&cb,&aa,&f7	;OK SET 6,(IX-56),A
	set	7,(ix-&55)	;OK
LED00:
L850C:	defb	&ed,&00		;OK NOP
	defb	&ed,&01		;OK NOP	
	defb	&ed,&02		;OK NOP
	defb	&ed,&03		;OK NOP
	defb	&ed,&04		;OK NOP
	defb	&ed,&05		;OK NOP
	defb	&ed,&06		;OK NOP
	defb	&ed,&07		;OK NOP
	defb	&ed,&08		;OK NOP
	defb	&ed,&09		;OK NOP
	defb	&ed,&0a		;OK NOP
	defb	&ed,&0b		;OK NOP
	defb	&ed,&0c		;OK NOP
	defb	&ed,&0d		;OK NOP
	defb	&ed,&0e		;OK NOP
	defb	&ed,&0f		;OK NOP
	defb	&ed,&10		;OK NOP
	defb	&ed,&11		;OK NOP
	defb	&ed,&12		;OK NOP
	defb	&ed,&13		;OK NOP
	defb	&ed,&14		;OK NOP
	defb	&ed,&15		;OK NOP
	defb	&ed,&16		;OK NOP
	defb	&ed,&17		;OK NOP
	defb	&ed,&18		;OK NOP
	defb	&ed,&19		;OK NOP
	defb	&ed,&1a		;OK NOP
	defb	&ed,&1b		;OK NOP
	defb	&ed,&1c		;OK NOP
	defb	&ed,&1d		;OK NOP
	defb	&ed,&1e		;OK NOP
	defb	&ed,&1f		;OK NOP
	defb	&ed,&20		;OK NOP
	defb	&ed,&21		;OK NOP
	defb	&ed,&22		;OK NOP
	defb	&ed,&23		;OK NOP
	defb	&ed,&24		;OK NOP
	defb	&ed,&25		;OK NOP
	defb	&ed,&26		;OK NOP
	defb	&ed,&27		;OK NOP
	defb	&ed,&28		;OK NOP
	defb	&ed,&29		;OK NOP
	defb	&ed,&2a		;OK NOP
	defb	&ed,&2b		;OK NOP
	defb	&ed,&2c		;OK NOP
	defb	&ed,&2d		;OK NOP
	defb	&ed,&2e		;OK NOP
	defb	&ed,&2f		;OK NOP
	defb	&ed,&30		;OK NOP
	defb	&ed,&31		;OK NOP
	defb	&ed,&32		;OK NOP
	defb	&ed,&33		;OK NOP
	defb	&ed,&34		;OK NOP
	defb	&ed,&35		;OK NOP
	defb	&ed,&36		;OK NOP
	defb	&ed,&37		;OK NOP
	defb	&ed,&38		;OK NOP
	defb	&ed,&39		;OK NOP
	defb	&ed,&3a		;OK NOP
	defb	&ed,&3b		;OK NOP
	defb	&ed,&3c		;OK NOP
	defb	&ed,&3d		;OK NOP
	defb	&ed,&3e		;OK NOP
	defb	&ed,&3f		;OK NOP
LED01:
L858C:	in	b,(c)		;OK
	out	(c),b		;OK
	sbc	hl,bc		;OK
	ld	(&adac),bc	;OK
	neg			;OK
	retn			;OK
	im	0		;OK
	ld	i,a		;OK

	in	c,(c)		;OK
	out	(c),c		;OK
	adc	hl,bc		;OK
	ld	bc,(&afae)	;OK
	defb	&ed,&4c		;OK NEG
	reti			;OK
	defb	&ed,&4e		;OK IM 0
	ld	r,a		;OK
L85B0:
	in	d,(c)		;OK
	out	(c),d		;OK
	sbc	hl,de		;OK
	ld	(&b1b0),de	;OK
	defb	&ed,&54		;OK NEG
	defb	&ed,&55		;OK RETN
	im	1		;OK
	ld	a,i		;OK

	in	e,(c)		;OK
	out	(c),e		;OK
	adc	hl,de		;OK
	ld	de,(&b3b2)	;OK
	defb	&ed,&5c		;OK NEG
	defb	&ed,&5d		;OK RETN
	im	2		;OK
	ld	a,r		;OK
L85D4:
	in	h,(c)		;OK
	out	(c),h		;OK
	sbc	hl,hl		;OK
	defb	&ed,&63,&b4,&b5	;OK LD (B5B4),HL
	defb	&ed,&64		;OK NEG
	defb	&ed,&65		;OK RETN
	defb	&ed,&66		;OK IM 0
	rrd			;OK

	in	l,(c)		;OK
	out	(c),l		;OK
	adc	hl,hl		;OK
	defb	&ed,&6b,&b6,&b7	;OK LD HL,(B7B6)
	defb	&ed,&6c		;OK NEG
	defb	&ed,&6d		;OK RETN
	defb	&ed,&6e		;OK IM 0
	rld			;OK
L85f8:
	defb	&ed,&70		;OK IN  (C)
	defb	&ed,&71		;OK OUT (C),0
	sbc	hl,sp		;OK
	ld	(&b9b8),sp	;OK
	defb	&ed,&74		;OK NEG
	defb	&ed,&75		;OK RETN
	defb	&ed,&76		;OK IM 1
	defb	&ed,&77		;OK NOP

	in	a,(c)		;OK
	out	(c),a		;OK
	adc	hl,sp		;OK
	ld	sp,(&bbba)	;OK
	defb	&ed,&7c		;OK NEG
	defb	&ed,&7d		;OK RETN
	defb	&ed,&7e		;OK IM 2
	defb	&ed,&7f		;OK NOP
LED10:
L861C:	defb	&ed,&80		;OK NOP
	defb	&ed,&81		;OK NOP
	defb	&ed,&82		;OK NOP
	defb	&ed,&83		;OK NOP
	defb	&ed,&84		;OK NOP
	defb	&ed,&85		;OK NOP
	defb	&ed,&86		;OK NOP
	defb	&ed,&87		;OK NOP
	defb	&ed,&88		;OK NOP
	defb	&ed,&89		;OK NOP
	defb	&ed,&8a		;OK NOP
	defb	&ed,&8b		;OK NOP
	defb	&ed,&8c		;OK NOP
	defb	&ed,&8d		;OK NOP
	defb	&ed,&8e		;OK NOP
	defb	&ed,&8f		;OK NOP
	defb	&ed,&90		;OK NOP
	defb	&ed,&91		;OK NOP
	defb	&ed,&92		;OK NOP
	defb	&ed,&93		;OK NOP
	defb	&ed,&94		;OK NOP
	defb	&ed,&95		;OK NOP
	defb	&ed,&96		;OK NOP
	defb	&ed,&97		;OK NOP
	defb	&ed,&98		;OK NOP
	defb	&ed,&99		;OK NOP
	defb	&ed,&9a		;OK NOP
	defb	&ed,&9b		;OK NOP
	defb	&ed,&9c		;OK NOP
	defb	&ed,&9d		;OK NOP
	defb	&ed,&9e		;OK NOP
	defb	&ed,&9f		;OK NOP
L865C:
	ldi			;OK
	cpi			;OK
	ini			;OK
	outi			;OK
	defb	&ed,&a4		;OK NOP
	defb	&ed,&a5		;OK NOP
	defb	&ed,&a6		;OK NOP
	defb	&ed,&a7		;OK NOP
	ldd			;OK
	cpd			;OK
	ind			;OK
	outd			;OK
	defb	&ed,&ac		;OK NOP
	defb	&ed,&ad		;OK NOP
	defb	&ed,&ae		;OK NOP
	defb	&ed,&af		;OK NOP
L867C:	ldir			;OK
	cpir			;OK
	inir			;OK
	otir			;OK
	defb	&ed,&b4		;OK NOP
	defb	&ed,&b5		;OK NOP
	defb	&ed,&b6		;OK NOP
	defb	&ed,&b7		;OK NOP
	lddr			;OK
	cpdr			;OK
	indr			;OK
	otdr			;OK
	defb	&ed,&bc		;OK NOP
	defb	&ed,&bd		;OK NOP
	defb	&ed,&be		;OK NOP
	defb	&ed,&bf		;OK NOP
LED11:
L869C:	defb	&ed,&c0		;
	defb	&ed,&c1		;
	defb	&ed,&c2		;
	defb	&ed,&c3		;
	defb	&ed,&c4		;
	defb	&ed,&c5		;
	defb	&ed,&c6		;
	defb	&ed,&c7		;
	defb	&ed,&c8		;
	defb	&ed,&c9		;
	defb	&ed,&ca		;
	defb	&ed,&cb		;
	defb	&ed,&cc		;
	defb	&ed,&cd		;
	defb	&ed,&ce		;
	defb	&ed,&cf		;
	defb	&ed,&d0		;
	defb	&ed,&d1		;
	defb	&ed,&d2		;
	defb	&ed,&d3		;
	defb	&ed,&d4		;
	defb	&ed,&d5		;
	defb	&ed,&d6		;
	defb	&ed,&d7		;
	defb	&ed,&d8		;
	defb	&ed,&d9		;
	defb	&ed,&da		;
	defb	&ed,&db		;
	defb	&ed,&dc		;
	defb	&ed,&dd		;
	defb	&ed,&de		;
	defb	&ed,&df		;
	defb	&ed,&e0		;
	defb	&ed,&e1		;
	defb	&ed,&e2		;
	defb	&ed,&e3		;
	defb	&ed,&e4		;
	defb	&ed,&e5		;
	defb	&ed,&e6		;
	defb	&ed,&e7		;
	defb	&ed,&e8		;
	defb	&ed,&e9		;
	defb	&ed,&ea		;
	defb	&ed,&eb		;
	defb	&ed,&ec		;
	defb	&ed,&ed		;
	defb	&ed,&ee		;
	defb	&ed,&ff		;
	defb	&ed,&f0		;
	defb	&ed,&f1		;
	defb	&ed,&f2		;
	defb	&ed,&f3		;
	defb	&ed,&f4		;
	defb	&ed,&f5		;
	defb	&ed,&f6		;
	defb	&ed,&f7		;
	defb	&ed,&f8		;
	defb	&ed,&f9		;
	defb	&ed,&fa		;
	defb	&ed,&fb		;
	defb	&ed,&fc		;
	defb	&ed,&fd		;
	defb	&ed,&fe		;
	defb	&ed,&ff		;
LFD00:
L871C:	add	iy,bc		;OK
	add	iy,de		;OK
	ld	iy,&bdbc	;OK
	ld	(&bfbe),iy	;OK
	inc	iy		;OK
	inc	iyh		;OK
	dec	iyh		;OK
	ld	iyh,&c0		;OK
	add	iy,iy		;OK
	ld	iy,(&c2c1)	;OK
	dec	iy		;OK
	inc	iyl		;OK
	dec	iyl		;OK
	ld	iyl,&c3		;OK
	inc	(iy-&3c)	;OK
	dec	(iy-&3b)	;OK
	ld	(iy-&3a),&c7	;OK
	add	iy,sp		;OK
LFD01:
L874C:	ld	b,iyh		;OK
	ld	b,iyl		;OK
	ld	b,(iy-&38)	;OK
	ld	c,iyh		;OK
	ld	c,iyl		;OK
	ld	c,(iy-&37)	;OK
	ld	d,iyh		;OK
	ld	d,iyl		;OK
	ld	d,(iy-&36)	;OK
	ld	e,iyh		;OK
	ld	e,iyl		;OK
	ld	e,(iy-&35)	;OK
	ld	iyh,b		;OK
	ld	iyh,c		;OK
	ld	iyh,d		;OK
	ld	iyh,e		;OK
L8770:
	ld	iyh,iyh		;OK
	ld	iyh,iyl		;OK
	ld	h,(iy-&34)	;OK
	ld	iyh,a		;OK
	ld	iyl,b		;OK
	ld	iyl,c		;OK
	ld	iyl,d		;OK
	ld	iyl,e		;OK
	ld	iyl,iyh		;OK
	ld	iyl,iyl		;OK
	ld	l,(iy-&33)	;OK
	ld	iyl,a		;OK
L878A:
	ld	(iy-&32),b	;OK
	ld	(iy-&31),c	;OK
	ld	(iy-&30),d	;OK
	ld	(iy-&2f),e	;OK
	ld	(iy-&2e),h	;OK
	ld	(iy-&2d),l	;OK
	defb	&fd
	halt			;OK
	ld	(iy-&2c),a	;OK
	ld	a,iyh		;OK
	ld	a,iyl		;OK
	ld	a,(iy-&2b)	;OK
LFD10:
L87A8:	add	a,iyh		;OK
	add	a,iyl		;OK
	add	a,(iy-&2a)	;OK
	adc	a,iyh		;OK
	adc	a,iyl		;OK
	adc	a,(iy-&29)	;OK
	sub	a,iyh		;OK
	sub	a,iyl		;OK
	sub	a,(iy-&28)	;OK
	sbc	a,iyh		;OK
	sbc	a,iyl		;OK
	sbc	a,(iy-&27)	;OK
	and	a,iyh		;OK
	and	a,iyl		;OK
	and	a,(iy-&26)	;OK
	xor	a,iyh		;OK
	xor	a,iyl		;OK
	xor	a,(iy-&25)	;OK
	or	a,iyh		;OK
	or	a,iyl		;OK
	or	a,(iy-&24)	;OK
	cp	a,iyh		;OK
	cp	a,iyl		;OK
	cp	a,(iy-&23)	;OK
LFD11:
L87E0:	pop	iy		;OK
	ex	(sp),iy		;OK
	push	iy		;OK
	jp	(iy)		;OK
	defb	&fd
	ex	de,hl		;OK
	ld	sp,iy		;OK
LFDCB:
L87EC:	rlc	(iy-&22)	;OK
	defb	&fd,&cb,&df,&00	;OK RLC (IY-21),B
	rrc	(iy-&20)	;OK
	defb	&fd,&cb,&e1,&09	;OK RRC (IY-1F),C
	rl	(iy-&1e)	;OK
	defb	&fd,&cb,&e3,&12	;OK RL (IY-1D),D
	rr	(iy-&1c)	;OK
	defb	&fd,&cb,&e5,&1b	;OK RR (IY-1B),E
	sla	(iy-&1a)	;OK
	defb	&fd,&cb,&e7,&24	;OK SLA (IY-19),H
	sra	(iy-&18)	;OK
	defb	&fd,&cb,&e9,&2d	;OK SRA (IY-17),L
	sll	(iy-&16)	;OK
	defb	&fd,&cb,&eb,&37	;OK SLL (IY-15),A
	srl	(iy-&14)	;OK
	defb	&fd,&cb,&ed,&38	;OK SRL (IY-13),B
L882C:
	bit	0,(iy-&12)	;OK
	defb	&fd,&cb,&ef,&40	;OK BIT 0,(IY-11)
	bit	1,(iy-&10)	;OK
	defb	&fd,&cb,&f1,&49	;OK BIT 1,(IY-0F)
	bit	2,(iy-&0e)	;OK
	defb	&fd,&cb,&f3,&52	;OK BIT 2,(IY-0D)
	bit	3,(iy-&0c)	;OK
	defb	&fd,&cb,&f5,&5b	;OK BIT 3,(IY-0b)
	bit	4,(iy-&0a)	;OK
	defb	&fd,&cb,&f7,&64	;OK BIT 4,(IY-09)
	bit	5,(iy-&08)	;OK
	defb	&fd,&cb,&f9,&6d	;OK BIT 5,(IY-07)
	bit	6,(iy-&06)	;OK
	defb	&fd,&cb,&fb,&77	;OK BIT 6,(IY-05)
	bit	7,(iy-&04)	;OK

	res	0,(iy-&03)	;OK
	defb	&fd,&cb,&fe,&80	;OK RES 0,(IY-02),B
	res	1,(iy-&01)	;OK
	defb	&fd,&cb,&00,&89	;OK RES 1,(IY+00),C
	res	2,(iy+&01)	;OK
	defb	&fd,&cb,&02,&92	;OK RES 2,(IY+02),D
	res	3,(iy+&03)	;OK
	defb	&fd,&cb,&04,&9b	;OK RES 3,(IY+04),E
	res	4,(iy+&05)	;OK
	defb	&fd,&cb,&06,&a4	;OK RES 4,(IY+06),H
	res	5,(iy+&07)	;OK
	defb	&fd,&cb,&08,&ad	;OK RES 5,(IY+08),L
	res	6,(iy+&09)	;OK
	defb	&fd,&cb,&0a,&b7	;OK RES 6,(IY+0A),A
	res	7,(iy+&0B)	;OK

	set	0,(iy+&0c)	;OK
	defb	&fd,&cb,&0d,&c0	;OK SET 0,(IY+0D),B
	set	1,(iy+&0e)	;OK
	defb	&fd,&cb,&0f,&c9	;OK SET 1,(IY+0F),C
	set	2,(iy+&10)	;OK
	defb	&fd,&cb,&11,&d2	;OK SET 2,(IY+11),D
	set	3,(iy+&12)	;OK
	defb	&fd,&cb,&13,&db	;OK SET 3,(IY+13),E
	set	4,(iy+&14)	;OK
	defb	&fd,&cb,&15,&e4	;OK SET 4,(IY+15),H
	set	5,(iy+&16)	;OK
	defb	&fd,&cb,&17,&ed	;OK SET 5,(IY+17),L
	set	6,(iy+&18)	;OK
	defb	&fd,&cb,&19,&f7	;OK SET 6,(IY+19),A
	set	7,(iy+&1a)	;OK
