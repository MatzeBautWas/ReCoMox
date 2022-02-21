; ReCoMox Monitor V1.0

;File		ReCoMoxMon10.asm
;Version	V1.0
;Date		2022/02/02
;Content	ReCoMox Monitor Program
;-------------------------------------------------------------------------

write "ReCoMoxMon10.bin"

VersionMain	equ	&01
VersionStep	equ	&00

read "defines10.asm"

org ramBase
ramStart:
appStart:
	defw	appEntry
appLength:
	defw	checksum-appStart
intStart:
	defw	intEntry
intChecksum:
	defw	-intEntry

version:
	defb	"ReCoMox Monitor V1.0 21.02.2022", AsciiLF, AsciiCR, 0

read "IfInOut10.asm"
read "Interrupt10.asm"
read "Timer10.asm"
read "Uart10.asm"
read "VDP9929A10.asm"
read "command10.asm" 
read "Functions10.asm"
read "Clock10.asm"
read "DisAss10.asm"

appEntry:
	di
	ld	sp,&0000

;	jp	ttest

	ld	hl,49999			;20MHz/(8*50000)=50Hz
	call	timerInit

	ld	hl,BSEL_19200_20
	call	uartInit

	ld	a,16
	ld	(dumpDisplayWidth),a		;Number of values per line, in dump output  
	
	im	1
	ei

	call	uartSendCRLF
	ld	hl,version
	call	uartSendString
	call	uartWaitTxBufferEmpty

	ld	hl,tabVdpTextInit
	call	vdpInit

	ld	hl,tabVdpPattern		;Address of Pattern table
	ld	de,&20*8+vdpPatAdr		;target address in VRAM + offset &20x8 because table starts with char(&20)=" "
	ld	bc,vdpPatLen			;Length of Pattern table
	call	vramWrite			;copy pattern table to VRam

	ld	hl,version
	ld	de,vdpNameAdr			;Name Table Base Address
	call	vramSendString		

ttLoop:
;	call	uartManageTxBuffer
;	call	uartGetChar			;a=char, CFlag=0 if successfull
;	jr	c,ttLoop
;	call	uartSendHex	
;	ex	af,af'
;	ld	a,'='
;	call	uartSendChar
;	ex	af,af'
;	call	uartSendChar
;	ld	a,','
;	call	uartSendChar
;	jr	ttLoop

monNxtCmd:
	ld	hl,monBufferCnt
	call	monBufferClear			;hl has to be pointer to buffer counter
monParseLoop:
	call	uartManageTxBuffer
	call	uartGetChar			;a=char, CFlag is set if successfull
	jr	nc,monParseLoop

	call	uartSendChar
	cp	asciiBS
	jr	nz,monNoBufferBs
	call	monBufferDel			;hl has to be pointer to buffer counter
	ld	a,' '
	call	uartSendChar
	ld	a,asciiBS
	call	uartSendChar
	jr	monParseLoop
monNoBufferBs:
	cp	asciiCR
	jr	nz,monNoParseExec
	inc	hl				;set pointer to start of command
	call	monParseExec
	jr	monNxtCmd
monNoParseExec:
	cp	asciiDEL
	jr	nz,monNoBufferDel		;hl has to be pointer to buffer counter
	call	monBufferDel
	jr	monParseLoop
monNoBufferDel:
	jr	nc,monParseLoop
	cp	' '
	jr	c,monParseLoop
	call	monBufferAdd
	jr	monParseLoop

monParseExec:
	call	uartSendCrLf
	ld	de,tabComIndex
	call	monParseCmd			;if successfull -> C-flag set, Input -> HL=pointer to command string, DE=Command description Table, Output -> HL=pointer to command string, DE=pointer to command description
	jr	nc,monCmdError

	ld	iy,cmdParaTab			;IY  = pointer to command parameter table
	ld	bc,3				;BC  = IY increment

	push	de
	exx					
	pop	hl				;HL' = pointer to command description
	ld	e,(hl)
	inc	hl
	ld	d,(hl)				;DE' = Address of command execution subroutine
	ld	b,cmdParaTabLength		;B'  = Max Number of Parameters

monParaLoop:
	exx					;HL = pointer to command string
	call	parseLiteral			;HL = decoded Number, A = literal type
	jr	nc,monNoMoreParas
	ld	(iy+0),a			;store literal type in the command parameter table
	ld	(iy+1),e
	ld	(iy+2),d			;store literal value in the command parameter table
	add	iy,bc				;BC  = IY increment
	call	skipBlanks
	cp	','				;search for komma
	jr	nz,monNoMoreParas
	inc	hl
	exx					;DE' = Address of command execution subroutine
	djnz	monParaLoop			;B'  = Max Number of Parameters
	exx
monNoMoreParas:
	exx
	ld	(iy+0),0			;store table termination
	ex	de,hl				;HL' = Address of command execution subroutine
	jp	(hl)				;execute command

monCmdError:
	ret	z
	ld	hl,txtMonCmdError
	call	uartSendString
	call	uartWaitTxBufferEmpty
	ret

monBufferAdd:	
	ex	af,af'
	ld	a,(hl)
	cp	79
	ret	nc
	inc	(hl)				;if not full increment buffer counter
	push	hl				;safe pointer to buffer
	push	bc
	ld	c,a
	inc	c
	ld	b,0
	add	hl,bc				;calculate pointer to last entry
	ex	af,af'
	ld	(hl),a
	inc	hl
	ld	(hl),0
	pop	bc
	pop	hl				;restore pointer to buffer		
	ret

monBufferDel:
	ld	a,(hl)				;get buffer counter
	or	a				;check if buffer not empty
	ret	z				;if empty, do nothing
	dec	(hl)				;if not empty decement buffer counter
	push	hl				;safe pointer to buffer
	push	bc
	ld	c,a
	inc	c
	ld	b,0
	add	hl,bc				;calculate pointer to last entry
	ld	(hl),b				;delete last entry
	pop	bc
	pop	hl				;restore pointer to buffer
	ret

monBufferClear:
	push	af
	xor	a
	ld	(hl),a
	inc	hl
	ld	(hl),a
	dec	hl
	pop	af
	ret	

;----------------------------------------------------------------------------------------

parseLiteral:					;if successfull -> C-flag set,  
	push	bc				;Input -> HL=pointer to literal string, 
	ex	af,af'				;Output -> HL=pointer to literal string, DE=decoded Number/Pointer to string, A=detected literal type
	xor	a				;clear flags in a'
plStartAgain:
	ex	af,af'
	call	skipBlanks			;a = char

	cp	'+'
	jr	nz,plNoPlus
	ex	af,af'
	and	FLG_PN_POS+FLG_PN_NEG
	jr	nz,plError
	or	FLG_PN_POS
	inc	hl
	jr	plStartAgain
	
plNoPlus:
	cp	'-'
	jr	nz,plNoMinus
	ex	af,af'
	and	FLG_PN_POS+FLG_PN_NEG
	jr	nz,plError
	or	FLG_PN_NEG
	inc	hl
	jr	plStartAgain

plNoMinus:	
	cp	'~'
	jr	nz,plNoTilde
	ex	af,af'
	and	FLG_PN_POS+FLG_PN_NEG
	jr	nz,plError
	or	FLG_PN_INV
	inc	hl
	jr	plStartAgain

plNoTilde:
	ex	af,af'
	and	FLG_PN_POS+FLG_PN_NEG+FLG_PN_INV
	jr	nz,plSkipSetPlus
	or	FLG_PN_POS
plSkipSetPlus:
	ex	af,af'

	cp	&27				;''' char
	jr	nz,plNoHK
	call	plHK				;a = char, a' = flags, HL=pointer to literal string
	jr	z,plError
	jp	plEnd

plNoHK:	
	cp	'0'
	jr	nz,plNoZero
	inc	hl
	ld	a,(hl)
	call	upper
	cp	'B'
	jr	nz,plNo0B
	inc	hl
	ld	a,(hl)
	call	parseBin
	jr	z,plError
	jp	plEnd
plNo0B
	cp	'X'
	jr	nz,plNo0X
	inc	hl
	ld	a,(hl)
	call	parseHex
	jr	z,plError
	jr	plEnd

plError:
	xor	a
	pop	bc
	ret

plNo0X:
	cp	'0'
	jr	c,plZero
	cp	'9'+1
	jr	nc,plZero
	cp	'8'
	jr	nc,plNoOct
	call	parseOct			;a = char, a' = flags, HL=pointer to literal string
	jr	z,plError
	jr	plEnd	
plNoOct:
	call	parseDecimal			;a = char, a' = flags, HL=pointer to literal string
	jr	z,plError
	jr	plEnd	
plZero:
	ld	de,0
	xor	a				;set Z-flag
	ex	af,af'
	or	a,FLG_PN_DEC			;mark as decimal
	jr	plEnd	
plNoZero:	
	cp	'&'
	jr	nz,plNoAnd
	inc	hl
	ld	a,(hl)
	call	parseHex			;a = char, a' = flags, HL=pointer to literal string
	jr	z,plError
	jr	plEnd
plNoAnd:	
	cp	'%'
	jr	nz,plNoPercent
	inc	hl
	ld	a,(hl)
	call	parseBin			;a = char, a' = flags, HL=pointer to literal string
	jr	z,plError
	jr	plEnd
plNoPercent:	
	cp	'\'
	jr	nz,plNoSlash
	call	plSlash				;a = char, a' = flags, HL=pointer to literal string
	jr	z,plError
	jr	plDontNeg

plNoSlash:	
	cp	'1'
	jr	c,plElse
plLess1:	
	cp	'9'+1
	jr	nc,plElse
	call	parseDecimal			;a = char, a' = flags, HL=pointer to literal string
	jr	z,plError
	jr	plEnd
plElse:	
	cp	'_'
	jr	z,plPt:
	call	upper
	cp	'A'
	jr	c,plError
	cp	'Z'+1
	jr	nc,plError
plPt:
	ex	af,af'
	or	FLG_PN_PT
	ex	de,hl
	scf
	pop	bc
	ret
plEnd:
	ld	c,a
	and	FLG_PN_NEG
	ld	a,c
	jr	z,plDontNeg
	push	hl
	ld	l,0
	ld	h,l
	sbc	hl,de
	ex	de,hl
	pop	hl
	and	&ff-FLG_PN_NEG
	or	FLG_PN_POS
plDontNeg:
	ld	c,a
	and	FLG_PN_INV
	ld	a,c
	jr	z,plDontInv
	ex	af,af'
	ld	a,e
	cpl
	ld	e,a
	ld	a,d
	cpl
	ld	d,a
	ex	af,af'
	and	&ff-FLG_PN_INV
plDontInv:
	scf
	pop	bc
	ret

plSlash:				;Z-Flag Clear if ok, Input -> A'=Flags, HL=pointer to literal string, Output -> A=Flags, HL=pointer to literal string, DE=value of literal
	ex	af,af'
	and	FLG_PN_NEG
	jr	nz,plHkErr
	inc	hl
	ld	a,(hl)
	call	upper
	cp	'T'
	jr	nz,plNoT
	ld	e,AsciiHT
	jr	plSlashEnd
plNoT:	
	cp	'R'
	jr	nz,plNoR
	ld	e,AsciiCR
	jr	plSlashEnd
plNoR:	
	cp	'N'
	jr	nz,plNoN
	ld	e,AsciiLF
	jr	plSlashEnd
plNoN:	
	cp	'A'
	jr	nz,plHkErr
	ld	e,AsciiBEL
plSlashEnd:
	ld	d,&0
	ld	a,FLG_PN_POS
	or	a
	ret

plHK:					;Z-Flag Clear if ok, Input -> A'=Flags, HL=pointer to literal string, Output -> A=Flags, HL=pointer to literal string, DE=value of literal
	inc	hl
	ld	e,(hl)
	inc	hl
	ld	a,(hl)
	cp	&27				;''' char
	jr	nz,plHkErr
	ld	d,0
	ex	af,af'
	or	FLG_PN_POS
	ret
plHkErr:
	xor	a
	ret

parseBin:				;Input -> A=char in range of '0'..'1', A'=Flags, HL=pointer to literal string, Output -> A=Flags, HL=pointer to literal string, DE=value of literal
	ex	de,hl			;load DE with pointer to literal string
	ld	hl,0			;initialize numberwith 0
pbLoop:
	sub	'0'			;calculate digit out of char
	cp	2			;if (digit>=12)
	jr	nc,pbQuit		;	quit loop

	bit	7,h			;if (number>&7fff)	
	jr	nz,pbOverflow		;	mark Error
					;else
	rrca				;	C-flag = digit
	adc	hl,hl			;	HL=2*number+digit

	inc	de			;	(*pt)++
	ld	a,(de)			;	get next char
	jr	pbLoop

pbQuit:
	ex	de,hl			;return value in DE and pointer to literal string in hl
	ex	af,af'
	or	a,FLG_PN_BIN		;mark as binary
	ret
pbOverflow:
	ex	de,hl			;return pointer to literal string in hl
	ld	de,&ffff		;return &ffff in DE
	xor	a			;mark as invalid
	ret

parseOct:				;Input -> A=char in range of '0'..'7', A'=Flags, HL=pointer to literal string, Output -> A=Flags, HL=pointer to literal string, DE=value of literal
	push	bc
	ex	de,hl			;load DE with pointer to literal string
	ld	hl,0			;initialize numberwith 0
	ld	b,0
poLoop:
	sub	'0'			;calculate digit out of char
	cp	8			;if (digit>=8)
	jr	nc,poQuit		;	quit loop
	ld	c,a			;safe actual digit in C

	ld	a,&e0
	and	h
	jr	nz,poOverflow		;if (number>&1fff)	mark Error

	add	hl,hl			;	HL=2*number
	add	hl,hl			;	HL=4*number
	add	hl,hl			;	HL=8*number
	add	hl,bc			;	HL=8*number+digit

	inc	de			;	(*pt)++
	ld	a,(de)			;	get next char
	jr	poLoop

poQuit:
	ex	de,hl			;return value in DE and pointer to literal string in hl
	xor	a			;set Z-flag
	ex	af,af'
	or	a,FLG_PN_OCT		;mark as octa
	pop	bc
	ret
poOverflow:
	ex	de,hl			;return pointer to literal string in hl
	ld	de,&ffff		;return &ffff in DE
	pop	bc
	xor	a			;mark as invalid
	ret

parseDecimal:				;Input -> A=char in range of '0'..'9', A'=Flags, HL=pointer to literal string, Output -> A=Flags, HL=pointer to literal string, DE=value of literal
	push	bc
	push	hl			;safe pointer to literal string
	ld	hl,0			;initialize numberwith 0
	ld	b,0
pdLoop:
	sub	'0'			;calculate digit out of char
	cp	10			;if (digit>=10)
	jr	nc,pdQuit		;	quit loop
	ld	c,a			;else safe actual digit in C

	ld	de,6553
	or	a
	sbc	hl,de	
	add	hl,de		;
	jr	z,pdCheckOvf		;if (number==6553)	check if next digit is < 6
	jr	c,pdAddDigit		;if (number<6553)	add digit to number
	jr	pdOverflow		;if (number>6553)	mark Error
pdCheckOvf:
	ld	a,5			;if (number==6553)
	cp	c			;	and if (digit>5)
	jr	c,pdOverflow		;		mark Error
pdAddDigit:				;else
	add	hl,hl			;	HL=2*number
	ld	e,l
	ld	d,h			;	HL=2*number
	add	hl,hl			;	HL=4*number
	add	hl,hl			;	HL=8*number
	add	hl,de			;	HL=(8+2)*number
	add	hl,bc			;	HL=10*number+digit

	pop	de			;	restore pointer to literal string
	inc	de			;	(*pt)++
	ld	a,(de)			;	get next char
	push	de			;	safe pointer to literal string
	jr	pdLoop

pdQuit:
	ex	de,hl			;return value in DE
	pop	hl			;restore pointer to literal string
	xor	a			;set Z-flag
	ex	af,af'
	or	a,FLG_PN_DEC		;mark as decimal
	pop	bc
	ret
pdOverflow:
	pop	hl			;restore pointer to literal string
	ld	de,&ffff		;return &ffff in DE
	pop	bc
	xor	a			;mark as invalid
	ret

parseHex:				;Input -> A=char in range of '0'..'F', A'=Flags, HL=pointer to literal string, Output -> A=Flags, HL=pointer to literal string, DE=value of literal
	push	bc
	ex	de,hl			;load DE with pointer to literal string
	ld	hl,0			;initialize numberwith 0
	ld	b,0
phLoop:
	call	phHexDig2Int		;calculate digit out of char, input -> A = char, output -> A = digit, B = char, C-Flag is set, if successful
	jr	nc,phQuit		;	quit loop if digit not in range of &0..&f
	ld	c,a			;safe actual digit in C

	ld	a,&f0
	and	h
	jr	nz,phOverflow		;if (number>&0fff)	mark Error

	add	hl,hl			;	HL=2*number
	add	hl,hl			;	HL=4*number
	add	hl,hl			;	HL=8*number
	add	hl,hl			;	HL=16*number
	add	hl,bc			;	HL=16*number+digit

	inc	de			;	(*pt)++
	ld	a,(de)			;	get next char
	jr	phLoop

phQuit:
	ex	de,hl			;return value in DE and pointer to literal string in hl
	xor	a			;set Z-flag
	ex	af,af'
	or	a,FLG_PN_HEX		;mark as hexadecimal
	pop	bc
	ret
phOverflow:
	ex	de,hl			;return pointer to literal string in hl
	ld	de,&ffff		;return &ffff in DE
	pop	bc
	xor	a			;mark as invalid
	ret

phHexDig2Int:				;input A = char, output A = digit, B = char, C-Flag is set, if successful
	ld	c,a
	call	upper
	sub	'0'			;convert ASCII digit to int 
	cp	10
	ret	c			;if number between 0..9 set C-flag and return that number
	sub	'A'-'0'-10		;check if &A..&F
	cp	&0a			;if (digit < &A)
	ccf				;	marc as invalid
	jr	nc,phHexDig2IntErr
	cp	&10			;if (digit >= &10) C-flag is cleared 	
	ret	c			;else C-flag is set
phHexDig2IntErr:
	ld	a,c			;if conversion not possible, return original char with cleared C-Flag 
	ret

ttest:
	ld	hl,&8000
	ld	(hl),&fd
	inc	hl
	ld	(hl),&cb
	inc	hl
	ld	(hl),&a5
	inc	hl
	ld	(hl),&7e		;LD C,(iy-&5b)
	inc	hl
	ld	(hl),&dd
	inc	hl
	ld	(hl),&75
	inc	hl
	ld	(hl),&22		;BIT 7,(ix+&22)
	ld	hl,testString
	call	monParseExec	
	jp	appEntry			
teststring:
	defb	"disass&8000,2",asciiLF,asciiCR,asciiNUL

;----------------------------------------------------------------------------------------

checksum:
	defb	&78,&48,&fe
appEnd:

read "variables.asm"
