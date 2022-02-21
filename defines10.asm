; ReCoMox Monitor Defines V1.0

;File		defines10.asm
;Version	V1.0
;Date		2022/02/02
;Content	defines for the ReCoMox Monitor
;-------------------------------------------------------------------------

pDisplCtrl	equ	&eff7	;Display control port
DisplOn		equ	&02
DisplMod	equ	&01

pVideo40Vram	equ	&eafe
pVideo40Vdp	equ	&ebfe
VdpReg		equ	&80
VramW		equ	&40
VramR		equ	&3f

pRamConfig	equ	&fffd	;Ram configuration Port
RamBankEn3	equ	&04
RamBankEn03	equ	&05
RamBankEn13	equ	&06
RamBankEn013	equ	&07
RamBankEn23	equ	&00
RamBankEn023	equ	&01
RamBankEn123	equ	&02
RamBankEn0123	equ	&03
RamBank3Sel0	equ	&18
RamBank3Sel1	equ	&10
RamBank3Sel2	equ	&08
RamBank3Sel3	equ	&00
RamBank3Sel4	equ	&38
RamBank3Sel5	equ	&30
RamBank3Sel6	equ	&28
RamBank3Sel7	equ	&20
RamBankSwap0_3	equ	&C0
RamBankSwap1_3	equ	&80
RamBankSwap2_3	equ	&40
RamBankSwapOff	equ	&00

pRomConfig	equ	&ffff	;Rom configuration Port
RomDisable	equ	&01
RomBankSel00	equ	&00
RomBankSel01	equ	&02
RomBankSel02	equ	&04
RomBankSel03	equ	&06
RomBankSel04	equ	&08
RomBankSel05	equ	&0a
RomBankSel06	equ	&0c
RomBankSel07	equ	&0e
RomBankSel08	equ	&10
RomBankSel09	equ	&12
RomBankSel10	equ	&14
RomBankSel11	equ	&16
RomBankSel12	equ	&18
RomBankSel13	equ	&1a
RomBankSel14	equ	&1c
RomBankSel15	equ	&1e
RomBankSel16	equ	&20
RomBankSel17	equ	&22
RomBankSel18	equ	&24
RomBankSel19	equ	&26
RomBankSel20	equ	&28
RomBankSel21	equ	&2a
RomBankSel22	equ	&2c
RomBankSel23	equ	&2e
RomBankSel24	equ	&30
RomBankSel25	equ	&32
RomBankSel26	equ	&34
RomBankSel27	equ	&36
RomBankSel28	equ	&38
RomBankSel29	equ	&3a
RomBankSel30	equ	&3c
RomBankSel31	equ	&3e
Spare1		equ	&40	;can be configured to RamBankDisable3 if J58 and J69 are populated
Spare2		equ	&80

pIfCmd		equ	&df77	;Interface command port
pIfData		equ	&dff7	;Interface data port

IfCmdNone	equ	%00110000	;do nothing
IfCmdBreak	equ	%10100101	;switch to emulator

IfCmdRdUCSRA	equ	%01000000	;read from USART Control an Status Register A
IfCmdWrUCSRA	equ	%11000000	;write to USART Control an Status Register A
bmIfRXC		equ	%10000000
bmIfTXC		equ	%01000000
bmIfUDRE	equ	%00100000
bmIfFE		equ	%00010000
bmIfDOR		equ	%00001000
bmIfUOE		equ	%00000100
bmIfU2X		equ	%00000010
bmIfMPCM	equ	%00000001

IfCmdRdUCSRB	equ	%01000001	;read from USART Control an Status Register B
IfCmdWrUCSRB	equ	%11000001	;write to USART Control an Status Register B
bmIfRXCIE	equ	%10000000
bmIfTXCIE	equ	%01000000
bmIfUDRIE	equ	%00100000
bmIfUCSZB9	equ	%00000100
bmIfRXB8	equ	%00000010
bmIfTXB8	equ	%00000001

IfCmdRdUCSRC	equ	%01000010	;read from USART Control an Status Register C
IfCmdWrUCSRC	equ	%11000010	;write to USART Control an Status Register C
bmIfUMASYNC	equ	%00000000
bmIfUMSYNC	equ	%01000000
bmIfUMSPI	equ	%11000000
bmIfUPOFF	equ	%00000000
bmIfUPEVEN	equ	%00100000
bmIfUPODD	equ	%00110000
bmIfUSBS	equ	%00001000
bmIfUCSZC5	equ	%00000000
bmIfUCSZC6	equ	%00000010
bmIfUCSZC7	equ	%00000100
bmIfUCSZC8	equ	%00000110
bmIfUCSZC9	equ	%00000110
bmIfUCPOL	equ	%00000001

IfCmdRdUDR	equ	%01000110	;read from USART I/O Data Register
IfCmdWrUDR	equ	%11000110	;write to USART I/O Data Register

IfCmdRdUBRR	equ	%00000100	;read from USART Baud Rate Register (12- Bit)
IfCmdWrUBRR	equ	%10000100	;write to USART Baud Rate Register (12- Bit)
BSEL_1200_20	equ	&0000 + 1042	;   1200Bd @ 20MHz -0,0%
BSEL_2400_20	equ	&0000 + 521	;   2399Bd @ 20MHz	-0,0%
BSEL_4800_20	equ	&0000 + 260	;   4808Bd @ 20MHz	+0,2%
BSEL_9600_20	equ	&0000 + 130	;   9615Bd @ 20MHz	+0,2%
BSEL_19200_20	equ	&0000 +  65	;  19231Bd @ 20MHz	+0,2%
BSEL_38400_20	equ	&8000 +  65	;  38462Bd @ 20MHz	+0,2%
BSEL_57600_20	equ	&8000 +  43	;  58140Bd @ 20MHz	+0,9%
BSEL_115200_20	equ	&8000 +  22	; 113636Bd @ 20MHz	-1,4%

IfCmdRdTCNT	equ	%00010100	;read from Timer/Counter (16- Bit)
IfCmdWrTCNT	equ	%10010100	;write to Timer/Counter (16- Bit)

IfCmdRdOCR	equ	%00011000	;read from Output Compare Register (16- Bit)
IfCmdDWrOCR	equ	%10011000	;write to Output Compare Register (16- Bit)

IfCmdRdTIFR	equ	%01111000	;read from Timer/Counter Interrupt Flag Register
IfCmdWrTIFR	equ	%11111000	;write to Timer/Counter Interrupt Flag Register
bmIfOCF		equ	%00000010	;Output Compare Match Interrupt Flag
bmIfTOV		equ	%00000001	;Overflow Interrupt Flag

IfCmdRdTIMSK	equ	%01100001	;read from Timer/Counter Interrupt Mask Register
IfCmdWrTIMSK	equ	%11100001	;write to Timer/Counter Interrupt Mask Register
bmIfOCIE	equ	%00000010	;Output Compare Match Interrupt Enable
bmIfTOIE	equ	%00000001	;Overflow Interrupt Enable

IfCmdRdTCCRB	equ	%01010001	;read from Timer/Counter Control Register B
IfCmdWrTCCRB	equ	%11010001	;write to Timer/Counter Control Register B
bmIfCsOff	equ	%00000000	;Clock Select no clock
bmIfCs1		equ	%00000001	;Clock Select /1
bmIfCs8		equ	%00000010	;Clock Select /8 
bmIfCs64	equ	%00000011	;Clock Select /64
bmIfCs256	equ	%00000100	;Clock Select /256
bmIfCs1024	equ	%00000101	;Clock Select /1024
bmIfCsMask	equ	%00000111	;Clock Select Mask

IfCmdRdTCCRC	equ	%01010010	;read from Timer/Counter Control Register C
IfCmdWrTCCRC	equ	%11010010	;write to Timer/Counter Control Register C
bmIfFOC		equ	%10000000	;Force Output Compare

USART_RX_vect	equ 	1		;USART Rx Complete
USART_UDRE_vect	equ 	2		;USART Data register Empty
USART_TX_vect	equ 	3		;USART Tx Complete
TIMER_COMP_vect	equ 	5		;Timer/Counter Compare Match
TIMER3_OVF_vect	equ 	6		;Timer/Counter Overflow

AsciiBEL	equ	&07 			;Bell
AsciiBS		equ	&08 			;BackSpace
AsciiLF		equ	&0a			;LineFeed
AsciiCR		equ	&0d			;Carriage Return
AsciiESC	equ	&1b			;ESCape
AsciiDEL	equ	&7f			;Delete
AsciiNUL	equ	&00			;NULL
AsciiEOT	equ	&03			;End Of Text
AsciiHT		equ	&09			;Horizontal Tab
AsciiQuote	equ	&27			;char '

RamBase		equ	&4000

hlTimes100us	equ	&0271	;rst8  	0008  C3 71 02      	jp	hlTimes100us				
displSet10	equ	&01fe	;rst10	0010  C3 FE 01      	jp	displSet10				
displSet5432	equ	&0212	;rst18 	0018  C3 12 02      	jp	displSet5432	

cmdParaTabLength	equ	8
