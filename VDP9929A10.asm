; ReCoMox Monitor VDP9929A V1.0

;File		VDP9929A10.asm
;Version	V1.0
;Date		2022/02/02
;Content	TMS9929A Driver Functions for the ReCoMox Monitor
;-------------------------------------------------------------------------

;vdpInit		setup table address in hl
;vramWrite		setup table address in hl, VRAM target address in de, table length in bc
;vramFill		fill Value in a, VRAM target address in hl, length in bc
;vramClearTextScreen
;vramSendString		string address in hl, VRAM target address in de
;vramRead		target Ram address in hl, VRAM read address in de, number of bytes to read in bc
;vramVerify		setup table address in hl, VRAM target address in de, table length in bc
;tabVdpTextInit		This table containes the values for initializing the registers in the TMS9929A for Text Mode
;tabVdpPattern		This table containes the patterns for chr(&20)...chr(%7f) aor 6x8 textmode
;vdpPatLen		length of Pattern table
;vdpPatAdr		target address in VRAM
;vdpNameAdr		name table base address in VRAM
;vdpColAdr		Color Table Base Address in VRAM
;vdpSpriteAttAdr	Sprite Attribute Table Base Address in VRAM
;vdpSpritePatAdr	Sprite Pattern Table Base Address in VRAM
;cdpColTrans		
;cdpColBlack		Y=0,00
;cdpColDarkBlue		Y=0,40
;cdpColDarkGreen	Y=0,46
;cdpColDarkRed		Y=0,47
;cdpColLightBlue	Y=0,53
;cdpColMediumGreen	Y=0,53
;cdpColMediumRed	Y=0,53
;cdpColMagenta		Y=0,53
;cdpColLightGreen	Y=0,67
;cdpColLightRed		Y=0,67
;cdpColCyan		Y=0,73
;cdpColDarkYellow	Y=0,73
;cdpColLightYellow	Y=0,80
;cdpColGray		Y=0,80
;cdpColWhite		Y=1,00

vdpInit:					;setup table address in hl
	push	af
	push	hl
	push	de
	push	bc	
	ld	bc,pVideo40Vdp			;VDP write Port
	ld	d,0+VdpReg			;Address of first VDP register
	ld	a,8				;Number of registers to be written
vdpInitLoop:
	ld	e,(hl)				;get data from table
	inc	hl
	out	(c),e				;send data to VDP
	out	(c),d				;send registernumber to VDP
	inc	d				;increment registernumber
	dec	a				;all regs loaded?
	jr	nz,vdpInitLoop			;no, go again
	pop	bc
	pop	de
	pop	hl
	pop	af
	ret

; This table containes the values for initializing the registers in the TMS9929A for Text Mode
vdpNameAdr		equ &0400		;Name Table Base Address
vdpColAdr		equ &0200		;Color Table Base Address in VRAM
vdpPatAdr		equ &0800		;target address in VRAM
vdpSpriteAttAdr		equ &0300		;Sprite Attribute Table Base Address in VRAM
vdpSpritePatAdr		equ &0000		;Sprite Pattern Table Base Address in VRAM
						;Y	R-Y	B-Y
cdpColTrans		equ &0			;-	-	-
cdpColBlack		equ &1			;0,00 	0,47 	0,47
cdpColDarkBlue		equ &4			;0,40	0,40	1,00
cdpColDarkGreen		equ &c			;0,46	0,13	0,23
cdpColDarkRed		equ &6			;0,47	0,83	0,30
cdpColLightBlue		equ &5			;0,53	0,43	0,93
cdpColMediumGreen	equ &2			;0,53	0,07	0,20
cdpColMediumRed		equ &8			;0,53	0,93	0,27
cdpColMagenta		equ &d			;0,53	0,73	0,67
cdpColLightGreen	equ &3			;0,67	0,17	0,27
cdpColLightRed		equ &9			;0,67	0,93	0,27
cdpColCyan		equ &7			;0,73	0,00	0,70
cdpColDarkYellow	equ &a			;0,73	0,57	0,07
cdpColLightYellow	equ &b			;0,80	0,57	0,17
cdpColGray		equ &e			;0,80	0,47	0,47
cdpColWhite		equ &f			;1,00	0,47	0,47

tabVdpTextInit:
	defb	%00000000			;M3=0, EV=0-> EXT_VID_OFF
	defb	%11010000			;4/16k=1-> RAM = 4116, BLANK=1-> VID_ON, IE=0-> INT_OFF, M1=1, M2=0-> M001=TEXT_MODE, Reserved=0, SIZE=0-> SPRITE_SIZE_8x8, MAG=0-> Magnification 1x 
	defb	vdpNameAdr/&400			;Name Table Base Address->			1 x &400 = &0400.. &07c0
	defb	vdpColAdr/&40			;Color Table Base Address->			8 x  &40 = &0200
	defb	vdpPatAdr/&800			;Pattern Generator Base Address->		1 x &800 = &0800.. &0fff
	defb	vdpSpriteAttAdr/&80		;Sprite Attribute Table Base Address->		6 x  &80 = &0300
	defb	vdpSpriteAttAdr/&800		;Sprite Pattern Generator Base Address->	0 x &800 = &0000
	defb	cdpColBlack*16+cdpColCyan	;Text Color 1 , Text Color 2 / Backdrop Color->	Black, Cyan

vramWrite:					;setup table address in hl, VRAM target address in de, table length in bc
	push	af
	push	de				;save VRAM target address
	push	hl				;save setup table address
	push	bc				;safe table length
	ld	bc,pVideo40Vdp			;VDP write Port
	out	(c),e				;send LSB of VRAM Address to VDP
	ld	a,VramW
	or	d
	out	(c),a				;send MSB of VRAM Address ored with write flag to VDP
	
	ld	bc,pVideo40Vram			;VRAM write Port
	pop	de				;restore table length
	push	de				;save table length
vramWriteLoop:
	ld	a,(hl)				;				 7tc -> 0,875us
	ld	a,(hl)				;loop has to last 8us		 7tc -> 0,875us
	ld	a,(hl)				;get data			 7tc -> 0,875us
	inc	hl				;				 6tc -> 0,75us
	out	(c),a				;send data to VRAM		12tc -> 1,5us
	dec	de				;				 6tc -> 0,75us
	ld	a,d				;				 4tc -> 0,5us
	or	e				;all done yet?			 4tc -> 0,5us
	jr	nz,vramWriteLoop		;no, go again			12tc -> 1,5us
	pop	bc				;restore table length		---------------
	pop	hl				;restore setup table address	65tc -> 8,125us
	pop	de				;restore VRAM target address
	pop	af
	ret

vramFill:					;fill Value in a, VRAM target address in hl, length in bc
	push	af
	push	hl
	push	de
	push	bc	
	ld	e,a				;value to be written
	ld	bc,pVideo40Vdp			;VDP write Port
	out	(c),l				;send LSB of VRAM Address to VDP
	ld	a,VramW
	or	h
	out	(c),a				;send MSB of VRAM Address ored with write flag to VDP
	
	ld	bc,pVideo40Vram			;VRAM write Port
	pop	hl				;resotre number of bytes to be written
	push	hl				;save number of bytes to be written
vramFillLoop:
	ld	a,(hl)				;				 7tc -> 0,875us
	ld	a,(hl)				;				 7tc -> 0,875us
	neg					;				 8tc -> 1,0us
	nop					;loop has to last 8us		 4tc -> 0,5us
	out	(c),e				;send data to VRAM		12tc -> 1,5us 	
	dec	hl				;				 6tc -> 0,75us
	ld	a,h				;				 4tc -> 0,5us
	or	l				;all done yet?		 	 4tc -> 0,5us
	jr	nz,vramFillLoop			;no, go again			12tc -> 1,5us
	pop	bc				;				--------------
	pop	de				;				64tc -> 8,0us
	pop	hl
	pop	af
	ret

vramClearTextScreen:
	push	af
	push	hl
	push	bc
	ld	a,' '
	ld	hl,&0400			;Name Table Base Address
	ld	bc,960				;40x24 characters in text mode
	call	vramFill
	pop	bc
	pop	hl
	pop	af
	ret

vramSendString:					;string address in hl, VRAM target address in de
	push	af
	push	hl
	push	bc	
	ld	bc,pVideo40Vdp			;VDP write Port
	out	(c),e				;send LSB of VRAM Address to VDP
	ld	a,VramW
	or	d
	out	(c),a				;send MSB of VRAM Address ored with write flag to VDP
	
	ld	bc,pVideo40Vram			;VRAM write Port
vramSendStringLoop:
	ld	a,(hl)				;get data
	or	a				;all done yet?
	jr	z,vramSendStringExit		;yes, exit loop
	inc	hl
	cp	' '
	jr	c,vramSendStringLoop
	cp	&80
	jr	nc,vramSendStringLoop
	out	(c),a				;send data to VRAM
	jr	vramSendStringLoop		;go again
vramSendStringExit:
	pop	bc
	pop	hl
	pop	af
	ret

vramRead:					;target Ram address in hl, VRAM read address in de, number of bytes to read in bc
	push	af
	push	de				;save VRAM target address
	push	hl				;save setup table address
	push	bc				;safe table length
	ld	bc,pVideo40Vdp			;VDP write Port
	out	(c),e				;send LSB of VRAM Address to VDP
	ld	a,VramR
	and	d
	out	(c),a				;send MSB of VRAM Address with cleared write flag to VDP
	
	ld	bc,pVideo40Vram			;VRAM write Port
	pop	hl				;Address of Pattern table
	pop	de				;Length of Pattern table
	push	de
	push	hl
vramReadLoop:
	in	a,(c)				;get data from VRAM
	ld	(hl),a				;store data
	inc	hl
	dec	de
	ld	a,d
	or	e				;all done yet?
	jr	nz,vramReadLoop			;no, go again
	pop	bc
	pop	hl
	pop	de
	pop	af
	ret

vramVerify:					;setup table address in hl, VRAM target address in de, table length in bc
	push	hl				;save setup table address
	push	bc				;safe table length	
	ld	bc,pVideo40Vdp			;VDP write Port
	out	(c),e				;send LSB of VRAM Address to VDP
	ld	a,VramR
	and	d
	out	(c),a				;send MSB of VRAM Address with cleared write flag to VDP
	
	ld	bc,pVideo40Vram			;VRAM write Port
	pop	de				;number of data bytes
	push	de
vramVerifyLoop:
	in	a,(c)				;send data to VRAM		12tc -> 1,5us
	cp	(hl)				;loop has to last 8us		 7tc -> 0,875us
	cp	(hl)				;get data			 7tc -> 0,875us
	jr	nz,verifyError			;				 7tc -> 0,875us
	inc	hl				;				 6tc -> 0,75us
	dec	de				;				 6tc -> 0,75us
	ld	a,d				;				 4tc -> 0,5us
	or	e				;all done yet?			 4tc -> 0,5us
	jr	nz,vramVerifyLoop		;no, go again			12tc -> 1,5us
	pop	bc				;				---------------
	pop	hl				;				65tc -> 8,125us
	xor	a
	ret
verifyError:
	pop	bc
	pop	hl
	ld	a,&ff
	or	a
	ret

vdpPatLen	equ 768				;Length of Pattern table
tabVdpPattern:
	defb	&00,&00,&00,&00,&00,&00,&00,&00	;Character ' ', ASCII &20	
	defb	&20,&20,&20,&20,&20,&00,&20,&00	;Character '!', ASCII &21	
	defb	&50,&50,&50,&00,&00,&00,&00,&00	;Character '"', ASCII &22	
	defb	&50,&50,&f8,&50,&f8,&50,&50,&00	;Character '#', ASCII &23	
	defb	&20,&78,&a0,&70,&28,&f0,&20,&00	;Character '$', ASCII &24	
	defb	&c0,&c8,&10,&20,&40,&98,&18,&00	;Character '%', ASCII &25	
	defb	&40,&a0,&a0,&40,&a8,&90,&a8,&00	;Character '&', ASCII &26	
	defb	&20,&20,&20,&00,&00,&00,&00,&00	;Character ''', ASCII &27	
	defb	&20,&40,&80,&80,&80,&40,&20,&00	;Character '(', ASCII &28	
	defb	&20,&10,&08,&08,&08,&10,&20,&00	;Character ')', ASCII &29	
	defb	&20,&a8,&70,&20,&70,&a8,&20,&00	;Character '*', ASCII &2a	
	defb	&00,&20,&20,&f8,&20,&20,&00,&00	;Character '+', ASCII &2b	
	defb	&00,&00,&00,&00,&20,&20,&40,&00	;Character ',', ASCII &2c	
	defb	&00,&00,&00,&f8,&00,&00,&00,&00	;Character '-', ASCII &2d	
	defb	&00,&00,&00,&00,&00,&00,&20,&00	;Character '.', ASCII &2e	
	defb	&00,&08,&10,&20,&40,&80,&00,&00	;Character '/', ASCII &2f	
	defb	&70,&88,&98,&a8,&c8,&88,&70,&00	;Character '0', ASCII &30	
	defb	&20,&60,&20,&20,&20,&20,&70,&00	;Character '1', ASCII &31	
	defb	&70,&88,&08,&30,&40,&80,&f8,&00	;Character '2', ASCII &32	
	defb	&f8,&08,&10,&30,&08,&88,&70,&00	;Character '3', ASCII &33	
	defb	&10,&30,&50,&90,&f8,&10,&10,&00	;Character '4', ASCII &34	
	defb	&f8,&80,&f0,&08,&08,&88,&70,&00	;Character '5', ASCII &35	
	defb	&38,&40,&80,&f0,&88,&88,&70,&00	;Character '6', ASCII &36	
	defb	&f8,&08,&10,&20,&40,&40,&40,&00	;Character '7', ASCII &37	
	defb	&70,&88,&88,&70,&88,&88,&70,&00	;Character '8', ASCII &38	
	defb	&70,&88,&88,&78,&08,&10,&e0,&00	;Character '9', ASCII &39	
	defb	&00,&00,&20,&00,&20,&00,&00,&00	;Character DP , ASCII &3a	
	defb	&00,&00,&20,&00,&20,&20,&40,&00	;Character ';', ASCII &3b	
	defb	&10,&20,&40,&80,&40,&20,&10,&00	;Character '<', ASCII &3c	
	defb	&00,&00,&f0,&00,&f8,&00,&00,&00	;Character '=', ASCII &3d	
	defb	&40,&20,&10,&08,&10,&20,&40,&00	;Character '>', ASCII &3e	
	defb	&70,&88,&10,&20,&20,&00,&20,&00	;Character '?', ASCII &3f	

	defb	&70,&88,&a8,&b8,&b0,&80,&78,&00	;Character '@', ASCII &40	
	defb	&20,&50,&88,&88,&f8,&88,&88,&00	;Character 'A', ASCII &41	
	defb	&f0,&88,&88,&f0,&88,&88,&f0,&00	;Character 'B', ASCII &42	
	defb	&70,&88,&80,&80,&80,&88,&70,&00	;Character 'C', ASCII &43	
	defb	&f0,&88,&88,&88,&88,&88,&f0,&00	;Character 'D', ASCII &44	
	defb	&f8,&80,&80,&f0,&80,&80,&f8,&00	;Character 'E', ASCII &45	
	defb	&f8,&80,&80,&f0,&80,&80,&80,&00	;Character 'F', ASCII &46	
	defb	&78,&80,&80,&98,&88,&88,&78,&00	;Character 'G', ASCII &47	
	defb	&88,&88,&88,&f8,&88,&88,&88,&00	;Character 'H', ASCII &48	
	defb	&70,&20,&20,&20,&20,&20,&70,&00	;Character 'I', ASCII &49	
	defb	&08,&08,&08,&08,&08,&88,&70,&00	;Character 'J', ASCII &4a	
	defb	&88,&90,&a0,&c0,&a0,&90,&88,&00	;Character 'K', ASCII &4b	
	defb	&80,&80,&80,&80,&80,&80,&f8,&00	;Character 'L', ASCII &4c	
	defb	&88,&d8,&a8,&a8,&88,&88,&88,&00	;Character 'M', ASCII &4d	
	defb	&88,&88,&c8,&a8,&98,&88,&88,&00	;Character 'N', ASCII &4e	
	defb	&70,&88,&88,&88,&88,&88,&70,&00	;Character 'O', ASCII &4f	
	defb	&f0,&88,&88,&f0,&80,&80,&80,&00	;Character 'P', ASCII &50	
	defb	&70,&88,&88,&88,&a8,&90,&68,&00	;Character 'Q', ASCII &51	
	defb	&f0,&88,&88,&f0,&A0,&90,&88,&00	;Character 'R', ASCII &52	
	defb	&70,&88,&80,&70,&08,&88,&70,&00	;Character 'S', ASCII &53	
	defb	&f8,&20,&20,&20,&20,&20,&20,&00	;Character 'T', ASCII &54	
	defb	&88,&88,&88,&88,&88,&88,&70,&00	;Character 'U', ASCII &55	
	defb	&88,&88,&88,&88,&88,&50,&20,&00	;Character 'V', ASCII &56	
	defb	&88,&88,&88,&a8,&a8,&d8,&88,&00	;Character 'W', ASCII &57	
	defb	&88,&88,&50,&20,&50,&88,&88,&00	;Character 'X', ASCII &58	
	defb	&88,&88,&50,&20,&20,&20,&20,&00	;Character 'Y', ASCII &59	
	defb	&f8,&08,&10,&20,&40,&80,&f8,&00	;Character 'Z', ASCII &5a	
	defb	&f8,&c0,&c0,&c0,&c0,&c0,&f8,&00	;Character '[', ASCII &5b	
	defb	&00,&80,&40,&20,&10,&08,&00,&00	;Character '\', ASCII &5c	
	defb	&f8,&18,&18,&18,&18,&18,&f8,&00	;Character ']', ASCII &5d	
	defb	&00,&00,&20,&50,&88,&00,&00,&00	;Character '^', ASCII &5e	
	defb	&00,&00,&00,&00,&00,&00,&00,&f8	;Character '_', ASCII &5f	
	
	defb	&40,&20,&10,&00,&00,&00,&00,&00	;Character '`', ASCII &60	
	defb	&00,&00,&f0,&08,&78,&88,&f0,&00	;Character 'a', ASCII &61	
	defb	&80,&80,&80,&f0,&88,&88,&f0,&00	;Character 'b', ASCII &62	
	defb	&00,&00,&78,&80,&80,&80,&78,&00	;Character 'c', ASCII &63	
	defb	&08,&08,&08,&78,&88,&88,&78,&00	;Character 'd', ASCII &64	
	defb	&00,&00,&70,&88,&f0,&80,&78,&00	;Character 'e', ASCII &65	
	defb	&18,&20,&20,&30,&20,&20,&20,&00	;Character 'f', ASCII &66	
	defb	&00,&00,&78,&88,&88,&78,&08,&70	;Character 'g', ASCII &67	
	defb	&80,&80,&80,&f0,&88,&88,&88,&00	;Character 'h', ASCII &68	
	defb	&00,&20,&00,&30,&20,&20,&70,&00	;Character 'i', ASCII &69	
	defb	&00,&08,&00,&08,&08,&08,&48,&30	;Character 'j', ASCII &6a	
	defb	&40,&40,&50,&60,&60,&50,&48,&00	;Character 'k', ASCII &6b	
	defb	&40,&40,&40,&40,&40,&40,&30,&00	;Character 'l', ASCII &6c	
	defb	&00,&00,&d0,&a8,&a8,&a8,&a8,&00	;Character 'm', ASCII &6d	
	defb	&00,&00,&f0,&88,&88,&88,&88,&00	;Character 'n', ASCII &6e	
	defb	&00,&00,&70,&88,&88,&88,&70,&00	;Character 'o', ASCII &6f	
	defb	&00,&00,&f0,&88,&88,&f0,&80,&80	;Character 'p', ASCII &70	
	defb	&00,&00,&78,&88,&88,&78,&08,&0c	;Character 'q', ASCII &71	
	defb	&00,&00,&38,&40,&40,&40,&40,&00	;Character 'r', ASCII &72	
	defb	&00,&00,&70,&80,&70,&08,&f0,&00	;Character 's', ASCII &73	
	defb	&20,&20,&70,&20,&20,&20,&18,&00	;Character 't', ASCII &74	
	defb	&00,&00,&88,&88,&88,&88,&70,&00	;Character 'u', ASCII &75	
	defb	&00,&00,&88,&88,&50,&50,&20,&00	;Character 'v', ASCII &76	
	defb	&00,&00,&88,&88,&a8,&a8,&50,&00	;Character 'w', ASCII &77	
	defb	&00,&00,&88,&50,&20,&50,&88,&00	;Character 'x', ASCII &78	
	defb	&00,&00,&88,&88,&88,&78,&08,&70	;Character 'y', ASCII &79	
	defb	&00,&00,&f8,&10,&20,&40,&f8,&00	;Character 'z', ASCII &7a	
	defb	&38,&40,&20,&c0,&20,&40,&38,&00	;Character '{', ASCII &7b	
	defb	&40,&20,&10,&08,&10,&20,&40,&00	;Character '|', ASCII &7c	
	defb	&e0,&10,&20,&18,&20,&10,&e0,&00	;Character '}', ASCII &7d	
	defb	&40,&a8,&10,&00,&00,&00,&00,&00	;Character '~', ASCII &7e	
	defb	&a8,&50,&a8,&50,&a8,&50,&a8,&00	;Character ' ', ASCII &7f	
