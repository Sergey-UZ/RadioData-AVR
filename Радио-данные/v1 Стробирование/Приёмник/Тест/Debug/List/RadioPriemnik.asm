
;CodeVisionAVR C Compiler V3.40 Advanced
;(C) Copyright 1998-2020 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro

;Build configuration    : Debug
;Chip type              : ATtiny2313A
;Program type           : Application
;Clock frequency        : 4,000000 MHz
;Memory model           : Tiny
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 32 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': No
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_TINY_

	#pragma AVRPART ADMIN PART_NAME ATtiny2313A
	#pragma AVRPART MEMORY PROG_FLASH 2048
	#pragma AVRPART MEMORY EEPROM 128
	#pragma AVRPART MEMORY INT_SRAM SIZE 128
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU WDTCR=0x21
	.EQU WDTCSR=0x21
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SREG=0x3F
	.EQU GPIOR0=0x13
	.EQU GPIOR1=0x14
	.EQU GPIOR2=0x15

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x00DF
	.EQU __DSTACK_SIZE=0x0020
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	RCALL __GETW1Z
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	RCALL __GETD1Z
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __GETW2X
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __GETD2X
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

;GPIOR0-GPIOR2 INITIALIZATION VALUES
	.EQU __GPIOR0_INIT=0x00
	.EQU __GPIOR1_INIT=0x00
	.EQU __GPIOR2_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_compa_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_0x3:
	.DB  0x8
_0x2000E:
	.DB  0x4
_0x2000F:
	.DB  0x1

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  _Periud_1ms_S0000000000
	.DW  _0x3*2

	.DW  0x01
	.DW  _InfoBit_S0010002000
	.DW  _0x2000E*2

	.DW  0x01
	.DW  _FlagSinhronizaciya_S0010002000
	.DW  _0x2000F*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,__CLEAR_SRAM_SIZE
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0-GPIOR2 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30
	;__GPIOR1_INIT = __GPIOR0_INIT
	OUT  GPIOR1,R30
	;__GPIOR2_INIT = __GPIOR0_INIT
	OUT  GPIOR2,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0x00

	.DSEG
	.ORG 0x80

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif
;volatile unsigned char msLedG = 0; // Переменная для подсчёта миллисекунд для LE ...
;volatile unsigned char msLedB = 0; // Переменная для подсчёта миллисекунд для LE ...
;interrupt [TIM1_COMPA] void timer1_compa_isr(void);
;void main(void);
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 002A {

	.CSEG
_timer1_compa_isr:
; .FSTART _timer1_compa_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 002B static unsigned char Periud_1ms = 8;

	.DSEG

	.CSEG
; 0000 002C 
; 0000 002D RadioPriem();
	RCALL _RadioPriem
; 0000 002E 
; 0000 002F if (Periud_1ms != 0)
	LDS  R30,_Periud_1ms_S0000000000
	CPI  R30,0
	BREQ _0x4
; 0000 0030 {
; 0000 0031 --Periud_1ms;
	SUBI R30,LOW(1)
	STS  _Periud_1ms_S0000000000,R30
; 0000 0032 // Прошёл периуд 1мс
; 0000 0033 if (Periud_1ms == 0)
	CPI  R30,0
	BRNE _0x5
; 0000 0034 {
; 0000 0035 Periud_1ms = 8;
	LDI  R30,LOW(8)
	STS  _Periud_1ms_S0000000000,R30
; 0000 0036 if (msLedG != 0)
	LDS  R30,_msLedG
	CPI  R30,0
	BREQ _0x6
; 0000 0037 --msLedG;
	LDS  R30,_msLedG
	SUBI R30,LOW(1)
	STS  _msLedG,R30
; 0000 0038 if (msLedB != 0)
_0x6:
	LDS  R30,_msLedB
	CPI  R30,0
	BREQ _0x7
; 0000 0039 --msLedB;
	LDS  R30,_msLedB
	SUBI R30,LOW(1)
	STS  _msLedB,R30
; 0000 003A }
_0x7:
; 0000 003B }
_0x5:
; 0000 003C }
_0x4:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;void main(void)
; 0000 0040 {
_main:
; .FSTART _main
; 0000 0041 // Пользовательский пакет данных содержащий принятые по радио-каналу данные
; 0000 0042 char RadioPaketData[RADIO_PAKET_DATA_BAYT_COUNT];
; 0000 0043 char FlagOwerflow; // Пользовательский флаг потери предыдущего пакета
; 0000 0044 // Crystal Oscillator division factor: 1
; 0000 0045 #pragma optsize-
; 0000 0046 CLKPR=(1<<CLKPCE);
	SBIW R28,5
;	RadioPaketData -> Y+0
;	FlagOwerflow -> R17
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 0047 CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 0048 #ifdef _OPTIMIZE_SIZE_
; 0000 0049 #pragma optsize+
; 0000 004A #endif
; 0000 004B 
; 0000 004C // Input/Output Ports initialization
; 0000 004D // Port A initialization
; 0000 004E // Function: Bit2=In Bit1=In Bit0=In
; 0000 004F DDRA=(0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	OUT  0x1A,R30
; 0000 0050 // State: Bit2=T Bit1=T Bit0=T
; 0000 0051 PORTA=(0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 0052 
; 0000 0053 // Port B initialization
; 0000 0054 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=Out Bit1=In Bit0=In
; 0000 0055 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (1<<DDB3) | (1<<DDB2) | (0< ...
	LDI  R30,LOW(12)
	OUT  0x17,R30
; 0000 0056 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=0 Bit2=0 Bit1=T Bit0=T
; 0000 0057 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<< ...
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0058 
; 0000 0059 // Port D initialization
; 0000 005A // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 005B DDRD=(0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0< ...
	OUT  0x11,R30
; 0000 005C // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 005D PORTD=(0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<< ...
	OUT  0x12,R30
; 0000 005E 
; 0000 005F // Timer/Counter 0 initialization
; 0000 0060 // Clock source: System Clock
; 0000 0061 // Clock value: Timer 0 Stopped
; 0000 0062 // Mode: Normal top=0xFF
; 0000 0063 // OC0A output: Disconnected
; 0000 0064 // OC0B output: Disconnected
; 0000 0065 TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<< ...
	OUT  0x30,R30
; 0000 0066 TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 0067 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0068 OCR0A=0x00;
	OUT  0x36,R30
; 0000 0069 OCR0B=0x00;
	OUT  0x3C,R30
; 0000 006A 
; 0000 006B // Timer/Counter 1 initialization
; 0000 006C // Clock source: System Clock
; 0000 006D // Clock value: 4000,000 kHz
; 0000 006E // Mode: CTC top=OCR1A
; 0000 006F // OC1A output: Disconnected
; 0000 0070 // OC1B output: Disconnected
; 0000 0071 // Noise Canceler: Off
; 0000 0072 // Input Capture on Falling Edge
; 0000 0073 // Timer Period: 0,125 ms
; 0000 0074 // Timer1 Overflow Interrupt: Off
; 0000 0075 // Input Capture Interrupt: Off
; 0000 0076 // Compare A Match Interrupt: On
; 0000 0077 // Compare B Match Interrupt: Off
; 0000 0078 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<< ...
	OUT  0x2F,R30
; 0000 0079 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (0<<CS12) | (0<<CS11) ...
	LDI  R30,LOW(9)
	OUT  0x2E,R30
; 0000 007A TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 007B TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 007C ICR1H=0x00;
	OUT  0x25,R30
; 0000 007D ICR1L=0x00;
	OUT  0x24,R30
; 0000 007E OCR1AH=0x01;
	LDI  R30,LOW(1)
	OUT  0x2B,R30
; 0000 007F OCR1AL=0xF3;
	LDI  R30,LOW(243)
	OUT  0x2A,R30
; 0000 0080 OCR1BH=0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
; 0000 0081 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0082 
; 0000 0083 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0084 TIMSK=(0<<TOIE1) | (1<<OCIE1A) | (0<<OCIE1B) | (0<<ICIE1) | (0<<OCIE0B) | (0<<TO ...
	LDI  R30,LOW(64)
	OUT  0x39,R30
; 0000 0085 
; 0000 0086 // External Interrupt(s) initialization
; 0000 0087 // INT0: Off
; 0000 0088 // INT1: Off
; 0000 0089 // Interrupt on any change on pins PCINT0-7: Off
; 0000 008A // Interrupt on any change on pins PCINT8-10: Off
; 0000 008B // Interrupt on any change on pins PCINT11-17: Off
; 0000 008C MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 008D GIMSK=(0<<INT1) | (0<<INT0) | (0<<PCIE0) | (0<<PCIE2) | (0<<PCIE1);
	OUT  0x3B,R30
; 0000 008E 
; 0000 008F // USI initialization
; 0000 0090 // Mode: Disabled
; 0000 0091 // Clock source: Register & Counter=no clk.
; 0000 0092 // USI Counter Overflow Interrupt: Off
; 0000 0093 USICR=(0<<USISIE) | (0<<USIOIE) | (0<<USIWM1) | (0<<USIWM0) | (0<<USICS1) | (0<< ...
	OUT  0xD,R30
; 0000 0094 
; 0000 0095 // USART initialization
; 0000 0096 // USART disabled
; 0000 0097 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2)  ...
	OUT  0xA,R30
; 0000 0098 
; 0000 0099 // Analog Comparator initialization
; 0000 009A // Analog Comparator: Off
; 0000 009B // The Analog Comparator's positive input is
; 0000 009C // connected to the AIN0 pin
; 0000 009D // The Analog Comparator's negative input is
; 0000 009E // connected to the AIN1 pin
; 0000 009F ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<AC ...
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00A0 // Digital input buffer on AIN0: On
; 0000 00A1 // Digital input buffer on AIN1: On
; 0000 00A2 DIDR=(0<<AIN0D) | (0<<AIN1D);
	LDI  R30,LOW(0)
	OUT  0x1,R30
; 0000 00A3 
; 0000 00A4 
; 0000 00A5 // Globally enable interrupts
; 0000 00A6 #asm("sei")
	SEI
; 0000 00A7 
; 0000 00A8 while (1)
_0x8:
; 0000 00A9 {
; 0000 00AA // Получение пакета данных, принятые по радио-каналу
; 0000 00AB if (RadioRead(RadioPaketData, &FlagOwerflow) == 1)
	MOV  R30,R28
	ST   -Y,R30
	IN   R26,SPL
	PUSH R17
	RCALL _RadioRead
	POP  R17
	CPI  R30,LOW(0x1)
	BRNE _0xB
; 0000 00AC {
; 0000 00AD if ( (RadioPaketData[0] == 11) &&
; 0000 00AE (RadioPaketData[1] == 22) &&
; 0000 00AF (RadioPaketData[2] == 33) &&
; 0000 00B0 (RadioPaketData[3] == 44) &&
; 0000 00B1 (RadioPaketData[4] == 55))
	LD   R26,Y
	CPI  R26,LOW(0xB)
	BRNE _0xD
	LDD  R26,Y+1
	CPI  R26,LOW(0x16)
	BRNE _0xD
	LDD  R26,Y+2
	CPI  R26,LOW(0x21)
	BRNE _0xD
	LDD  R26,Y+3
	CPI  R26,LOW(0x2C)
	BRNE _0xD
	LDD  R26,Y+4
	CPI  R26,LOW(0x37)
	BREQ _0xE
_0xD:
	RJMP _0xC
_0xE:
; 0000 00B2 {
; 0000 00B3 msLedB = 150;
	LDI  R30,LOW(150)
	STS  _msLedB,R30
; 0000 00B4 PORTB.3 = 1; // Включить LED B
	SBI  0x18,3
; 0000 00B5 }
; 0000 00B6 if (FlagOwerflow == 1)
_0xC:
	CPI  R17,1
	BRNE _0x11
; 0000 00B7 {
; 0000 00B8 msLedG = 150;
	LDI  R30,LOW(150)
	STS  _msLedG,R30
; 0000 00B9 PORTB.2 = 1; // Включить LED G
	SBI  0x18,2
; 0000 00BA }
; 0000 00BB }
_0x11:
; 0000 00BC if (msLedG == 0)
_0xB:
	LDS  R30,_msLedG
	CPI  R30,0
	BRNE _0x14
; 0000 00BD PORTB.2 = 0; // Выключить LED G
	CBI  0x18,2
; 0000 00BE if (msLedB == 0)
_0x14:
	LDS  R30,_msLedB
	CPI  R30,0
	BRNE _0x17
; 0000 00BF PORTB.3 = 0; // Выключить LED B
	CBI  0x18,3
; 0000 00C0 }
_0x17:
	RJMP _0x8
; 0000 00C1 }
_0x1A:
	RJMP _0x1A
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif
;volatile char RadioPaketIn[RADIO_PAKET_DATA_BAYT_COUNT + 1];
;volatile char RadioPaketPrinyat = 0;
;volatile char RadioPaketOverflow = 0;
;char RadioRead (char *Data, char *FlagOwerflow)
; 0001 002F {

	.CSEG
_RadioRead:
; .FSTART _RadioRead
; 0001 0030 unsigned char i; // Индексная переменная
; 0001 0031 
; 0001 0032 if (RadioPaketPrinyat == 1)
	RCALL __SAVELOCR4
	MOV  R16,R26
	LDD  R19,Y+4
;	*Data -> R19
;	*FlagOwerflow -> R16
;	i -> R17
	LDS  R26,_RadioPaketPrinyat
	CPI  R26,LOW(0x1)
	BRNE _0x20003
; 0001 0033 {
; 0001 0034 for (i = 0; i < RADIO_PAKET_DATA_BAYT_COUNT; i++)
	LDI  R17,LOW(0)
_0x20005:
	CPI  R17,5
	BRSH _0x20006
; 0001 0035 Data[i] = RadioPaketIn[i];
	MOV  R30,R17
	ADD  R30,R19
	MOV  R0,R30
	LDI  R26,LOW(_RadioPaketIn)
	ADD  R26,R17
	LD   R30,X
	MOV  R26,R0
	ST   X,R30
	SUBI R17,-1
	RJMP _0x20005
_0x20006:
; 0001 0036 *FlagOwerflow = RadioPaketOverflow;
	LDS  R30,_RadioPaketOverflow
	MOV  R26,R16
	ST   X,R30
; 0001 0037 RadioPaketOverflow = 0;
	LDI  R30,LOW(0)
	STS  _RadioPaketOverflow,R30
; 0001 0038 RadioPaketPrinyat = 0;
	STS  _RadioPaketPrinyat,R30
; 0001 0039 return 1;
	LDI  R30,LOW(1)
	RJMP _0x2000002
; 0001 003A }
; 0001 003B return 0;
_0x20003:
	LDI  R30,LOW(0)
	RJMP _0x2000002
; 0001 003C }
; .FEND
;char CRC_8(char *Data, unsigned char Length_Data)
; 0001 004A {
_CRC_8:
; .FSTART _CRC_8
; 0001 004B char Registr_CRC = 0xFF; // Начальное значение регистра CRC
; 0001 004C unsigned char i; // Индексная переменная
; 0001 004D 
; 0001 004E while (Length_Data--)  //Вычислить CRC для блока данных
	RCALL __SAVELOCR4
	MOV  R19,R26
	LDD  R18,Y+4
;	*Data -> R18
;	Length_Data -> R19
;	Registr_CRC -> R17
;	i -> R16
	LDI  R17,255
_0x20007:
	MOV  R30,R19
	SUBI R19,1
	CPI  R30,0
	BREQ _0x20009
; 0001 004F {
; 0001 0050 Registr_CRC ^= *Data++;
	MOV  R26,R18
	SUBI R18,-1
	LD   R30,X
	EOR  R17,R30
; 0001 0051 for (i = 0; i < 8; i++)
	LDI  R16,LOW(0)
_0x2000B:
	CPI  R16,8
	BRSH _0x2000C
; 0001 0052 {
; 0001 0053 Registr_CRC >>= 1;
	LSR  R17
; 0001 0054 if ( (Registr_CRC & 0b00000001) != 0 )
	SBRS R17,0
	RJMP _0x2000D
; 0001 0055 Registr_CRC ^= 0x31;
	LDI  R30,LOW(49)
	EOR  R17,R30
; 0001 0056 }
_0x2000D:
	SUBI R16,-1
	RJMP _0x2000B
_0x2000C:
; 0001 0057 }
	RJMP _0x20007
_0x20009:
; 0001 0058 return Registr_CRC;
	MOV  R30,R17
_0x2000002:
	RCALL __LOADLOCR4
	ADIW R28,5
	RET
; 0001 0059 }
; .FEND
;void RadioPriem(void)
; 0001 005E {
_RadioPriem:
; .FSTART _RadioPriem
; 0001 005F // Информационный бит и все его состояния
; 0001 0060 static enum InfoBit
; 0001 0061 {
; 0001 0062 _0 = 0, // Бит 0
; 0001 0063 _1 = 1, // Бит 1
; 0001 0064 A_ = 2, // Полубит А
; 0001 0065 Neopredelen = 4, // Неопределённое
; 0001 0066 } InfoBit = Neopredelen;

	.DSEG

	.CSEG
; 0001 0067 // Поиск пакета и все его состояния
; 0001 0068 static enum Paket
; 0001 0069 {
; 0001 006A StartBit = 0, // Стартовый 1-ный бит
; 0001 006B Bit0_7   = 1, // Бит с 1-го по 7-ой (вместе с бит 0 содержит преамбулу)
; 0001 006C Bit8_n   = 2, // Бит с 8-го по n-ый (данные пользователя + CRC)
; 0001 006D } Paket = StartBit;
; 0001 006E /*
; 0001 006F Устанавливается в 1 для синхронизации (в момент первого обнаружения PIN = 1)
; 0001 0070 при поиске 0-го бита пакета
; 0001 0071 */
; 0001 0072 static char FlagSinhronizaciya = 1;

	.DSEG

	.CSEG
; 0001 0073 // Счётчик логических 1 принятого сигнала в каждом полубите информационного бита
; 0001 0074 static unsigned char PoluBitStrobCount = 0; // Кол-во прошедшых стробирующих пер ...
; 0001 0075 static unsigned char PoluBit_A_Count1 = 0; // Кол-во принятых 1-ных сигналов пол ...
; 0001 0076 static unsigned char PoluBit_B_Count1 = 0; // Кол-во принятых 1-ных сигналов пол ...
; 0001 0077 static unsigned char IndexBayt = 0; // Индекс принятого байта
; 0001 0078 static unsigned char IndexPaketBayt = 0; // Индекс принятого пакета байтов
; 0001 0079 char BitPreambulaIn; // Буффер для бита преамбулы
; 0001 007A static char BaytIn; // Буффер для принятого байта
; 0001 007B static char FlagReset = 0; // Сбросс радио-приёма
; 0001 007C 
; 0001 007D // Сбросс радио-приёма
; 0001 007E if (FlagReset == 1)
	ST   -Y,R17
;	BitPreambulaIn -> R17
	LDS  R26,_FlagReset_S0010002000
	CPI  R26,LOW(0x1)
	BRNE _0x20010
; 0001 007F {
; 0001 0080 FlagReset = 0;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x0
; 0001 0081 FlagSinhronizaciya = 1;
	LDI  R30,LOW(1)
	STS  _FlagSinhronizaciya_S0010002000,R30
; 0001 0082 InfoBit = Neopredelen;
	RCALL SUBOPT_0x1
; 0001 0083 Paket = StartBit;
	LDI  R30,LOW(0)
	STS  _Paket_S0010002000,R30
; 0001 0084 PoluBitStrobCount = 0;
	STS  _PoluBitStrobCount_S0010002000,R30
; 0001 0085 PoluBit_A_Count1 = 0;
	RCALL SUBOPT_0x2
; 0001 0086 PoluBit_B_Count1 = 0;
	LDI  R30,LOW(0)
	STS  _PoluBit_B_Count1_S0010002000,R30
; 0001 0087 IndexBayt = 0;
	RCALL SUBOPT_0x3
; 0001 0088 IndexPaketBayt = 0;
	LDI  R30,LOW(0)
	STS  _IndexPaketBayt_S0010002000,R30
; 0001 0089 }
; 0001 008A // Синхронизации
; 0001 008B if (FlagSinhronizaciya == 1)
_0x20010:
	LDS  R26,_FlagSinhronizaciya_S0010002000
	CPI  R26,LOW(0x1)
	BRNE _0x20011
; 0001 008C {
; 0001 008D if (BIT_RAVEN_1(RADIO_SIGNAL_IN_PINX, RADIO_SIGNAL_IN_PIN))
	SBIS 0x10,3
	RJMP _0x20012
; 0001 008E FlagSinhronizaciya = 0;
	LDI  R30,LOW(0)
	STS  _FlagSinhronizaciya_S0010002000,R30
; 0001 008F else
	RJMP _0x20013
_0x20012:
; 0001 0090 return;
	RJMP _0x2000001
; 0001 0091 }
_0x20013:
; 0001 0092 // Поиск информационного бита
; 0001 0093 switch (InfoBit)
_0x20011:
	LDS  R30,_InfoBit_S0010002000
; 0001 0094 {
; 0001 0095 case Neopredelen:
	CPI  R30,LOW(0x4)
	BRNE _0x20017
; 0001 0096 if (BIT_RAVEN_1(RADIO_SIGNAL_IN_PINX, RADIO_SIGNAL_IN_PIN))
	SBIS 0x10,3
	RJMP _0x20018
; 0001 0097 ++PoluBit_A_Count1;
	LDS  R30,_PoluBit_A_Count1_S0010002000
	SUBI R30,-LOW(1)
	STS  _PoluBit_A_Count1_S0010002000,R30
; 0001 0098 else
	RJMP _0x20019
_0x20018:
; 0001 0099 {
; 0001 009A /*
; 0001 009B У принимаемого стартового бита нет спадающего фронта
; 0001 009C Соответственно это был принят сигнал помехи
; 0001 009D */
; 0001 009E if (Paket == StartBit)
	LDS  R30,_Paket_S0010002000
	CPI  R30,0
	BRNE _0x2001A
; 0001 009F {
; 0001 00A0 FlagReset = 1;
	RCALL SUBOPT_0x4
; 0001 00A1 return;
	RJMP _0x2000001
; 0001 00A2 }
; 0001 00A3 }
_0x2001A:
_0x20019:
; 0001 00A4 break;
	RJMP _0x20016
; 0001 00A5 case A_:
_0x20017:
	CPI  R30,LOW(0x2)
	BRNE _0x20016
; 0001 00A6 if (BIT_RAVEN_1(RADIO_SIGNAL_IN_PINX, RADIO_SIGNAL_IN_PIN))
	SBIS 0x10,3
	RJMP _0x2001C
; 0001 00A7 ++PoluBit_B_Count1;
	RCALL SUBOPT_0x5
	SUBI R30,-LOW(1)
	STS  _PoluBit_B_Count1_S0010002000,R30
; 0001 00A8 break;
_0x2001C:
; 0001 00A9 }
_0x20016:
; 0001 00AA ++PoluBitStrobCount;
	LDS  R30,_PoluBitStrobCount_S0010002000
	SUBI R30,-LOW(1)
	STS  _PoluBitStrobCount_S0010002000,R30
; 0001 00AB // Полубит из входного сигнала найден
; 0001 00AC if (PoluBitStrobCount == 8)
	LDS  R26,_PoluBitStrobCount_S0010002000
	CPI  R26,LOW(0x8)
	BRNE _0x2001D
; 0001 00AD {
; 0001 00AE PoluBitStrobCount = 0;
	LDI  R30,LOW(0)
	STS  _PoluBitStrobCount_S0010002000,R30
; 0001 00AF switch (InfoBit)
	LDS  R30,_InfoBit_S0010002000
; 0001 00B0 {
; 0001 00B1 case Neopredelen:
	CPI  R30,LOW(0x4)
	BRNE _0x20021
; 0001 00B2 // Стартовый бит принят
; 0001 00B3 if (Paket == StartBit)
	LDS  R30,_Paket_S0010002000
	CPI  R30,0
	BRNE _0x20022
; 0001 00B4 {
; 0001 00B5 Paket = Bit0_7;
	LDI  R30,LOW(1)
	STS  _Paket_S0010002000,R30
; 0001 00B6 PoluBit_A_Count1 = 0;
	RCALL SUBOPT_0x2
; 0001 00B7 return;
	RJMP _0x2000001
; 0001 00B8 }
; 0001 00B9 InfoBit = A_;
_0x20022:
	LDI  R30,LOW(2)
	STS  _InfoBit_S0010002000,R30
; 0001 00BA return;
	RJMP _0x2000001
; 0001 00BB case A_:
_0x20021:
	CPI  R30,LOW(0x2)
	BRNE _0x20020
; 0001 00BC if (PoluBit_A_Count1 > PoluBit_B_Count1)
	RCALL SUBOPT_0x6
	CP   R30,R26
	BRSH _0x20024
; 0001 00BD InfoBit = _1;
	LDI  R30,LOW(1)
	STS  _InfoBit_S0010002000,R30
; 0001 00BE if (PoluBit_A_Count1 < PoluBit_B_Count1)
_0x20024:
	RCALL SUBOPT_0x6
	CP   R26,R30
	BRSH _0x20025
; 0001 00BF InfoBit = _0;
	LDI  R30,LOW(0)
	STS  _InfoBit_S0010002000,R30
; 0001 00C0 // Перезагрузка радио-приёма
; 0001 00C1 if (PoluBit_A_Count1 == PoluBit_B_Count1)
_0x20025:
	RCALL SUBOPT_0x6
	CP   R30,R26
	BRNE _0x20026
; 0001 00C2 {
; 0001 00C3 FlagReset = 1;
	RCALL SUBOPT_0x4
; 0001 00C4 return;
	RJMP _0x2000001
; 0001 00C5 }
; 0001 00C6 PoluBit_A_Count1 = 0;
_0x20026:
	RCALL SUBOPT_0x2
; 0001 00C7 PoluBit_B_Count1 = 0;
	LDI  R30,LOW(0)
	STS  _PoluBit_B_Count1_S0010002000,R30
; 0001 00C8 break;
; 0001 00C9 }
_0x20020:
; 0001 00CA }
; 0001 00CB switch (Paket)
_0x2001D:
	LDS  R30,_Paket_S0010002000
; 0001 00CC {
; 0001 00CD //Поиск всех битов преамбулы
; 0001 00CE case Bit0_7:
	CPI  R30,LOW(0x1)
	BRNE _0x2002A
; 0001 00CF switch (InfoBit)
	LDS  R30,_InfoBit_S0010002000
; 0001 00D0 {
; 0001 00D1 case _0: case _1:
	CPI  R30,0
	BREQ _0x2002F
	CPI  R30,LOW(0x1)
	BRNE _0x2002D
_0x2002F:
; 0001 00D2 /*
; 0001 00D3 Сравнение принятых бит с битами преамбулы
; 0001 00D4 Если обнаружено несовпадение тогда перезагрузка радио-приёма
; 0001 00D5 */
; 0001 00D6 if (BIT_RAVEN_0(PREAMBULA, IndexBayt)) // n-бит преамбулы равен 0
	RCALL SUBOPT_0x7
	LDI  R26,LOW(1)
	RCALL __LSLB12
	ANDI R30,LOW(0x55)
	BRNE _0x20031
; 0001 00D7 BitPreambulaIn = 0;
	LDI  R17,LOW(0)
; 0001 00D8 else // n-бит преамбулы равен 1
	RJMP _0x20032
_0x20031:
; 0001 00D9 BitPreambulaIn = 1;
	LDI  R17,LOW(1)
; 0001 00DA if (InfoBit == BitPreambulaIn)
_0x20032:
	LDS  R26,_InfoBit_S0010002000
	CP   R17,R26
	BRNE _0x20033
; 0001 00DB ++IndexBayt;
	RCALL SUBOPT_0x8
; 0001 00DC else // Перезагрузка радио-приёма
	RJMP _0x20034
_0x20033:
; 0001 00DD {
; 0001 00DE FlagReset = 1;
	RCALL SUBOPT_0x4
; 0001 00DF return;
	RJMP _0x2000001
; 0001 00E0 }
_0x20034:
; 0001 00E1 InfoBit = Neopredelen;
	RCALL SUBOPT_0x1
; 0001 00E2 // Преамбула найдена
; 0001 00E3 if (IndexBayt == 8)
	LDS  R26,_IndexBayt_S0010002000
	CPI  R26,LOW(0x8)
	BRNE _0x20035
; 0001 00E4 {
; 0001 00E5 IndexBayt = 0;
	RCALL SUBOPT_0x3
; 0001 00E6 Paket = Bit8_n;
	LDI  R30,LOW(2)
	STS  _Paket_S0010002000,R30
; 0001 00E7 }
; 0001 00E8 }
_0x20035:
_0x2002D:
; 0001 00E9 break;
	RJMP _0x20029
; 0001 00EA /*
; 0001 00EB Поиск всех остальных информационных битов пакета
; 0001 00EC Приём пользовательских данных
; 0001 00ED */
; 0001 00EE case Bit8_n:
_0x2002A:
	CPI  R30,LOW(0x2)
	BREQ PC+2
	RJMP _0x20029
; 0001 00EF switch (InfoBit)
	LDS  R30,_InfoBit_S0010002000
; 0001 00F0 {
; 0001 00F1 case _0: case _1:
	CPI  R30,0
	BREQ _0x2003B
	CPI  R30,LOW(0x1)
	BREQ PC+2
	RJMP _0x20039
_0x2003B:
; 0001 00F2 // Сохранить входной бит в буффере
; 0001 00F3 if (InfoBit == 1)
	LDS  R26,_InfoBit_S0010002000
	CPI  R26,LOW(0x1)
	BRNE _0x2003D
; 0001 00F4 BIT_1(BaytIn,IndexBayt);
	RCALL SUBOPT_0x7
	LDI  R26,LOW(1)
	RCALL __LSLB12
	LDS  R26,_BaytIn_S0010002000
	OR   R30,R26
	RJMP _0x20044
; 0001 00F5 else
_0x2003D:
; 0001 00F6 BIT_0(BaytIn,IndexBayt);
	RCALL SUBOPT_0x7
	LDI  R26,LOW(1)
	RCALL __LSLB12
	COM  R30
	LDS  R26,_BaytIn_S0010002000
	AND  R30,R26
_0x20044:
	STS  _BaytIn_S0010002000,R30
; 0001 00F7 ++IndexBayt;
	RCALL SUBOPT_0x8
; 0001 00F8 InfoBit = Neopredelen;
	RCALL SUBOPT_0x1
; 0001 00F9 // Принят ещё 1 байт
; 0001 00FA if (IndexBayt == 8)
	LDS  R26,_IndexBayt_S0010002000
	CPI  R26,LOW(0x8)
	BRNE _0x2003F
; 0001 00FB {
; 0001 00FC IndexBayt = 0;
	RCALL SUBOPT_0x3
; 0001 00FD // Предыдущий пакет потерян
; 0001 00FE if (RadioPaketPrinyat == 1)
	LDS  R26,_RadioPaketPrinyat
	CPI  R26,LOW(0x1)
	BRNE _0x20040
; 0001 00FF {
; 0001 0100 RadioPaketOverflow = 1;
	LDI  R30,LOW(1)
	STS  _RadioPaketOverflow,R30
; 0001 0101 }
; 0001 0102 // Принят пользовательский байт
; 0001 0103 if (IndexPaketBayt < RADIO_PAKET_DATA_BAYT_COUNT + 1)
_0x20040:
	LDS  R26,_IndexPaketBayt_S0010002000
	CPI  R26,LOW(0x6)
	BRSH _0x20041
; 0001 0104 {
; 0001 0105 RadioPaketIn[IndexPaketBayt] = BaytIn; // Сохранить принятый байт в пакете
	LDS  R30,_IndexPaketBayt_S0010002000
	SUBI R30,-LOW(_RadioPaketIn)
	LDS  R26,_BaytIn_S0010002000
	STD  Z+0,R26
; 0001 0106 ++IndexPaketBayt;
	LDS  R30,_IndexPaketBayt_S0010002000
	SUBI R30,-LOW(1)
	STS  _IndexPaketBayt_S0010002000,R30
; 0001 0107 }
; 0001 0108 // Приём всего пакета данных завершён
; 0001 0109 if (IndexPaketBayt == (RADIO_PAKET_DATA_BAYT_COUNT + 1))
_0x20041:
	LDS  R26,_IndexPaketBayt_S0010002000
	CPI  R26,LOW(0x6)
	BRNE _0x20042
; 0001 010A {
; 0001 010B // Проверка целостности пользовательских данных принятого пакета
; 0001 010C if (RadioPaketIn[RADIO_PAKET_DATA_BAYT_COUNT] == CRC_8(RadioPaketIn, RADIO_PAKET ...
	LDI  R30,LOW(_RadioPaketIn)
	ST   -Y,R30
	LDI  R26,LOW(5)
	RCALL _CRC_8
	__GETB2MN _RadioPaketIn,5
	CP   R30,R26
	BRNE _0x20043
; 0001 010D RadioPaketPrinyat = 1; // Данные в целости
	LDI  R30,LOW(1)
	STS  _RadioPaketPrinyat,R30
; 0001 010E // Начать поиск нового пакета
; 0001 010F FlagReset = 1;
_0x20043:
	RCALL SUBOPT_0x4
; 0001 0110 }
; 0001 0111 }
_0x20042:
; 0001 0112 }
_0x2003F:
_0x20039:
; 0001 0113 }
_0x20029:
; 0001 0114 }
_0x2000001:
	LD   R17,Y+
	RET
; .FEND

	.DSEG
_msLedG:
	.BYTE 0x1
_msLedB:
	.BYTE 0x1
_Periud_1ms_S0000000000:
	.BYTE 0x1
_RadioPaketIn:
	.BYTE 0x6
_RadioPaketPrinyat:
	.BYTE 0x1
_RadioPaketOverflow:
	.BYTE 0x1
_InfoBit_S0010002000:
	.BYTE 0x1
_Paket_S0010002000:
	.BYTE 0x1
_FlagSinhronizaciya_S0010002000:
	.BYTE 0x1
_PoluBitStrobCount_S0010002000:
	.BYTE 0x1
_PoluBit_A_Count1_S0010002000:
	.BYTE 0x1
_PoluBit_B_Count1_S0010002000:
	.BYTE 0x1
_IndexBayt_S0010002000:
	.BYTE 0x1
_IndexPaketBayt_S0010002000:
	.BYTE 0x1
_BaytIn_S0010002000:
	.BYTE 0x1
_FlagReset_S0010002000:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	STS  _FlagReset_S0010002000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(4)
	STS  _InfoBit_S0010002000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(0)
	STS  _PoluBit_A_Count1_S0010002000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(0)
	STS  _IndexBayt_S0010002000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(1)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDS  R30,_PoluBit_B_Count1_S0010002000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	RCALL SUBOPT_0x5
	LDS  R26,_PoluBit_A_Count1_S0010002000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	LDS  R30,_IndexBayt_S0010002000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	RCALL SUBOPT_0x7
	SUBI R30,-LOW(1)
	STS  _IndexBayt_S0010002000,R30
	RET

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

;END OF CODE MARKER
__END_OF_CODE:
