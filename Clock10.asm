; ReCoMox Monitor Clock V1.0

;File		Clock10.asm
;Version	V1.0
;Date		2022/02/11
;Content	Show Time
;-------------------------------------------------------------------------


descriptClkShow:
	defb	"Show Time", AsciiNUL

cmdClkShow:
	xor	a
	ld	ix,s50
	ld	(ix+dParseState),a
	ld	(ix+dParseNumber),a
	ld	(ix+dParseNumber+1),a
	ld	e,(ix+dSec)
	dec	e
testLoop:
	call	uartManageTxBuffer
	ld	a,(rxBufferCnt)
	or	a
	call	nz,parseCom
	ld	a,(ix+dSec)
	cp	a,e
	jr	z,testLoop
	ld	e,a
	ld	l,(ix+dMin)
	ld 	h,(ix+dHour)
	call	displSet10
	call	displSet5432

	ld	a,(ix+dParseState)
	or	a

	call	z,time2buffer

	jr	testLoop

time2Buffer:
	push	af
	ld	a,(ix+dHour)	;get hour
	call	uartBcd2Buffer
	ld	a,':'
	call	uartSendChar
	ld	a,(ix+dMin)	;get minute
	call	uartBcd2Buffer
	ld	a,':'
	call	uartSendChar
	ld	a,(ix+dSec)	;get sec
	call	uartBcd2Buffer
	ld	a,' '
	call	uartSendChar
	ld	a,(ix+dDay)	;get day
	call	uartBcd2Buffer
	ld	a,'.'
	call	uartSendChar
	ld	a,(ix+dMonth)	;get month
	call	uartBcd2Buffer
	ld	a,'.'
	call	uartSendChar
	ld	a,(ix+dYear+1)	;get year high
	call	uartBcd2Buffer
	ld	a,(ix+dYear)	;get year low
	call	uartBcd2Buffer	
	ld	a,&0d
	call	uartSendChar
	pop	af
	ret

txtBye:
	defb	AsciiLF,AsciiCR,"Bye, Bye...",AsciiLF,AsciiCR,AsciiNul

parseCom:
	ld	a,(ix+dParseState)
	ld	e,a
	or	a
	call	z,uartSendCRLf
	call	uartGetChar
	push	af
	call	uartSendChar
	pop	af
	call	upper
	cp	'Q'
	jr	nz,ts
	ld	hl,txtBye
	call	uartSendString
	call	uartWaitTxBufferEmpty
	inc	sp
	inc	sp
	ret
ts:
	cp	a,'S'
	jr	nz,tm
	ld	e,1
	jr	pcExit
tm:
	cp	a,'M'
	jr	nz,th
	ld	e,2
	jr	pcExit
th:
	cp	a,'H'
	jr	nz,td
	ld	e,3
	jr	pcExit
td:
	cp	a,'D'
	jr	nz,tmonth
	ld	e,4
	jr	pcExit
tmonth:
	cp	a,'O'
	jr	nz,ty
	ld	e,5
	jr	pcExit
ty:
	cp	a,'Y'
	jr	nz,tcr
	ld	e,6
	jr	pcExit
tcr:
	cp	a,&0d
	jr	nz,tdigit
	dec	e
	ld	a,5
	cp	a,e
	jr	c,noCmd
	inc	e
	ld	hl,s50
	ld	d,0
	add	hl,de
	ld	a,(ix+dParseNumber)
	ld	(hl),a
	ld	a,dSec			;in case of sec
	cp	a,e
	jr	nz,noSec
	dec	hl
	ld	(hl),50			;reset s50 too
	jr	noCmd
noSec:
	ld	a,dYear			;in case of year
	cp	a,e
	jr	nz,noCmd
	inc	hl
	ld	a,(ix+dParseNumber+1)	;set Year high byte too
	ld	(hl),a
noCmd:
	call	uartSendCrLf
	xor	a
	ld	e,a
	ld	(ix+dParseNumber),a
	ld	(ix+dParseNumber+1),a
	jr	pcExit
tdigit:
	cp	a,'0'
	jr	c,noDigit
	cp	a,'9'+1
	jr	nc,noDigit
	sub	a,'0'
	ld	hl,parseNumber
	rld
	inc	hl
	rld
	jr	pcExit
noDigit:
	ld	e,16
pcExit:
	ld	(ix+dParseState),e
	ret

;--------------------------------------------------------------------

showAnimation:
	ld	iy,animation2
	dec	a
	jr	z,loopAnimation
	ld	iy,animation3
	dec	a
	jr	z,loopAnimation
	ld	iy,animation4
	dec	a
	jr	z,loopAnimation
	ld	iy,animation5
	dec	a
	jr	z,loopAnimation
	ld	iy,animation1
startAnimation:
	ld	a,iyl
	ld	ixl,a
	ld	a,iyh
	ld	ixh,a	
loopAnimation:
	ld	a,(rxBufferCnt)
	or	a
	ret	nz

	ld	a,(ix+0)
	or	a
	jr	z,startAnimation
	ld	h,(ix+1)
	ld	l,(ix+2)
	call	displSet5432
	ld	a,(ix+3)
	call	displSet10
	ld	l,(ix+0)
	ld	h,&00
	sll	l
	rl	h
	sll	l
	rl	h
	sll	l
	rl	h
	sll	l
	rl	h
	call	hlTimes100us
	inc	ix
	inc	ix
	inc	ix
	inc	ix
	jr	loopAnimation

animation1:
	defb	80,&80,&00,&00		;128ms	800000
	defb	60,&08,&00,&00		; 96ms	080000
	defb	40,&00,&80,&00		; 64ms	008000
	defb	40,&00,&08,&00		; 64ms	000800
	defb	60,&00,&00,&80		; 96ms	000080
	defb	80,&00,&00,&08		;128ms	000008
	defb	60,&00,&00,&80		; 96ms	000080
	defb	40,&00,&08,&00		; 64ms	000800
	defb	40,&00,&80,&00		; 64ms	008000
	defb	60,&08,&00,&00		; 96ms	080000
	defb	0			;896ms per cycle

animation2:
	defb	20,&A8,&88,&88		;	A88888	4
	defb	20,&8A,&88,&88		;	8A8888	4
	defb	20,&88,&A8,&88		;	88A888	4
	defb	20,&88,&8A,&88		;	888A88	4
	defb	20,&88,&88,&A8		;	8888A8	4
	defb	20,&88,&88,&8A		;	88888A	4
	defb	30,&88,&88,&8E		;	88888E	6
	defb	20,&88,&88,&8b		;	88888b	4
	defb	15,&88,&88,&8d		;	88888d	3
	defb	10,&88,&88,&b8		;	8888b8	2
	defb	10,&88,&88,&d8		;	8888d8	2
	defb	10,&88,&8b,&88		;	888b88	2
	defb	10,&88,&8d,&88		;	888d88	2
	defb	10,&88,&b8,&88		;	88b888	2
	defb	10,&88,&d8,&88		;	88d888	2
	defb	10,&8b,&88,&88		;	8b8888	2
	defb	10,&8d,&88,&88		;	8d8888	2
	defb	10,&b8,&88,&88		;	b88888	2
	defb	15,&d8,&88,&88		;	d88888	3
	defb	20,&38,&88,&88		;	388888	4
	defb	10,&98,&88,&88		;	988888	2
	defb	0

animation3:
	defb	10,&98,&88,&88		;	988888	2
	defb	20,&38,&88,&88		;	388888	4
	defb	15,&d8,&88,&88		;	d88888	3
	defb	10,&b8,&88,&88		;	b88888	2
	defb	10,&8d,&88,&88		;	8d8888	2
	defb	10,&8b,&88,&88		;	8b8888	2
	defb	10,&88,&d8,&88		;	88d888	2
	defb	10,&88,&b8,&88		;	88b888	2
	defb	10,&88,&8d,&88		;	888d88	2
	defb	10,&88,&8b,&88		;	888b88	2
	defb	10,&88,&88,&d8		;	8888d8	2
	defb	10,&88,&88,&b8		;	8888b8	2
	defb	15,&88,&88,&8d		;	88888d	3
	defb	20,&88,&88,&8b		;	88888b	4
	defb	30,&88,&88,&8E		;	88888E	6
	defb	20,&88,&88,&8A		;	88888A	4
	defb	20,&88,&88,&A8		;	8888A8	4
	defb	20,&88,&8A,&88		;	888A88	4
	defb	20,&88,&A8,&88		;	88A888	4
	defb	20,&8A,&88,&88		;	8A8888	4
	defb	20,&A8,&88,&88		;	A88888	4
	defb	0

animation4:
	defb	30,&99,&99,&99		;	999999	3
	defb	40,&33,&33,&33		;	333333	4
	defb	40,&dd,&dd,&dd		;	dddddd	4
	defb	40,&bb,&bb,&bb		;	bbbbbb	4
	defb	20,&66,&66,&66		;	666666	2
	defb	40,&EE,&EE,&EE		;	EEEEEE	4
	defb	30,&AA,&AA,&AA		;	AAAAAA	3
	defb	0

animation5:
	defb	15,&AA,&AA,&AA		;	AAAAAA	3
	defb	20,&EE,&EE,&EE		;	EEEEEE	4
	defb	10,&66,&66,&66		;	666666	2
	defb	20,&bb,&bb,&bb		;	bbbbbb	4
	defb	20,&dd,&dd,&dd		;	dddddd	4
	defb	20,&33,&33,&33		;	333333	4
	defb	15,&99,&99,&99		;	999999	3
	defb	0


