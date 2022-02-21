; ReCoMox Monitor UART V1.0

;File		Uart10.asm
;Version	V1.0
;Date		2022/02/02
;Content	UART Functions for the ReCoMox Monitor
;-------------------------------------------------------------------------

;uartInit
;intUSART_RX
;intUSART_UDRE
;intUSART_TX
;uartManageTxBuffer
;uartWaitTxBufferEmpty
;uartBcd2Buffer
;uartGetChar		a=char, CFlag is set if successfull
;uartSendCrLf
;uartSendChar
;uartSendHex
;uartSendString

uartInit:
	push	af
	push	hl

;	UBRRH = (baud>>8)&0x7f;
;	UBRRL = baud&0xff;
	ld	a,h
	and	&0f
	ld	h,a
	ld	a,IfCmdWrUBRR
	call	ifWordWrite
;	if (baud&0x8000) {UCSRA |= (1<<U2X);} else { UCSRA &= ~(1<<U2X);}
;	UCSRA |= (1<<UDRE);
	ld	a,bmIfUDRE
	pop	hl
	push	hl
	bit	7,h
	jr	z,noU2X
	or	bmIfU2X
noU2X:
	ld	l,a
	ld	a,IfCmdWrUCSRA
	call	ifByteWrite

; 	USARTx0, 8 Data bits, No Parity, 1 Stop bit
;	UCSRC = (uint8_t) (0<<UMSEL0) | (3<<UCSZ0) | (0<<UPM0) | (0<<USBS);
	ld	l,bmIfUMASYNC+bmIfUCSZC8+bmIfUPOFF
	ld	a,IfCmdWrUCSRC				;set 8 Data bits, No Parity, 1 Stop bit
	call	ifByteWrite
    
	xor	a
	ld	(rxBufferPt),a
	ld	(rxBufferCnt),a
	ld	(txBufferPt),a
	ld	(txBufferCnt),a
; 	Enable RXC interrupt
;	UCSRB |= (1<<RXCIE);
	ld	l,bmIfRXCIE				;bmIfUDRIE+bmIfTXCIE
	ld	a,IfCmdWrUCSRB				;set enable RXCIE, disable UDRIE, disable TXCIE
	call	ifByteWrite
    
	pop	hl
	pop	af
	ret

intUSART_RX:
	ld	hl,rxBufferPt				;rxBufferPt, rxBufferCnt, rxBuffer[64]
	ld	a,(hl)					;hl points to rxBufferPt
	ld	c,a
	ld	b,0					;bc = rxBufferPt
	inc	a
	and	&3f					;calculate new value for rxBufferPt
	ld	(hl),a
	inc	hl					;hl points to rxBufferCnt
	inc	(hl)					;increment rxBufferCnt
	inc	hl
	add	hl,bc					;calculate actual bufferPointer
	ld	a,IfCmdRdUDR
	call	ifByteRead				;get received char
	ld	(hl),a					;store char in pointer
	ret

intUSART_UDRE:
	ret
	push	af
	ld	a,(txBufferCnt)
	or	a
	jr	z,iuuNothingToDo

	push	hl
	ld	a,IfCmdRdUCSRA
	call	ifByteRead
	and	bmIfUDRE
	jr	z,iuuUDRnotEmpty

	push	bc
	ld	hl,txBufferPt
	ld	a,(hl)
	inc	(hl)					;inc txBufferPt
	inc	hl
	dec	(hl)					;dec txBufferCnt
	and	&3f
	inc	a					;get txBufferPt+2
	ld	c,a
	ld	b,0
	add	hl,bc					;calculate address of char to be transmitted -> txBuffer2 + txBufferPt (offset of 2 is needed, because hl actually points to txBufferPt)
	ld	l,(hl)
	ld	a,IfCmdWrUDR
	call	ifByteWrite
	pop	bc

iuuNothingToDo:						;disable UDRIE
	ld	a,ifCmdWrUCSRB
	ld	l,bmIfUDRIE xor &ff
	call	ifBitClear
	pop	hl
iuuUDRnotEmpty:		
	pop	af
	ret

uartManageTxBuffer:
	push	af
	ld	a,(txBufferCnt)
	or	a
	jr	z,umbNothingToDo

	push	hl
	ld	a,IfCmdRdUCSRA
	call	ifByteRead
	and	bmIfUDRE
	jr	z,umbUDRnotEmpty

	push	bc
	ld	hl,txBufferPt
	ld	a,(hl)
	inc	(hl)					;inc txBufferPt
	inc	hl
	dec	(hl)					;dec txBufferCnt
	and	&3f
	inc	a					;get txBufferPt+2
	ld	c,a
	ld	b,0
	add	hl,bc					;calculate address of char to be transmitted -> txBuffer2 + txBufferPt (offset of 2 is needed, because hl actually points to txBufferPt)
	ld	l,(hl)
	ld	a,IfCmdWrUDR
	call	ifByteWrite
	pop	bc
umbUDRnotEmpty:
;	ld	a,ifCmdWrUCSRB
;	ld	l,bmIfUDRIE xor &ff
;	call	ifClear
	pop	hl
umbNothingToDo:
	pop	af
	ret

intUSART_TX:
	ret

uartGetChar:						;a=char, CFlag=0 if successfull
	ld	a,(rxBufferCnt)
	or	a
	ret	z

	push	hl
	push	bc
	di
	ld	hl,rxBufferPt
	ld	a,(hl)					;get rxBufferPt
	inc	hl
	ld	c,(hl)					;get rxBufferCnt
	sub	c					;calculate pointer to next char to read
	dec	c
	ld	(hl),c					;dec rxBufferCnt
	inc	hl
	and	&3f
	ld	c,a
	ld	b,0
	add	hl,bc					;calculate actual bufferPointer
	ld	a,(hl)
	ei
	pop	bc
	pop	hl
	scf
	ret

uartSendChar:
	push 	hl
	push	de
	push 	bc
	ld	e,a
	di
	ld	hl,txBufferPt
	ld	b,(hl)					;get txBufferPt
	inc	hl
	ld	a,(hl)					;get txBufferCnt
	cp	&3f					;txBufferCnt>=0x3f?
	ccf
	jr	c,usc2BufferFull
	inc	(hl)					;inc txBufferCnt
	inc	hl
	add	a,b					;calculate pointer to next char to write
	and	&3f
	ld	c,a
	ld	b,0
	add	hl,bc					;calculate actual bufferPointer
	ld	(hl),e
	or	a					;clear C flag
usc2BufferFull:
	ei
	ld	l,bmIfUDRIE
	ld	a,ifCmdWrUCSRB
	call	ifBitSet

	ld	a,e
	pop	bc
	pop	de
	pop	hl
	ret

uartWaitTxBufferEmpty:
	push	hl
	ld	a,(S50)
	sub	10
	jr	nc,toOk
	sub	206
toOk;
	ld	l,a
sendStringWait:
	call	uartManageTxBuffer		;
	ld	a,(txBufferCnt)
	or	a
	ld	a,&00
	jr	z,sendStringDone
	ld	a,(S50)
	cp	l
	jr	z,sendStringTimeout
	jr	sendStringWait
sendStringTimeout:
	ld	a,&ff	
sendStringDone:
	pop	hl
	ret

uartBcd2Buffer:
	push	af
	rrca
	rrca
	rrca
	rrca
	and	&0f
	add	a,'0'
	call	uartSendChar
	pop	af
	push	af
	and	&0f
	add	a,'0'
	call	uartSendChar
	pop	af
	ret

uartSendCrLf:
	push	af
	ld	a,&0a
	call	uartSendChar
	ld	a,&0d
	call	uartSendChar
	pop	af
	ret

uartSendHex:
	push	af
	rrca
	rrca
	rrca
	rrca
	and	&0f
	add	'0'
	cp	'9'+1
	jr	c,ush1
	add	'A'-'9'-1
ush1:
	call	uartSendChar
	pop	af
	push	af
	and	&0f
	add	'0'
	cp	'9'+1
	jr	c,ush2
	add	'A'-'9'-1
ush2:
	call	uartSendChar
	pop	af
	ret

uartSendString:
	push	af
	push	hl
ussLoop:
	ld	a,(hl)
	or	a
	jr	z,ussDone
	call	uartSendChar
	jr	c,ussDone
	inc	hl
	jr	ussLoop
ussDone:
	pop	hl
	pop	af
	ret
