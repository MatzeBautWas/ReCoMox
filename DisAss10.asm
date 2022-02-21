; ReCoMox Monitor Disassembler V1.0

;File		DisAss10.asm
;Version	V1.0
;Date		2022/02/12
;Content	Disassembler for the ReCoMox Monitor
;-------------------------------------------------------------------------

FLG_PN_INV	equ	%00100000
FLG_PN_POS	equ	%01000000
FLG_PN_NEG	equ	%10000000
FLG_PN_BIN	equ	&01
FLG_PN_OCT	equ	&02
FLG_PN_DEC	equ	&03
FLG_PN_HEX	equ	&04
FLG_PN_PT	equ	&05
FLG_PN_MASK	equ	&07

DA_PF_CBbm	equ	%00000001
DA_PF_CB	equ	0
DA_PF_EDbm	equ	%00000010
DA_PF_ED	equ	1
DA_PF_IXbm	equ	%00000100
DA_PF_IX	equ	2
DA_PF_IYbm	equ	%00001000
DA_PF_IY	equ	3

mnemTable:
mnemNOP:	defb	"NO",'P'+&80
mnemEX:		defb	'E','X'+&80
mnemDJNZ:	defb	"DJN",'Z'+&80
mnemJR:		defb	'J','R'+&80
mnemLD:		defb	'L','D'+&80
mnemINC:	defb	"IN",'C'+&80
mnemDEC:	defb	"DE",'C'+&80
mnemRLCA:	defb	"RLC",'A'+&80
mnemRRCA:	defb	"RRC",'A'+&80
mnemRLA:	defb	"RL",'A'+&80, AsciiNul
mnemRRA:	defb	"RR",'A'+&80, AsciiNul
mnemDAA:	defb	"DA",'A'+&80, AsciiNul
mnemCPL:	defb	"CP",'L'+&80, AsciiNul
mnemSCF:	defb	"SC",'F'+&80, AsciiNul
mnemCCF:	defb	"CC",'F'+&80, AsciiNul
mnemHALT:	defb	"HAL",'T'+&80
mnemADD:	defb	"AD",'D'+&80
mnemADC:	defb	"AD",'C'+&80
mnemSUB:	defb	"SU",'B'+&80
mnemSBC:	defb	"SB",'C'+&80
mnemAND:	defb	"AN",'D'+&80
mnemXOR:	defb	"XO",'R'+&80
mnemOR:		defb	'O','R'+&80, AsciiNul
mnemCP:		defb	'C','P'+&80, AsciiNul
mnemRET:	defb	"RE",'T'+&80, AsciiNul
mnemJP:		defb	'J','P'+&80, AsciiNul, AsciiNul
mnemCALL:	defb	"CAL",'L'+&80
mnemPOP:	defb	"PO",'P'+&80
mnemPUSH:	defb	"PUS",'H'+&80
mnemRST:	defb	"RS",'T'+&80
mnemOUT:	defb	"OU",'T'+&80
mnemEXX:	defb	"EX",'X'+&80
mnemIN:		defb	'I','N'+&80
mnemDI:		defb	'D','I'+&80
mnemEI:		defb	'E','I'+&80
mnemRLC:	defb	"RL",'C'+&80
mnemRRC:	defb	"RR",'C'+&80
mnemRL:		defb	'R','L'+&80, AsciiNul
mnemRR:		defb	'R','R'+&80, AsciiNul
mnemSLA:	defb	"SL",'A'+&80
mnemSRA:	defb	"SR",'A'+&80
mnemSLL:	defb	"SL",'L'+&80
mnemSRL:	defb	"SR",'L'+&80
mnemBIT:	defb	"BI",'T'+&80
mnemRES:	defb	"RE",'S'+&80
mnemSET:	defb	"SE",'T'+&80
mnemNEG:	defb	"NE",'G'+&80
mnemRETI:	defb	"RET",'I'+&80
mnemRETN:	defb	"RET",'N'+&80
mnemIM:		defb	'I','M'+&80
mnemRRD:	defb	"RR",'D'+&80
mnemRLD:	defb	"RL",'D'+&80
mnemLDI:	defb	"LD",'I'+&80, AsciiNul
mnemCPI:	defb	"CP",'I'+&80, AsciiNul
mnemINI:	defb	"IN",'I'+&80, AsciiNul
mnemOUTI:	defb	"OUT",'I'+&80
mnemLDD:	defb	"LD",'D'+&80, AsciiNul
mnemCPD:	defb	"CP",'D'+&80, AsciiNul
mnemIND:	defb	"IN",'D'+&80, AsciiNul
mnemOUTD:	defb	"OUT",'D'+&80
mnemLDIR:	defb	"LDI",'R'+&80
mnemCPIR:	defb	"CPI",'R'+&80
mnemINIR:	defb	"INI",'R'+&80
mnemOTIR:	defb	"OTI",'R'+&80
mnemLDDR:	defb	"LDD",'R'+&80
mnemCPDR:	defb	"CPD",'R'+&80
mnemINDR:	defb	"IND",'R'+&80
mnemOTDR:	defb	"OTD",'R'+&80

dNOP 	equ mnemNOP  - mnemTable
dEX 	equ mnemEX   - mnemTable
dDJNZ 	equ mnemDJNZ - mnemTable
dJR 	equ mnemJR   - mnemTable
dLD 	equ mnemLD   - mnemTable
dINC 	equ mnemINC  - mnemTable
dDEC 	equ mnemDEC  - mnemTable
dRLCA 	equ mnemRLCA - mnemTable
dRRCA 	equ mnemRRCA - mnemTable
dRLA 	equ mnemRLA  - mnemTable
dRRA 	equ mnemRRA  - mnemTable
dDAA 	equ mnemDAA  - mnemTable
dCPL 	equ mnemCPL  - mnemTable
dSCF 	equ mnemSCF  - mnemTable
dCCF 	equ mnemCCF  - mnemTable
dHALT 	equ mnemHALT  - mnemTable
dADD 	equ mnemADD  - mnemTable
dADC 	equ mnemADC  - mnemTable
dSUB 	equ mnemSUB  - mnemTable
dSBC 	equ mnemSBC  - mnemTable
dAND 	equ mnemAND  - mnemTable
dXOR 	equ mnemXOR  - mnemTable
dOR 	equ mnemOR   - mnemTable
dCP 	equ mnemCP   - mnemTable
dRET 	equ mnemRET  - mnemTable
dJP 	equ mnemJP   - mnemTable
dCALL 	equ mnemCALL - mnemTable
dPOP 	equ mnemPOP  - mnemTable
dPUSH 	equ mnemPUSH - mnemTable
dRST 	equ mnemRST  - mnemTable
dOUT 	equ mnemOUT  - mnemTable
dEXX 	equ mnemEXX  - mnemTable
dIN 	equ mnemIN   - mnemTable
dDI 	equ mnemDI   - mnemTable
dEI 	equ mnemEI   - mnemTable
dRLC 	equ mnemRLC  - mnemTable
dRRC 	equ mnemRRC  - mnemTable
dRL 	equ mnemRL   - mnemTable
dRR 	equ mnemRR   - mnemTable
dSLA 	equ mnemSLA  - mnemTable
dSRA 	equ mnemSRA  - mnemTable
dSLL 	equ mnemSLL  - mnemTable
dSRL 	equ mnemSRL  - mnemTable
dBIT 	equ mnemBIT  - mnemTable
dRES 	equ mnemRES  - mnemTable
dSET 	equ mnemSET  - mnemTable
dNEG 	equ mnemNEG  - mnemTable
dRETI 	equ mnemRETI - mnemTable
dRETN 	equ mnemRETN - mnemTable
dIM 	equ mnemIM   - mnemTable
dRRD 	equ mnemRRD  - mnemTable
dRLD 	equ mnemRLD  - mnemTable
dLDI	equ mnemLDI  - mnemTable
dCPI 	equ mnemCPI  - mnemTable
dINI 	equ mnemINI  - mnemTable
dOUTI 	equ mnemOUTI - mnemTable
dLDD 	equ mnemLDD  - mnemTable
dCPD 	equ mnemCPD  - mnemTable
dIND 	equ mnemIND  - mnemTable
dOUTD	equ mnemOUTD  - mnemTable
dLDIR	equ mnemLDIR  - mnemTable
dCPIR	equ mnemCPIR - mnemTable
dINIR	equ mnemINIR - mnemTable
dOTIR 	equ mnemOTIR - mnemTable
dLDDR 	equ mnemLDDR - mnemTable
dCPDR	equ mnemCPDR - mnemTable
dINDR	equ mnemINDR - mnemTable
dOTDR	equ mnemOTDR - mnemTable

regPairs:	defb	"BCDEHLAFSPIXIY";
registers:	defb	"BCDEHLFA";
conditions:	defb	"NZZ",AsciiNUL,"NCC",AsciiNUL,"POPEP",AsciiNUL,"M",AsciiNUL;

disAssemble:					;IY=Pointer to Variables(3Bytes), DE=Disassembly Address, HL=Address to String Buffer 
	xor	a
	ld	(iy+dDaPrefix),a
	ld	(iy+dDaCmdLength),a
	push	hl
	push	de
	exx
	pop	hl
	pop	de
	exx

daLoop:
	call	daGetCmdByte
	ld	c,a

	cp	a,&dd				;is it IX prefix?
	jr	nz,daNoIX
	ld	a,(iy+dDaPrefix)
	and	a,DA_PF_IXbm+DA_PF_IYbm		;already any IX or IY prefix detected?
	jr	nz,daSkipIXY			;if yes, treat as NOP
	set	DA_PF_IX,(iy+dDaPrefix)		;DA_PF_IX
	jr	daLoop
daNoIX:
	cp	a,&fd				;is it IY prefix?
	jr	nz,daNoIY
	ld	a,(iy+dDaPrefix)
	and	a,DA_PF_IXbm+DA_PF_IYbm		;already any IX or IY prefix detected?
	jr	nz,daSkipIXY			;if yes, treat as NOP
	set	DA_PF_IY,(iy+dDaPrefix)		;DA_PF_IY
	jr	daLoop
daNoIY:
	cp	a,&eb
	jr	nz,daNoEB
	ld	a,(iy+dDaPrefix)
	and	a,DA_PF_IXbm+DA_PF_IYbm		;already any IX or IY prefix detected?
	set	DA_PF_ED,(iy+dDaPrefix)		;DA_PF_ED
	jr	nz,daSkipIXY			;if yes, treat as NOP	
daNoEB:
	cp	a,&cb
	jr	nz,daNoCB
	set	DA_PF_CB,(iy+dDaPrefix)		;DA_PF_CB
daNoCB:
	call	daDecode
	exx
	ld	a,AsciiNUL
	ld	(de),a
	exx	
	ld	b,(iy+dDaCmdLength)
	ret

daSkipIXY:
	dec	de
	dec	(iy+dDaCmdLength)
	xor	a
	ld	c,a
	jr	daNoEB

daDecode:
	cp	&cb
	jr	z,daDecodeCB

	cp	&ed
	jr	z,daDecodeED

	rlca
	jr	c,daDecode001x
	rlca	
	jr	nc,daDecode0000
	jp	daDecode0001
daDecode001x:
	rlca	
	jp	nc,daDecode0010
	jp	daDecode0011

daDecodeCB:
	ld	a,(iy+dDaPrefix)
	and	DA_PF_IXbm+DA_PF_IYbm
	jr	z,daNoXYDCB
	call	daGetCmdByte
	ld	(iy+dDaDisplacement),a
daNoXYDCB:
	call	daGetCmdByte
	ld	c,a
	rlca
	jr	c,daDecodeCB1x
	rlca	
	jp	nc,daDecodeCB00
	jp	daDecodeCB01
daDecodeCB1x:
	rlca	
	jp	nc,daDecodeCB10
	jp	daDecodeCB11

daDecodeED:
	set	DA_PF_ED,(iy+dDaPrefix)		;DA_PF_ED
	call	daGetCmdByte
	ld	c,a
	rlca
	jr	c,daDecodeED1x
	rlca	
	jp	nc,daDecodeED00
	jp	daDecodeED01
daDecodeED1x:
	rlca	
	jp	nc,daDecodeED10
	jp	daDecodeED11

daDecode0000:
	ld	a,c
	and	%00000111
	jr	nz,no00

;	00=NOP,      08=EX_AF_AF,  10=DJNZ_e,   18=JR_e,      20=JR_NZ_e,   28=JR_Z_e,    30=JR_NC_e,  38=JR_C_e
	ld	a,c
	cp	&18
	jr	nc,daDecodeJRcc
	cp	&10
	jr	z,daDecodeDJNZ
	or	a
	jp	z,daDecodeNop				;NOP
	ld	a,dEX
	call	daInsertMnem				;EX
	ld	a,3
	call	daInsertBlank
	ld	a,3
	call	daInsertReg16				;AF
	ld	a,','
	call	daChar2PrtBuffer			;","
	ld	a,3
	call	daInsertReg16				;AF
	ld	a,AsciiQuote
	call	daChar2PrtBuffer			;"'"
	ret
daDecodeDJNZ:
	ld	a,dDJNZ
	call	daInsertMnem				;DJNZ
	ld	a,1
	call	daInsertBlank
	jr	daDecodeE
daDecodeJRcc:
	ld	a,dJR
	call	daInsertMnem				;JR
	ld	a,3
	call	daInsertBlank
	bit	5,c
	jr	z,daDecodeE
	ld	a,c
	rra
	rra
	rra
	and	%00000011
	call	daInsertCC				;cc
	ld	a,','
	call	daChar2PrtBuffer			;,
daDecodeE:
	call	daGetCmdByte
	ld	l,a
	add	a,a					;sign bit into C-flag
	sbc	a,a					;A=0 if C-Flag=0, else A=&ff
	ld	h,a					;so HL = sign extended A
	add	hl,de
	ld	a,h

	exx
	ex	de,hl
	call	hex2Buffer8				;input -> A=value, HL=pointer to write to
	exx		
	ld	a,l
	exx
	call	hex2Buffer8				;input -> A=value, HL=pointer to write to
	ex	de,hl
	exx						;e
	ret
no00:
	cp	&01
	jr	nz,noLD_ADD_ss

;	01=LD_BC_nn, 09=ADD_HL_BC, 11=LD_DE_nn, 19=ADD_HL_DE, 21=LD_HL_nn,  29=ADD_HL_HL, 31=LD_SP_nn, 39=ADD_HL_SP
	ld	a,c
	and	a,%00001000	
	jr	z,daLD_ss_nn	
	ld	a,dADD
	call	daInsertMnem				;ADD
	ld	a,2
	call	daInsertBlank
	ld	a,2
	call	daInsertReg16				;HL
	ld	a,','
	call	daChar2PrtBuffer			;,
	ld	a,c
	rra
	rra
	rra
	rra
	and	a,%00000011
	cp	a,%00000011
	jr	nz,daNoADD_HL_SP
	inc	a
daNoADD_HL_SP:
	call	daInsertReg16				;ss
	ret
daLD_ss_nn:
	ld	a,dLD
	call	daInsertMnem				;LD
	ld	a,3
	call	daInsertBlank
	ld	a,c
	rra
	rra
	rra
	rra
	and	a,%00000011
	cp	a,%00000011
	jr	nz,daNoLD_SP_nn
	inc	a
daNoLD_SP_nn:
	call	daInsertReg16				;ss
	ld	a,','
	call	daChar2PrtBuffer			;,
	call	daGetCmdByte
	ld	l,a
	call	daGetCmdByte
	exx
	ex	de,hl
	call	hex2Buffer8				;input -> A=value, HL=pointer to write to
	exx		
	ld	a,l
	exx
	call	hex2Buffer8				;input -> A=value, HL=pointer to write to
	ex	de,hl
	exx						;nn
	ret

noLD_ADD_ss:
	cp	&02
	jp	nz,no02

;	02=LD_pBC_A, 0a=LD_A_pBC,  12=LD_pDE_a, 1a=LD_A_pDE,  22=LD_pnn_HL, 2a=LD_HL_pnn, 32=LD_pnn_A, 3a=LD_A_pnn
	ld	a,dLD
	call	daInsertMnem				;LD
	ld	a,3
	call	daInsertBlank
	ld	a,c
	cp	&22
	jr	nc,daDecodeLdNn
	bit	3,c
	jr	z,daPostA
	ld	a,7
	call	daInsertReg8				;A	
	ld	a,','
	call	daChar2PrtBuffer			;,
daPostA:	
	ld	a,'('
	call	daChar2PrtBuffer			;(
	ld	a,0					;BC
	bit	4,c
	jr	z,daDecodeLDpBC
	inc	a					;DE
daDecodeLDpBC:
	call	daInsertReg16	
	ld	a,')'
	call	daChar2PrtBuffer			;)
	bit	3,c
	ret	nz
	ld	a,','
	call	daChar2PrtBuffer			;,
	ld	a,7
	call	daInsertReg8				;A	
	ret
;22=LD_pnn_HL, 2a=LD_HL_pnn, 32=LD_pnn_A, 3a=LD_A_pnn
daDecodeLdNn:
	bit	3,c
	jr	z,daPostHL_A				;if bit 3 is cleared, don't print HL/A first
	bit	4,c
	jr	z,daDecodepHL1				;if bit 4 is set, so print HL first
	ld	a,7					;bit 4 is cleared, so print A first
	call	daInsertReg8				;A
	jr	daDecodepNn
daDecodepHL1:
	ld	a,2
	call	daInsertReg16				;HL	
daDecodepNn:
	ld	a,','
	call	daChar2PrtBuffer			;,
daPostHL_A:	
	ld	a,'('
	call	daChar2PrtBuffer			;(
	call	daGetCmdByte
	ld	l,a
	call	daGetCmdByte
	exx
	ex	de,hl
	call	hex2Buffer8				;input -> A=value, HL=pointer to write to
	exx		
	ld	a,l
	exx
	call	hex2Buffer8				;input -> A=value, HL=pointer to write to
	ex	de,hl
	exx						;nn
	ld	a,')'
	call	daChar2PrtBuffer			;)
	bit	3,c
	ret	nz					;if bit 3 is set, don't print HL/A at last
	ld	a,','
	call	daChar2PrtBuffer			;,
	bit	4,c
	jr	z,daDecodepHL2				;if bit 4 is set, so print HL at last
	ld	a,7					;bit 4 is cleared, so print A at last
	call	daInsertReg8				;A
	ret
daDecodepHL2:
	ld	a,2
	call	daInsertReg16				;HL	
	ret

no02:
	cp	&03
	jr	nz,noINC_DEC_ss

;	03=INC_BC,   0b=DEC_BC,    13=INC_DE,   1b=DEC_DE,    23=INC_HL,    2b=DEC_HL,    33=INC_SP,   3b=DEC_SP
	ld	a,c
	and	a,%00001000	
	ld	a,dINC
	jr	z,daINC_ss	
	ld	a,dDEC
daINC_ss:
	call	daInsertMnem
	ld	a,2
	call	daInsertBlank
	ld	a,c
	rra
	rra
	rra
	rra
	and	a,%00000011
	cp	a,%00000011
	jr	nz,daNoINC_SP
	inc	a
daNoINC_SP:
	call	daInsertReg16
	ret
noINC_DEC_ss:
	cp	&04
	jr	nz,noINC_r

;	04=INC_B,    0c=INC_C,     14=INC_D,    1c=INC_E,     24=INC_H,     2c=INC_L,     34=INC_pHL,  3c=INC_A
	ld	a,dINC
	jr	daContINC_r
noINC_r:
	cp	&05
	jr	nz,noDEC_r

;	05=DEC_B,    0d=DEC_C,     15=DEC_D,    1d=DEC_E,     25=DEC_H,     2d=DEC_L,     35=DEC_pHL,  3d=DEC_A
	ld	a,dDEC
daContINC_r:
	call	daInsertMnem
	ld	a,2
	call	daInsertBlank
	ld	a,c
	rra
	rra
	rra
	and	%00000111
	cp	%00000110
	call	z,daInsertPHL
	call	nz,daInsertReg8
	ret
noDEC_r:
	cp	&06
	jr	nz,noLD_r_n

;	06=LD_B_n,   0e=LD_C_n,    16=LD_D_n,   1e=LD_E_n,    26=LD_H_n,    2e=LD_L_n,    36=LD_pHL,n, 3e=LD_A_n
	ld	a,dLD
	call	daInsertMnem
	ld	a,3
	call	daInsertBlank
	ld	a,c
	rra
	rra
	rra
	and	%00000111
	cp	%00000110
	call	z,daInsertPHL
	call	nz,daInsertReg8
	ld	a,','
	call	daChar2PrtBuffer
	call	daGetCmdByte
	exx
	ex	de,hl
	call	hex2Buffer8				;input -> A=value, HL=pointer to write to
	ex	de,hl
	exx		
	ret

;	07=RLCA,     0f=RRCA,      17=RLA,      1f=RAA,       27=DAA,       2f=CPL,       37=SCF,      3f=CCF
noLD_r_n:
	ld	a,c
	rra
	rra
	rra
	and	%00000111
	add	a,a
	add	a,a
	ld	b,a
	ld	a,dRLCA
	add	b
	call	daInsertMnem
	ret

;	40..47=LD_B_r,   48..8F=LD_C_r,   50..57=LD_D_r,   58..5f=LD_E_r,   60..67=LD_H_r,   68..6f=LD_L_r,   70..77=LD_pHL_r, 78..7f=LD_A_r,
;	46    =LD_B_pHL, 4E    =LD_C_pHL, 56    =LD_D_pHL, 5e    =LD_E_pHL, 66    =LD_H_pHL, 6e    =LD_L_pHL, 76    =HALT    , 7e    =LD_A_pHL
daDecode0001:
	ld	a,c
	cp	&76
	jr	z,daDecodeHalt
	ld	a,dLD
	call	daInsertMnem
	ld	a,3
	call	daInsertBlank
	ld	a,c
	rra
	rra
	rra
	and	%00000111
	cp	%00000110
	call	z,daInsertPHL
	call	nz,daInsertReg8
	ld	a,','
	call	daChar2PrtBuffer
	ld	a,c
	and	%00000111
	cp	%00000110
	call	z,daInsertPHL
	call	nz,daInsertReg8
	ret
daDecodeHalt:
	ld	a,dHALT
	call	daInsertMnem
	ret

;	80..87=ADD_A_r,   88..8F=ADC_A_r,   90..97=SUB_A_r,   98..9f=SBC_A_r,   a0..a7=AND_A_r,   a8..af=XOR_A_r,   b0..b7=OR_A_r,   b8..bf=CP_A_r,
;	86    =ADD_A_pHL, 8E    =ADC_A_pHL, 96    =SUB_A_pHL, 9e    =SBC_A_pHL, a6    =AND_A_pHL, ae    =XOR_A_pHL, b6    =OR_A_pHL, be    =CP_A_pHL
daDecode0010:
	ld	a,c
	and	%00111000
	rra
	rra
	ld	b,a
	rra
	add	a,b
	add	a,dADD
	call	daInsertMnem
	ld	a,2
	call	daInsertBlank
	ld	a,7
	call	daInsertReg8
	ld	a,','
	call	daChar2PrtBuffer
	ld	a,c
	and	%00000111
	cp	%00000110
	call	z,daInsertPHL
	call	nz,daInsertReg8
	ret

;	%11xxx000=RET_cc
;	%110xx001=POP_qq,    &c9=RET,                   &d9=EXX,                    &e9=JP_HL,                &f9_LD_SP_HL
;	%11xxx010=JP_cc_nn
;	%11000011=JP_nn,     &cb=CB,      &d3=OUT_pn_A, &db=IN_A_pn, &e3=EX_pSP_HL, &eb=EX_DE_HL, &f3=DI,     &fb=EI
;	%11xxx100=CALL_cc_nn
;	%110xx101=PUSH_qq,   &cd=CALL_nn,               &dd=IX,                     &ed=ED,                   &fd=IY
;	%11000110=ADD_A_n,   &ce=ADC_A_n, &d6=SUB_A_n,  &de=SBC_A_n, &e6=AND_A_n,   &ee=XOR_A_n,  &f6=OR_A_n, &fe=CP_A_n
;	%11xxx111=RST_p
daDecode0011:
	bit	0,c
	jp	z,daDecodeRetJpCall
	ld	a,c
	and	a,%11001011
	cp	a,%11000001
	jp	z,daDecodePopPush
	ld	a,c
	and	a,%00000111
	cp	a,%00000111
	jp	z,daDecodeRst

	bit	5,c			;JP_nn, RET, CALL_nn, OUT_pn_A, EXX, IN_A_pn, EX_pSP_HL, JP_HL, EX_HL_DE, DI, LD_SP_HL, EI
	jp	nz,daDecode111xx0x1	;                                             EX_pSP_HL, JP_HL, EX_HL_DE, DI, LD_SP_HL, EI
	bit	4,c			;JP_nn, RET, CALL_nn, OUT_pn_A, EXX, IN_A_pn
	jr	nz,daDecode1101x0x1	;                     OUT_pn_A, EXX, IN_A_pn
	bit	3,c			;JP_nn, RET, CALL_nn
	jr	nz,daDecode11001x01	;       RET, CALL_nn

	ld	a,dJP			;JP_nn		= %11000011
	call	daInsertMnem		;JP
	ld	a,1
	call	daInsertBlank
	call	daInsertNn
	ret
daDecode11001x01:
	bit	2,c			;RET, CALL_nn
	jr	nz,daDecodeCall_nn	;     CALL_nn

	ld	a,dRET			;RET		= %11001001
	call	daInsertMnem		;RET
	ret
daDecodeCall_nn:
	ld	a,dCALL			;CALL_nn	= %11001101
	call	daInsertMnem		;CALL
	ld	a,1
	call	daInsertBlank
	call	daInsertNn		;nn
	ret

daDecode1101x0x1:
	bit	3,c			;OUT_pn_A, EXX, IN_A_pn
	jr	nz,daDecode110110x1	;          EXX, IN_A_pn

	ld	a,dOUT			;OUT_pn_A	= %11010011
	call	daInsertMnem		;OUT
	ld	a,2
	call	daInsertBlank
	ld	a,'('
	call	daChar2PrtBuffer	;(
	call	daInsertN		;n
	ld	a,')'
	call	daChar2PrtBuffer	;)
	call	daInsertKomma		;,
	ld	a,7
	call	daInsertReg8		;A
	ret
daDecode110110x1:
	bit	1,c			;EXX, IN_A_pn
	jr	nz,daDecodeIN_A_pn	;     IN_A_pn

	ld	a,dEXX			;EXX		= %11011001
	call	daInsertMnem		;EXX
	ret
daDecodeIN_A_pn:
	ld	a,dIN			;IN_A_pn	= %11011011
	call	daInsertMnem		;IN
	ld	a,3
	call	daInsertBlank
	ld	a,7
	call	daInsertReg8		;A
	call	daInsertKomma		;,
	ld	a,'('
	call	daChar2PrtBuffer	;(
	call	daInsertN		;n
	ld	a,')'
	call	daChar2PrtBuffer	;)
	ret

daDecode111xx0x1
	bit	4,c			;EX_pSP_HL, JP_HL, EX_DE_HL, DI, LD_SP_HL, EI
	jr	nz,daDecode1111x0x1	;                            DI, LD_SP_HL, EI
	bit	3,c			;EX_pSP_HL, JP_HL, EX_DE_HL
	jr	nz,daDecode111010x1	;           JP_HL, EX_DE_HL

	ld	a,dEX			;EX_pSP_HL	= %11100011
	call	daInsertMnem		;EX
	ld	a,3
	call	daInsertBlank
	ld	a,4
	call	daInsertPReg16		;pSP
	call	daInsertKomma		;,
	ld	a,2
	call	daInsertReg16		;HL
	ret
daDecode111010x1:
	bit	1,c			;JP_HL, EX_DE_HL
	jr	nz,daDecodeEX_DE_HL	;       EX_DE_HL

	ld	a,dJP			;JP_HL		= %11101001
	call	daInsertMnem		;JP
	ld	a,1
	call	daInsertBlank
	ld	a,'('
	call	daChar2PrtBuffer	;(
	ld	a,2
	call	daInsertReg16		;HL
	ld	a,')'
	call	daChar2PrtBuffer	;)
	ret
daDecodeEX_DE_HL:
	ld	a,dEX			;EX		= %11101011
	call	daInsertMnem		;EX
	ld	a,3
	call	daInsertBlank
	ld	a,1
	call	daInsertReg16		;DE
	call	daInsertKomma		;,
	ld	a,'H'
	call	daChar2PrtBuffer	;H
	ld	a,'L'
	call	daChar2PrtBuffer	;L
	ret

daDecode1111x0x1:
	bit	3,c			;DI, LD_SP_HL, EI
	jr	nz,daDecode111110x1	;    LD_SP_HL, EI

	ld	a,dDI			;DI		= %11110011
	call	daInsertMnem		;DI
	ret
daDecode111110x1:
	bit	1,c			;LD_SP_HL, EI
	jr	nz,daDecodeEI

	ld	a,dLD			;LD_SP_HL	= %111110001
	call	daInsertMnem		;LD
	ld	a,3
	call	daInsertBlank
	ld	a,4
	call	daInsertReg16		;SP
	call	daInsertKomma		;,
	ld	a,2
	call	daInsertReg16		;HL
	ret
daDecodeEI:
	ld	a,dEI			;EI		= %11111011
	call	daInsertMnem		;EI
	ret

daDecodePopPush:
	bit	2,c
	ld	a,dPOP
	jr	z,daDecodePop
	ld	a,dPUSH
daDecodePop:
	call	daInsertMnem
	ld	a,2
	call	daInsertBlank
	ld	a,c
	rra
	rra
	rra
	rra
	and	a,%00000011
	call	daInsertReg16
	ret

daDecodeRst:
	ld	a,dRST
	call	daInsertMnem
	ld	a,2
	call	daInsertBlank
	ld	a,c
	and	a,%00111000
	exx
	ex	de,hl
	call	hex2Buffer8
	ex	de,hl
	exx
	ret

daDecodeRetJpCall:
	ld	a,c
	and	a,%00000111
	cp	a,%00000110
	jr	z,daDecodeAdd
	rra
	and	a,%00000011
	add	a,a
	add	a,a
	add	a,dRET			;RET, JP, CALL
	call	daInsertMnem
	ld	a,1
	call	daInsertBlank
	ld	a,c
	rra
	rra
	rra
	and	a,%00000111
	call	daInsertCC
	ld	a,c
	and	a,%00000111
	ret	z
	call	daInsertKomma
	call	daInsertNn		;nn
	ret
daDecodeAdd:
	ld	a,c
	and	%00111000
	rra
	rra
	ld	b,a
	rra
	add	a,b
	add	a,dADD			;ADD, ADC, SUN, SBC, AND, XOR, OR, CP
	call	daInsertMnem
	ld	a,2
	call	daInsertBlank
	ld	a,7
	call	daInsertReg8		;A
	call	daInsertKomma		;,
	call	nz,daInsertN		;n
	ret

;	00..07=RLC_r,   08..0f=op_RRC_r, 10..17=RL_r,   18..1f=RR_r,   20..27=SLA_r,   28..2f=SRA_r,   30..37=SLL_r,   38..3f=SRL_r,
;	06    =RLC_pHL, 0e    =RRC_pHL,  16    =RL_pHL, 1e    =RR_pHL, 26    =SLA_pHL, 2e    =SRA_pHL, 36    =SLL_pHL, 3e    =SRL_pHL
daDecodeCB00:
	ld	a,c
	and	%00111000
	rra
	rra
	ld	b,a
	rra
	add	a,b
	add	a,dRLC
	call	daInsertMnem			;RLC, RRC, RL, RR, SLA, SRA, SLL, SRL
	ld	a,2
	call	daInsertBlank
	jr	daCB00DecodeFinish
daDecodeCB01:
	ld	a,dBIT
	jr	daCBDecodeFinish
daDecodeCB10:
	ld	a,dRES
	jr	daCBDecodeFinish
daDecodeCB11:
	ld	a,dSET
daCBDecodeFinish:
	call	daInsertMnem			;BIT, RES, SET
	ld	a,2
	call	daInsertBlank
	ld	a,c
	rra
	rra
	rra
	and	%00000111
	add	a,'0'
	call	daChar2PrtBuffer		;0, 1, 2, 3, 4, 5, 6, 7
	ld	a,','
	call	daChar2PrtBuffer		;,
daCB00DecodeFinish:
	ld	a,(iy+dDaPrefix)
	and	a,DA_PF_IXbm+DA_PF_IYbm
	jr	nz,daDecodeCBIXY
	ld	a,c
	and	%00000111
	cp	%00000110
	call	z,daInsertPHL			;(HL)
	call	nz,daInsertReg8			;B, C, D, E, H, L, A
	ret
daDecodeCBIXY:
	ld	a,2
	call	daInsertPHL			;(IXY+d)
	ld	a,c
	and	a,%11000000
	cp	a,%01000000
	ret	z				;BIT has no further parameter
	ld	a,c
	and	%00000111
	cp	%00000110
	ret	z				;(IXY+d) has no further parameter
	call	daInsertKomma			;,
	call	daInsertReg8			;B, C, D, E, H, L, A
	ret

;	%01xxx000=IN_f_pC
;	%01xxx001=OUT_pC_f
;	%01xx0010=SBC_HL_ss, %01xx1010=ADC_HL_ss
;	%01xx0011=LD_Pnn_dd, %01xx1011=LD_dd_pnn
;	%01xxx100=NEG
;	%01xxx101=RETN,      &01001101=RETI
;	%01xxx110=IM_n
;	%01000111=LD_I_A,    %01001111=LD_R_A, %01010111=LD_A_I, %01011111=LD_A_R, %01100111=RRD, %01101111=RLD, %0111x111=NOP
daDecodeED01:
	bit	2,c
	jp	nz,daDecodeNegRetnImLd
	bit	1,c
	jr	nz,daDecodeSbsAdcLd
	bit	0,c
	jr	nz,daDecodeOut

	ld	a,dIN
	call	daInsertMnem			;IN
	ld	a,3
	call	daInsertBlank
	ld	a,c
	rra
	rra
	rra
	and	a,%00000111
	cp	6
	jr	z,daInNoF
	call	daInsertReg8			;B, C, D, E, H, L, A
	call	daInsertKomma			;,
daInNoF:
	ld	a,'('
	call	daChar2PrtBuffer		;(
	ld	a,1
	call	daInsertReg8			;C
	ld	a,')'
	call	daChar2PrtBuffer		;)
	ret

daDecodeOut:
	ld	a,dOUT
	call	daInsertMnem			;OUT
	ld	a,2
	call	daInsertBlank
	ld	a,'('
	call	daChar2PrtBuffer		;(
	ld	a,1
	call	daInsertReg8			;C
	ld	a,')'
	call	daChar2PrtBuffer		;)
	call	daInsertKomma			;,
	ld	a,c
	rra
	rra
	rra
	and	a,%00000111
	cp	a,6
	jr	z,daOut0
	call	daInsertReg8			;B, C, D, E, H, L, A
	ret
daOut0:
	ld	a,'0'
	call	daChar2PrtBuffer		;0
	ret

daDecodeSbsAdcLd:
	bit	0,c
	jr	nz,daDecodeLdPnN
	bit	3,c
	jr	nz,daDecodeAdc

	ld	a,dSBC				;SBC
	call	daInsertMnem
	jr	daFinishSbc

daDecodeAdc:
	ld	a,dADC				;ADD
	call	daInsertMnem
daFinishSbc:
	ld	a,2
	call	daInsertBlank
	ld	a,2
	call	daInsertReg16			;HL
	call	daInsertKomma			;,
	ld	a,c
	rra
	rra
	rra
	rra
	and	a,%00000011
	cp	a,3
	ccf
	adc	a,0
	call	daInsertReg16			;BC, DE, HL, SP
	ret

daDecodeLDPnN:
	ld	a,dLD		
	call	daInsertMnem			;LD
	ld	a,3
	call	daInsertBlank

	ld	a,c
	rra
	rra
	rra
	rra
	and	a,%00000011
	cp	a,3
	ccf
	adc	a,0
	ld	b,a
	bit	3,c
	jr	z,daTrailingRegs	
	call	daInsertReg16			;BC, DE, HL, SP
	call	daInsertKomma			;,
daTrailingRegs:
	ld	a,'('
	call	daChar2PrtBuffer		;(
	call	daInsertNn			;nn
	ld	a,')'
	call	daChar2PrtBuffer		;)
	bit	3,c
	ret	nz	
	call	daInsertKomma			;,
	ld	a,b
	call	daInsertReg16			;BC, DE, HL, SP
	ret

daDecodeNegRetnImLd:
	bit	1,c
	jr	nz,daDecodeImLd
	bit	0,c
	jr	nz,daDecodeRetn

	ld	a,dNEG
	call	daInsertMnem			;NEG
	ret

daDecodeRetn:
	ld	a,c
	cp	a,&4d
	jr	z,daDecodeReti	
	ld	a,dRETN
	call	daInsertMnem			;RETN
	ret

daDecodeReti:
	ld	a,dRETI
	call	daInsertMnem			;RETI
	ret

daDecodeImLd:
	bit	0,c
	jr	nz,daDecodeLdRrd
	ld	a,dIM
	call	daInsertMnem			;IM
	ld	a,2
	call	daInsertBlank
	ld	a,c
	rra
	rra
	rra
	and	a,%00000011
	jr	z,daCorIm
	dec	a
daCorIM:
	add	a,'0'
	call	daChar2PrtBuffer		;0, 1, 2		
	ret

daDecodeLdRrd:
	bit	5,c
	jr	nz,daDecodeRrdRld
	ld	a,dLD				;LD
	call	daInsertMnem
	ld	a,3
	call	daInsertBlank
	bit	4,c
	jr	z,daTrailingIR
	ld	a,7
	call	daInsertReg8			;A
	call	daInsertKomma			;,
daTrailingIR:
	ld	a,'I'
	bit	3,c
	jr	z,daInsertI
	ld	a,'R'
daInsertI:
	call	daChar2PrtBuffer		;I, R		
	bit	4,c
	ret	nz
	call	daInsertKomma			;,
	ld	a,7
	call	daInsertReg8			;A
	ret

daDecodeRrdRld:
	bit	4,c
	jr	nz,daDecodeNop
	bit	3,c
	jr	nz,daDecodeRld

	ld	a,dRRD
	call	daInsertMnem			;RRD
	ret

daDecodeRld:
	ld	a,dRLD
	call	daInsertMnem			;RLD
	ret

;	80...9F=NOP
;	A0=LDI,  A1=CPI,  A2=INI,  A3=OUTI, A4=NOP, A5=NOP, A6=NOP, A7=NOP,
;	A8=LDD,  A9=CPD,  AA=IND,  AB=OUTD, AC=NOP, AD=NOP, AE=NOP, AF=NOP,
;	B0=LDIR, B1=CPIR, B2=INIR, B3=OTIR, B4=NOP, B5=NOP, B6=NOP, B7=NOP,
;	B8=LDDR, B9=CPDR, BA=INDR, BB=OTDR, BC=NOP, BD=NOP, BE=NOP, BF=NOP
daDecodeED10:
	ld	a,c
	and	%00100100
	cp	%00100000
	jr	nz,daDecodeNOP
	ld	a,c
	and	%00000011
	ld	b,a
	ld	a,c
	and	%00011000
	rra
	add	b
	add	a,a
	add	a,a
	add	a,dLDI
	call	daInsertMnem
	ret

;	00...3F=NOP
;	C0...FF=NOP
daDecodeED00:
daDecodeED11:
daDecodeNop:
	ld	a,dNOP
	call	daInsertMnem			;NOP
	ret

daChar2PrtBuffer:				;input -> A=value, DE'=pointer to write to
	exx
	ld	(de),a
	inc	de
	exx
	ret

daGetCmdByte:
	ld	a,(de)
	inc	de
	inc	(iy+dDaCmdLength)
	ret

daInsertMnem:
	exx
	ld	l,mnemTable and &ff
	add	a,l
	ld	l,a
	ld	a,mnemTable / &100
	adc	a,0
	ld	h,a
dIMLoop:
	ld	a,(hl)
	bit	7,a
	jr	nz,dIMQuit
	ld	(de),a
	inc	hl
	inc	de	
	jr	dIMLoop
dIMQuit:
	and	a,%01111111
	ld	(de),a
	inc	de
	exx
	ret

daInsertKomma:
	push	af
	ld	a,','
	call	daChar2PrtBuffer
	pop	af
	ret

daInsertBlank:
	exx
	ld	b,a
	ld	a,' '
daInsBlankLoop:
	ld	(de),a
	inc	de
	djnz	daInsBlankLoop
	exx
	ret

daInsertCC:
	push	af
	exx
	ld	hl,conditions
	add	a,a
	ld	c,a
	ld	b,0
	add	hl,bc
	ld	a,(hl)
	ld	(de),a
	inc	de
	inc	hl
	ld	a,(hl)
	or	a
	jr	z,daInsertC
	ld	(de),a
	inc	de
daInsertC:
	exx
	pop	af
	ret

daInsertReg8:
	push	af
	and	%00000111
	push	af
	cp	a,4
	jr	c,daIR8NoHL
	cp	a,6
	jr	nc,daIR8NoHL
	ld	a,(iy+dDaPrefix)	;IXY prefix?
	and	a,DA_PF_IXbm+DA_PF_IYbm
	jr	z,daIR8NoHL
	ld	a,c
	cp	a,&66
	jr	z,daIR8NoHL
	cp	a,&6e
	jr	z,daIR8NoHL
	ld	a,2
	call	daInsertReg16
daIR8NoHL:
	pop	af
	exx
	ld	hl,registers
	ld	c,a
	ld	b,0
	add	hl,bc
	ld	a,(hl)
	ld	(de),a
	inc	de
	exx
	pop	af
	ret

daInsertReg16:
	push	af
	cp	a,2
	jr	nz,daIR16NoIXY
	BIT	2,(iy+dDaPrefix)	;IX prefix?
	jr	z,daIR16NoIX
	ld	a,5
daIR16NoIX:
	BIT	3,(iy+dDaPrefix)	;IY prefix?
	jr	z,daIR16NoIXY
	ld	a,6
daIR16NoIXY:
	exx
	ld	hl,regPairs
	add	a,a
	ld	c,a
	ld	b,0
	add	hl,bc
	ld	a,(hl)
	ld	(de),a
	inc	de
	inc	hl
	ld	a,(hl)
	ld	(de),a
	inc	de
	exx
	pop	af
	ret

daInsertPReg16:
	push	af
	ld	a,'('
	call	daChar2PrtBuffer
	pop	af
	push	af
	call	daInsertReg16
	ld	a,')'
	call	daChar2PrtBuffer
	pop	af
	ret


daInsertPHL:
	push	af
	ld	a,'('
	call	daChar2PrtBuffer
	ld	a,(iy+dDaPrefix)
	and	DA_PF_IXbm+DA_PF_IYbm
	ld	a,2
	call	z,daInsertReg16:
	call	nz,daInsertPIXY
	ld	a,')'
	call	daChar2PrtBuffer
	pop	af
	ret

daInsertN:
	call	daGetCmdByte				;get n
	exx
	ex	de,hl
	call	hex2Buffer8				;input -> A=value, HL=pointer to write to
	ex	de,hl
	exx		
	ret

daInsertNn:
	call	daGetCmdByte				;get low Byte nn
	ld	l,a
	call	daGetCmdByte				;get high Byte nn
	exx
	ex	de,hl
	call	hex2Buffer8				;input -> A=value, HL=pointer to write to
	exx
	ld	a,l
	exx
	call	hex2Buffer8				;input -> A=value, HL=pointer to write to
	ex	de,hl
	exx			
	ret

daInsertPIXY:
	push	af
	push	bc

	ld	a,(iy+dDaCmdLength)
	cp	2
	jr	nz,daNotThird
	ld	a,(de)
	inc	de
	inc	(iy+dDaCmdLength)
	ld	(iy+dDaDisplacement),a
daNotThird:
	ld	a,(iy+dDaPrefix)
	and	DA_PF_IXbm
	ld	a,5
	jr	nz,daSelIX
	ld	a,6
daSelIX:
	call	daInsertReg16
	ld	c,(iy+dDaDisplacement)
	bit	7,c
	ld	a,'+'
	jr	z,daDisPos
	ld	a,c
	neg
	ld	c,a
	ld	a,'-'
daDisPos:
	call	daChar2PrtBuffer			;input -> A=value, DE'=pointer to write to
	ld	a,c
	exx
	ex	de,hl
	call	hex2Buffer8				;input -> A=value, HL=pointer to write to
	ex	de,hl
	exx
	res	2,(iy+dDaPrefix)
	res	3,(iy+dDaPrefix)
	pop	bc
	pop	af
	ret



