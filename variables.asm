; ReCoMox Monitor Variables

;File		variables.asm
;Date		2022/02/02
;Content	Variables for the ReCoMox Monitor
;-------------------------------------------------------------------------


	org	&e000

;timer variables
dS50	equ	0
s50:				;0
	defb	50
dSec	equ	1
sec:				;1
	defb	&00
dMin	equ	2
min:				;2
	defb	&17
dHour	equ	3
hour:				;3
	defb	&00
dDay	equ	4
day:				;4
	defb	&11
dMonth	equ	5
month:				;5
	defb	&02
dYear	equ	6
year:				;6
	defw	&2022

dParseState	equ	8
parseState:			;8
	defb	0
dParseNumber	equ	9
parseNumber:			;9
	defw	0

dDumpDisplayWidth	equ	10
dumpDisplayWidth:
	defb	16

;uart variables
rxBufferPt:			;(rxBuffer+(rxBufferPt)) = next free space in rxBuffer
	defb	0
rxBufferCnt:			;(rxBuffer+(rxBufferPt)-(rxBufferCnt)) = next char in rxBuffer to be readed
	defb	0
rxBuffer:
	defs	64

txBufferPt:			;(txBuffer2+(txBufferPt)) = next char to be transmitted
	defb	0
txBufferCnt:			;(txBuffer2+(txBufferPt)+(txBufferCnt)) = next free space in txBuffer2
	defb	0
txBuffer:
	defs	64

;monitor variables
monBufferCnt:			
	defb	0
monBuffer:
	defs	80

prtBuffer:
	defs	80

;literal parse variables
cmdParaTab:
	defs	cmdParaTabLength*3+1

;disassembler variables	
dDaPrefix	equ	0
daPrefix:
	defb	0
dDaCmdLength	equ	1
daCmdLength:
	defb	0
dDaDisplacement	equ	2
dDaValue16	equ	2
daDisplacement:
daValue16:
	defb	0
dDaValue8	equ	3
daValue8:
	defb	0
