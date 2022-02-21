; ReCoMox Monitor UART V1.0

;File		Uart10.asm
;Version	V1.0
;Date		2022/02/09
;Content	Command Interpreter for the ReCoMox Monitor
;-------------------------------------------------------------------------

;monParseCmd
;cmdHelp
;cmdSv

;tabComIndex


monParseCmd:					;if successfull -> C-flag set else Z-flag set if no command , Z-Flag clear if command not defined
	call	skipBlanks			;Input -> HL=pointer to command string, DE=Command description Table, 
	or	a				;Output -> HL=pointer to command string, DE=pointer to command description
	ret	z				;no character found (C-flag cleared)
	call	upper				;convert to capital letter
	cp	'Z'+1
	jr	nc,cmdNoLetter
	sub	'?'
	jr	c,cmdNoLetter
	add	a,a
	ld	c,a
	inc	hl
	ld	a,(hl)
;	or	a
;	ret	z				;a valid command has at least two characters (C-flag cleared)
	push	hl				;safe pointer to actual character
	ex	de,hl
	ld	b,0
	add	hl,bc				;calculate pointer to command first letter table
	ld	e,(hl)
	inc	hl
	ld	d,(hl)				;pointer to the command string table in de
cmdTryAgain
	pop	hl				;restore pointer to actual character in hl
	push	hl

cmdParseLoop:
	ld	a,(de)				;get char out of table
	cp	'!'
	ld	c,a
	ld	a,(hl)				;get cmd char
	jr	c,cmdEndOf
	call	upper				;convert to capital letter
	cp	c				;compare with char in table
	jr	nz,cmdSkipThis
	inc	hl
	inc	de
	jr	cmdParseLoop

cmdNoLetter:
	xor	a				;clear C-flag, Set Z-Flag
	ret

cmdEndOf:
	call	upper				;convert to capital letter
	cp	'?'+1				;cmd char < '?'
	jr	c,cmdFound			;yes -> cmd found in table, return result
	cp	'_'				;cmd char > '_'
	jr	nc,cmdFound			;yes -> cmd found in table, return result

cmdSkipThis:
	inc	de				;pointer to cmd description table
	ld	a,(de)				;get next char
	cp	'!'				;some kind of control char?
	jr	nc,cmdSkipThis			
	cp	AsciiEOT			
	jr	z,cmdTryNxt
	pop	hl				;tidy up stack
	xor	a				;clear C-flag
	dec	a				;clear Z-Flag
	ret

cmdTryNxt:
	ld	hl,5				;skip Address of cmd execution subroutine,
	add	hl,de				;     Address of cmd description string,
	ex	de,hl				;     number of parameters
	jr	cmdTryAgain
	
cmdFound:
	pop	bc				;tidy up stack
	inc	de				;pointer to command description table in de
	scf					;set C-flag
	ret

tabComIndex:
	defw	comQM,comAT,comA, comB, comC, comD, comE, comF
	defw	comG, comH, comI, comJ, comK, comL, comM, comN
	defw	comO, comP, comQ, comR, comS, comT, comU, comV
	defw	comW, comX, comY, comZ

;commad Table -> Command Name string, NUL or EOT, Address of command execution subroutine, Address of Command description string, Number of Parameters
comQM:	defb	"?",AsciiNUL
	defw	cmdHelp, descriptHelp
;	defb	0
comAT:	defb	AsciiNUL
comA:	defb	"NI", AsciiNUL
	defw	cmdShowAni, descriptShowAni
;	defb	1
comB:	defb	"ANK", AsciiNUL
	defw	cmdBank, descriptBank
;	defb	1
comC:	defb	"ALL",AsciiEOT
	defw	cmdCall, descriptCall
;	defb	1
	defb	"LOCK",AsciiNUL
	defw	cmdClkShow, descriptClkShow
;	defb	0
comD:	defb	"UMP",AsciiEOT
	defw	cmdDump, descriptDump
;	defb	2
	defb	"ISASS",AsciiNUL
	defw	cmdDisass, descriptDisass
;	defb	1
comE:	defb	AsciiNUL
comF:	defb	"ILL",AsciiNUL
	defw	cmdFill, descriptFill
;	defb	2
comG:	defb	AsciiNUL
comH:	defb	"ELP",AsciiEOT
	defw	cmdHelp, descriptHelp
;	defb	0
	defb	"EX",AsciiNUL
	defw	cmdHex, descriptHex
;	defb	0
comI:	defb	"N",AsciiNUL
	defw	cmdIn, descriptIn
;	defb	1
comJ:	;defb	AsciiNUL
comK:	;defb	AsciiNUL
comL:	;defb	AsciiNUL
comM:	;defb	AsciiNUL
comN:	defb	AsciiNUL
comO:	defb	"UT",AsciiNUL
	defw	cmdOut, descriptOut
;	defb	2
comP:	defb	"ARSE",AsciiEOT
	defw	cmdParse, descriptParse
;	defb	1
	defb	"EEK",AsciiEOT
	defw	cmdPeek, descriptPeek
;	defb	1
	defb	"OKE",AsciiNUL
	defw	cmdPoke, descriptPoke
;	defb	2
comQ:	;defb	AsciiNUL
comR:	defb	AsciiNUL
comS:	defb	"V",AsciiNUL
	defw	cmdSv, descriptSv
;	defb	0
comT:	;defb	AsciiNUL
comU:	;defb	AsciiNUL
comV:	;defb	AsciiNUL
comW:	;defb	AsciiNUL
comX:	;defb	AsciiNUL
comY:	;defb	AsciiNUL
comZ:	defb	AsciiNUL

;------------------------------------------------------------------------------------------

cmdHelp:
	ld	b,'?'
	ld	hl,tabComIndex
cmdHelpLoop:	
	ld	e,(hl)
	inc	hl
	ld	d,(hl)				;get pointer to command definitions with the same first letter
	inc	hl

	ld	a,(de)				;get the second letter
	or	a				;is it NULL?
	jr	z,cmdHelpNxt			;no command for this first letter is available
	ld	c,a				;save second letter
	ld	a,b				;get first letter
	call	uartSendChar			;print first letter
	ld	a,c				;restore second letter
	push	hl				;save pointer to command letter table

cmdHelpNameLoop:
	call	uartSendChar			;print letter
	inc	de
	ld	a,(de)				;get next letter
	cp	'?'				;is it '?', 'A', 'B', ..., 'Z' ?
	jr	nc,cmdHelpNameLoop		;yes -> print letter and repeat
	ld	c,a				;save the termination character in c
	ld	hl,txtArrow
	call	uartSendString			;print " -> "
	inc	de
	inc	de
	inc	de				;skip the Address of command execution subroutine
	ld	a,(de)
	ld	l,a
	inc	de
	ld	a,(de)				;get the Address of Command description string
	ld	h,a
	call	uartSendString
	call	uartSendCRLF
	call	uartWaitTxBufferEmpty
	ld	a,c
	cp	AsciiEOT
	jr	nz,cmdHelpLetterTerm
	inc	de
;	inc	de				;skip Number of Parameters
	ld	a,b				;get first letter
	call	uartSendChar			;print first letter
	ld	a,(de)				;get the second letter
	jr	cmdHelpNameLoop			;print letter and repeat

cmdHelpLetterTerm:
	pop	hl				;restore pointer to command letter table
cmdHelpNxt:
	inc	b
	ld	a,'Z'
	cp	b
	jr	nc,cmdHelpLoop
	ret
txtArrow:
	defb	" -> ", AsciiNUL
descriptHelp:
	defb	"Display Help", AsciiNUL

cmdSv:
	ld	hl,version
	call	uartSendString
	jp	uartWaitTxBufferEmpty
descriptSv:
	defb	"Show Version",AsciiNUL

cmdCall:
	ld	iy,cmdParaTab
	call	cmdGetValue		;get address			
	jp	nc,cmdAdrErr
	ld	a,(iy+0)
	or	a			;if (data still available)
	jp	nz,cmdParaErr		;	output Error
	ex	de,hl			;hl=address
	jp	(hl)			;execute Call
descriptCall:
	defb	"Call <Address>", AsciiNUL
	ret

cmdIn:
	ld	iy,cmdParaTab
	call	cmdGetValue		;get port			
	jp	nc,cmdAdrErr
	ld	a,(iy+0)
	or	a			;if (data still available)
	jp	nz,cmdParaErr		;	output Error
	ld	a,'0'
	call	uartSendChar
	ld	a,'x'
	call	uartSendChar
	ld	c,e
	ld	b,d
	in	a,(c)
	call	uartSendHex
	call	uartSendCRLF
	jp	uartWaitTxBufferEmpty
descriptIn:
	defb	"In <Port>", AsciiNUL

cmdOut:
	ld	iy,cmdParaTab
	call	cmdGetValue		;get address			
	jp	nc,cmdAdrErr
	ld	c,e
	ld	b,d			;hl=address
	call	cmdGetValue		;get data			
	jp	nc,cmdDataErr
	ld	a,d
	or	a			;if (data > 255)
	jp	nz,cmdRangeErr		;	output Error
	ld	a,(iy+0)
	or	a			;if (data still available)
	jp	nz,cmdParaErr		;	output Error
	out	(c),e			;execute Out
	ret
descriptOut:
	defb	"Out <Port>, <Value>", AsciiNUL

cmdParse:
	ld	iy,cmdParaTab
cpParseLoop:
	call	cmdGetValue
	ret	z
	jr	nc,cpNoValue
	ld	hl,txtParseStatus
	call	uartSendString
	call	uartSendHex
	ld	hl,txtParseValue
	call	uartSendString
	ld	a,d
	call	uartSendHex
	ld	a,e
	call	uartSendHex
	call	uartSendCRLF
	call	uartWaitTxBufferEmpty
	jr	cpParseLoop
cpNoValue:
	call	cmdGetPointer
	ret	z
	jr	nc,cpParseLoop
	ld	hl,txtParseStatus
	call	uartSendString
	call	uartSendHex
	ld	hl,txtParseString
	call	uartSendString
cpStringLoop:
	ld	a,(de)
	cp	'!'
	jr	c,cpQuitStringLoop
	call	uartSendChar
	inc	de
	jr	cpStringLoop
cpQuitStringLoop:
	call	uartSendCRLF
	jp	uartWaitTxBufferEmpty	
descriptParse:
	defb	"Parse <Literal1>, < Literal2>, ...", AsciiNUL
txtParseStatus:
	defb	"Status: 0x", AsciiNUL
txtParseValue:
	defb	", Value:  0x", AsciiNUL
txtParseString:
	defb	", Value:  ", AsciiNUL

cmdPeek:
	ld	iy,cmdParaTab
	call	cmdGetValue		;get address			
	jp	nc,cmdAdrErr
	ld	a,(iy+0)
	or	a			;if (data still available)
	jp	nz,cmdParaErr		;	output Error
	ld	a,'0'
	call	uartSendChar
	ld	a,'x'
	call	uartSendChar
	ld	a,(de)
	call	uartSendHex
	call	uartSendCRLF
	jp	uartWaitTxBufferEmpty
descriptPeek:
	defb	"Peek <Address>", AsciiNUL

cmdPoke:
	ld	iy,cmdParaTab
	call	cmdGetValue		;get address			
	jp	nc,cmdAdrErr
	ex	de,hl			;hl=address
	call	cmdGetValue		;get data			
	jp	nc,cmdDataErr
	ld	a,d
	or	a			;if (data > 255)
	jp	nz,cmdRangeErr		;	output Error
	ld	a,(iy+0)
	or	a			;if (data still available)
	jp	nz,cmdParaErr		;	output Error
	ld	(hl),e			;execute Poke
	ret
descriptPoke:
	defb	"Poke <Address>, <Value>", AsciiNUL

cmdShowAni:
	ld	iy,cmdParaTab
	call	cmdGetValue		;get data			
	jp	nc,cmdDataErr
	ld	a,d
	or	a			;if (data > 255)
	jp	nz,cmdRangeErr		;	output Error
	ld	a,e
	cp	5			;if (data >=5)
	jp	nc,cmdRangeErr		;	output Error
	ld	a,(iy+0)
	or	a			;if (data still available)
	jp	nz,cmdParaErr		;	output Error
	ld	a,e
	jp	showAnimation
descriptShowAni:
	defb	"Show Animation <Select>", AsciiNUL

cmdFill:
	ld	iy,cmdParaTab
	call	cmdGetValue		;get address			
	jp	nc,cmdAdrErr
	ex	de,hl			;hl=address
	call	cmdGetValue		;get length			
	jp	nc,cmdAdrErr
	ld	c,e
	ld	b,d			;bc=length
	call	cmdGetValue		;get data			
	jp	nc,cmdDataErr
	ld	a,d
	or	a			;if (data > 255)
	jp	nz,cmdRangeErr		;	output Error
	ld	a,(iy+0)
	or	a			;if (data still available)
	jp	nz,cmdParaErr		;	output Error
	ld	(hl),e			;execute Poke
	dec	bc
	ld	e,l
	ld	d,h
	inc	de
	ldir
	ret
descriptFill:
	defb	"Fill Memory <Startaddress>, <Length>, <Data>", AsciiNUL

cmdDump:
	ld	iy,cmdParaTab
	call	cmdGetValue		;de = address			
	jp	nc,cmdAdrErr
	ex	de,hl
	call	cmdGetValue		;get length			
	jp	nc,cmdAdrErr
	ex	de,hl
	ld	c,l
	ld	b,h			;bc=length
	ld	a,(iy+0)
	or	a			;if (data still available)
	jp	nz,cmdParaErr		;	output Error

	ld	hl,prtBuffer
dumpLineLoop:
	ld	a,b
	or	c			;BC = number of values still to display
	ret	z

	ld	(hl),'0'
	inc	hl
	ld	(hl),'x'
	inc	hl
	call	hex2buffer16
	ld	(hl),':'
	inc	hl
	ld	(hl),' '
	inc	hl
	call	prtBuffer2uart

	push	de
	ld	a,(dumpDisplayWidth)	;A = line value counter
dumpHexLoop:
	ex	af,af'
	ld	a,b
	or	c			;BC = number of values still to display
	jr	z,dumpQuitHexLoop	;if line is not complete output the rest of values as chars
	ld	a,(de)
	call	hex2buffer8
	ld	(hl),' '
	inc	hl			;HL = pointer to output buffer
	inc	de			;DE = pointer to value
	dec	bc
	ex	af,af'
	dec	a
	jr	nz,dumpHexLoop		;repeat until hex output of line is complete
	call	prtBuffer2uart		
	pop	de			;restore pointer to first value in the line

	ld	a,(dumpDisplayWidth)	;A = line value counter
dumpCharLoop:
	ex	af,af'
	call	dumpPrintChar
	ex	af,af'
	dec	a
	jr	nz,dumpCharLoop		;repeat until char output of line is complete
	ld	(hl),AsciiLF
	inc	hl
	ld	(hl),AsciiCR
	inc	hl
	call	prtBuffer2uart
	jr	dumpLineLoop

dumpQuitHexLoop:
	call	prtBuffer2uart
	pop	de
	ex	af,af'
	ld	b,a
	ld	a,(dumpDisplayWidth)
	sub	b
	ret	z
	ld	b,a
dumpCharLoop1:
	call	dumpPrintChar
	djnz	dumpCharLoop1

	ld	(hl),AsciiLF
	inc	hl
	ld	(hl),AsciiCR
	inc	hl
;	jp	prtBuffer2uart

prtBuffer2uart:
	ld	(hl),AsciiNul
	ld	hl,prtBuffer
	call	uartSendString
	jp	uartWaitTxBufferEmpty

dumpPrintChar:
	ld	a,(de)
	cp	'!'
	jr	c,dumpCharReplace
	cp	&7f
	jr	c,dumpCharOk
dumpCharReplace:
	ld	a,'.'
dumpCharOk:
	ld	(hl),a			;output char, if it is printable else output '.' as replacement
	inc	hl
	inc	de
	ret
descriptDump:
	defb	"Dump Data from Memory <startaddress>, <length>", AsciiNUL

cmdDisass:
	ld	iy,cmdParaTab
	call	cmdGetValue		;de = address, a=type			
	jp	nc,cmdAdrErr
	ex	de,hl
	call	cmdGetValue		;get length
	ex	de,hl
	jr	nz,daLengthAvail
	ld	bc,1
	jr	cmdDisAssStart
daLengthAvail:			
	jp	nc,cmdLengthErr
	ld	c,l
	ld	b,h			;bc=length
	ld	a,(iy+0)
	or	a			;if (data still available)
	jp	nz,cmdParaErr		;	output Error
cmdDisAssStart:
	ld	iy,daPrefix
cmdDisAssLoop:
	push	bc
	push	de
	ld	hl,prtBuffer
	call	disAssemble		;Disassemble at DE, returns end of disassembly string in DE'
;	ld	a,AsciiLF
;	call	daChar2PrtBuffer
;	ld	a,AsciiCR
;	call	daChar2PrtBuffer
;	ld	a,AsciiNUL
;	call	daChar2PrtBuffer
	
;	ld	hl,prtBuffer
;	call	uartSendString
;	call	uartWaitTxBufferEmpty
	pop	de

	ld	a,d
	call	uartSendHex
	call	uartManageTxBuffer
	ld	a,e
	call	uartSendHex
	ld	a,' '
	call	uartSendChar
	ld	c,4
cdByteLoop:
	ld	a,(de)
	inc	de
	call	uartSendHex
	ld	a,' '
	call	uartSendChar
	dec	c
	djnz	cdByteLoop
		
	ld	a,c
	add	a,a
	jr	z,cdNoBlank
	add	a,c
	ld	b,a
	ld	a,' '
cdBlankLoop:
	call	uartSendChar
	djnz	cdBlankLoop		
cdNoBlank:
	ld	hl,prtBuffer
cdStringLoop:
	ld	a,(hl)
	or	a
	jr	z,cdQuitStringLoop
	call	uartSendChar
	inc	hl
	jr	cdStringLoop
cdQuitStringLoop:
	ld	a,AsciiLF
	call	uartSendChar
	ld	a,AsciiCR
	call	uartSendChar
	call	uartWaitTxBufferEmpty	
	pop	bc
	dec	bc
	ld	a,c
	or	b
	jr	nz,cmdDisAssLoop

	ret
descriptDisass:
	defb	"Disassemble from <Startaddress>, <Length>", AsciiNUL

cmdBank:
	ret
descriptBank:
	defb	"Set Bank Command", AsciiNUL

cmdHex:
	ret
descriptHex:
	defb	"Hex Command", AsciiNUL

;----------------------------------------------------------------------------------------

cmdGetValue:
	ld	a,(iy+0)
	or	a
	ret	z			;C-Flag cleared, Z-Flag set -> no Data available
	and	FLG_PN_MASK
	cp	FLG_PN_PT
	jr	z,cgvTypeMismatch
cgvCont:
	ld	a,(iy+0)
	ld	e,(iy+1)
	ld	d,(iy+2)
	inc	iy
	inc	iy
	inc	iy
	or	a
	scf
	ret				;C-Flag set -> return value in DE
cmdGetPointer:
	ld	a,(iy+0)
	or	a
	ret	z			;C-Flag cleared, Z-Flag set -> no Data available
	and	FLG_PN_MASK
	cp	FLG_PN_PT
	jr	z,cgvCont
cgvTypeMismatch:
	xor	a
	dec	a
	ret				;C-Flag cleared, Z-Flag cleared -> wrong data type

cmdAdrErr:
	ld	hl,txtAdrErr
	call	uartSendString
	jp	uartWaitTxBufferEmpty
cmdLengthErr:
	ld	hl,txtLengthErr
	call	uartSendString
	jp	uartWaitTxBufferEmpty
cmdDataErr:
	ld	hl,txtDataErr
	call	uartSendString
	jp	uartWaitTxBufferEmpty
cmdRangeErr:
	ld	hl,txtRangeErr
	call	uartSendString
	jp	uartWaitTxBufferEmpty
cmdParaErr:
	ld	hl,txtParaErr
	call	uartSendString
	jp	uartWaitTxBufferEmpty

txtMonCmdError:
	defb	"Unknown Command!", AsciiLF, AsciiCR, AsciiNUL
txtAdrErr:
	defb	"Address Error!", AsciiLF, AsciiCR, AsciiNUL
txtLengthErr:
	defb	"Length Error!", AsciiLF, AsciiCR, AsciiNUL
txtDataErr:
	defb	"Data Error!", AsciiLF, AsciiCR, AsciiNUL
txtRangeErr:
	defb	"Data out of range!", AsciiLF, AsciiCR, AsciiNUL
txtParaErr:
	defb	"to many Parameters!", AsciiLF, AsciiCR, AsciiNUL
