
;CodeVisionAVR C Compiler V3.40 Advanced
;(C) Copyright 1998-2020 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro

;Build configuration    : Debug
;Chip type              : ATmega8A
;Program type           : Application
;Clock frequency        : 4,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': No
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega8A
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

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
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
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
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
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

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP _timer2_comp_isr
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
	RJMP _adc_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_0x2000E:
	.DB  0x4
_0x2000F:
	.DB  0x1

__GLOBAL_INI_TBL:
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

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
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

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0x00

	.DSEG
	.ORG 0x160

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;volatile unsigned char msLedB = 0; // ���������� ��� �������� ����������� ��� LE ...
;volatile unsigned char msLedR = 0; // ���������� ��� �������� ����������� ��� LE ...
;interrupt [TIM2_COMP] void timer2_comp_isr(void)
; 0000 002A {

	.CSEG
_timer2_comp_isr:
; .FSTART _timer2_comp_isr
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 002B if (msLedB != 0)
	LDS  R30,_msLedB
	CPI  R30,0
	BREQ _0x3
; 0000 002C --msLedB;
	LDS  R30,_msLedB
	SUBI R30,LOW(1)
	STS  _msLedB,R30
; 0000 002D if (msLedR != 0)
_0x3:
	LDS  R30,_msLedR
	CPI  R30,0
	BREQ _0x4
; 0000 002E --msLedR;
	LDS  R30,_msLedR
	SUBI R30,LOW(1)
	STS  _msLedR,R30
; 0000 002F }
_0x4:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
; .FEND
;interrupt [ADC_INT] void adc_isr(void)
; 0000 0034 {
_adc_isr:
; .FSTART _adc_isr
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
; 0000 0035 RadioPriem();
	RCALL _RadioPriem
; 0000 0036 }
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
; 0000 003A {
_main:
; .FSTART _main
; 0000 003B // ���������������� ����� ������ ���������� �������� �� �����-������ ������
; 0000 003C char RadioPaketData[RADIO_PAKET_DATA_BAYT_COUNT];
; 0000 003D char FlagOwerflow; // ���������������� ���� ������ ����������� ������
; 0000 003E 
; 0000 003F // Input/Output Ports initialization
; 0000 0040 // Port B initialization
; 0000 0041 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=Out Bit0=In
; 0000 0042 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (1<<DDB2) | (1< ...
	SBIW R28,5
;	RadioPaketData -> Y+0
;	FlagOwerflow -> R17
	LDI  R30,LOW(6)
	OUT  0x17,R30
; 0000 0043 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=0 Bit1=0 Bit0=T
; 0000 0044 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<< ...
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0045 
; 0000 0046 // Port C initialization
; 0000 0047 // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0048 DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0< ...
	OUT  0x14,R30
; 0000 0049 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 004A PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<< ...
	OUT  0x15,R30
; 0000 004B 
; 0000 004C // Port D initialization
; 0000 004D // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 004E DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0< ...
	OUT  0x11,R30
; 0000 004F // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0050 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<< ...
	OUT  0x12,R30
; 0000 0051 
; 0000 0052 // Timer/Counter 0 initialization
; 0000 0053 // Clock source: System Clock
; 0000 0054 // Clock value: Timer 0 Stopped
; 0000 0055 TCCR0=(0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 0056 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0057 
; 0000 0058 // Timer/Counter 1 initialization
; 0000 0059 // Clock source: System Clock
; 0000 005A // Clock value: Timer1 Stopped
; 0000 005B // Mode: Normal top=0xFFFF
; 0000 005C // OC1A output: Disconnected
; 0000 005D // OC1B output: Disconnected
; 0000 005E // Noise Canceler: Off
; 0000 005F // Input Capture on Falling Edge
; 0000 0060 // Timer1 Overflow Interrupt: Off
; 0000 0061 // Input Capture Interrupt: Off
; 0000 0062 // Compare A Match Interrupt: Off
; 0000 0063 // Compare B Match Interrupt: Off
; 0000 0064 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<< ...
	OUT  0x2F,R30
; 0000 0065 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) ...
	OUT  0x2E,R30
; 0000 0066 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0067 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0068 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0069 ICR1L=0x00;
	OUT  0x26,R30
; 0000 006A OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 006B OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 006C OCR1BH=0x00;
	OUT  0x29,R30
; 0000 006D OCR1BL=0x00;
	OUT  0x28,R30
; 0000 006E 
; 0000 006F // Timer/Counter 2 initialization
; 0000 0070 // Clock source: System Clock
; 0000 0071 // Clock value: 125,000 kHz
; 0000 0072 // Mode: CTC top=OCR2A
; 0000 0073 // OC2 output: Disconnected
; 0000 0074 // Timer Period: 1 ms
; 0000 0075 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0076 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (1<<CTC2) | (0<<CS22) | (1<<CS21) |  ...
	LDI  R30,LOW(11)
	OUT  0x25,R30
; 0000 0077 TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 0078 OCR2=0x7C;
	LDI  R30,LOW(124)
	OUT  0x23,R30
; 0000 0079 
; 0000 007A // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 007B TIMSK=(1<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TO ...
	LDI  R30,LOW(128)
	OUT  0x39,R30
; 0000 007C 
; 0000 007D // External Interrupt(s) initialization
; 0000 007E // INT0: Off
; 0000 007F // INT1: Off
; 0000 0080 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 0081 
; 0000 0082 // USART initialization
; 0000 0083 // USART disabled
; 0000 0084 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2)  ...
	OUT  0xA,R30
; 0000 0085 
; 0000 0086 // Analog Comparator initialization
; 0000 0087 // Analog Comparator: Off
; 0000 0088 // The Analog Comparator's positive input is
; 0000 0089 // connected to the AIN0 pin
; 0000 008A // The Analog Comparator's negative input is
; 0000 008B // connected to the AIN1 pin
; 0000 008C ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<AC ...
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 008D 
; 0000 008E // ADC initialization
; 0000 008F // ADC Clock frequency: 125,000 kHz
; 0000 0090 // ADC Voltage Reference: AVCC pin
; 0000 0091 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(96)
	OUT  0x7,R30
; 0000 0092 ADCSRA=(1<<ADEN) | (1<<ADSC) | (1<<ADFR) | (0<<ADIF) | (1<<ADIE) | (1<<ADPS2) |  ...
	LDI  R30,LOW(237)
	OUT  0x6,R30
; 0000 0093 //SFIOR=(0<<ACME);
; 0000 0094 
; 0000 0095 // SPI initialization
; 0000 0096 // SPI disabled
; 0000 0097 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<< ...
	LDI  R30,LOW(0)
	OUT  0xD,R30
; 0000 0098 
; 0000 0099 // TWI initialization
; 0000 009A // TWI disabled
; 0000 009B TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 009C 
; 0000 009D // Globally enable interrupts
; 0000 009E #asm("sei")
	SEI
; 0000 009F 
; 0000 00A0 while (1)
_0x5:
; 0000 00A1 {
; 0000 00A2 // ��������� ������ ������, �������� �� �����-������
; 0000 00A3 if (RadioRead(RadioPaketData, &FlagOwerflow) == 1)
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	IN   R26,SPL
	IN   R27,SPH
	PUSH R17
	RCALL _RadioRead
	POP  R17
	CPI  R30,LOW(0x1)
	BRNE _0x8
; 0000 00A4 {
; 0000 00A5 if ( (RadioPaketData[0] == 11) &&
; 0000 00A6 (RadioPaketData[1] == 22) &&
; 0000 00A7 (RadioPaketData[2] == 33) &&
; 0000 00A8 (RadioPaketData[3] == 44) &&
; 0000 00A9 (RadioPaketData[4] == 55))
	LD   R26,Y
	CPI  R26,LOW(0xB)
	BRNE _0xA
	LDD  R26,Y+1
	CPI  R26,LOW(0x16)
	BRNE _0xA
	LDD  R26,Y+2
	CPI  R26,LOW(0x21)
	BRNE _0xA
	LDD  R26,Y+3
	CPI  R26,LOW(0x2C)
	BRNE _0xA
	LDD  R26,Y+4
	CPI  R26,LOW(0x37)
	BREQ _0xB
_0xA:
	RJMP _0x9
_0xB:
; 0000 00AA {
; 0000 00AB msLedB = 150;
	LDI  R30,LOW(150)
	STS  _msLedB,R30
; 0000 00AC PORTB.2 = 1; // �������� LED B
	SBI  0x18,2
; 0000 00AD }
; 0000 00AE if (FlagOwerflow == 1)
_0x9:
	CPI  R17,1
	BRNE _0xE
; 0000 00AF {
; 0000 00B0 msLedR = 150;
	LDI  R30,LOW(150)
	STS  _msLedR,R30
; 0000 00B1 PORTB.1 = 1; // �������� LED R
	SBI  0x18,1
; 0000 00B2 }
; 0000 00B3 }
_0xE:
; 0000 00B4 if (msLedR == 0)
_0x8:
	LDS  R30,_msLedR
	CPI  R30,0
	BRNE _0x11
; 0000 00B5 PORTB.1 = 0; // ��������� LED R
	CBI  0x18,1
; 0000 00B6 if (msLedB == 0)
_0x11:
	LDS  R30,_msLedB
	CPI  R30,0
	BRNE _0x14
; 0000 00B7 PORTB.2 = 0; // ��������� LED B
	CBI  0x18,2
; 0000 00B8 }
_0x14:
	RJMP _0x5
; 0000 00B9 }
_0x17:
	RJMP _0x17
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;volatile char RadioPaketIn[RADIO_PAKET_DATA_BAYT_COUNT + 1];
;volatile char RadioPaketPrinyat = 0;
;volatile char RadioPaketOverflow = 0;
;char RadioRead (char *Data, char *FlagOwerflow)
; 0001 002C {

	.CSEG
_RadioRead:
; .FSTART _RadioRead
; 0001 002D unsigned char i; // ��������� ����������
; 0001 002E 
; 0001 002F if (RadioPaketPrinyat == 1)
	RCALL __SAVELOCR6
	MOVW R18,R26
	__GETWRS 20,21,6
;	*Data -> R20,R21
;	*FlagOwerflow -> R18,R19
;	i -> R17
	LDS  R26,_RadioPaketPrinyat
	CPI  R26,LOW(0x1)
	BRNE _0x20003
; 0001 0030 {
; 0001 0031 for (i = 0; i < RADIO_PAKET_DATA_BAYT_COUNT; i++)
	LDI  R17,LOW(0)
_0x20005:
	CPI  R17,5
	BRSH _0x20006
; 0001 0032 Data[i] = RadioPaketIn[i];
	MOV  R30,R17
	LDI  R31,0
	ADD  R30,R20
	ADC  R31,R21
	MOVW R26,R30
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_RadioPaketIn)
	SBCI R31,HIGH(-_RadioPaketIn)
	LD   R30,Z
	ST   X,R30
	SUBI R17,-1
	RJMP _0x20005
_0x20006:
; 0001 0033 *FlagOwerflow = RadioPaketOverflow;
	LDS  R30,_RadioPaketOverflow
	MOVW R26,R18
	ST   X,R30
; 0001 0034 RadioPaketOverflow = 0;
	LDI  R30,LOW(0)
	STS  _RadioPaketOverflow,R30
; 0001 0035 RadioPaketPrinyat = 0;
	STS  _RadioPaketPrinyat,R30
; 0001 0036 return 1;
	LDI  R30,LOW(1)
	RJMP _0x2000002
; 0001 0037 }
; 0001 0038 return 0;
_0x20003:
	LDI  R30,LOW(0)
	RJMP _0x2000002
; 0001 0039 }
; .FEND
;char CRC_8(char *Data, unsigned char Length_Data)
; 0001 0047 {
_CRC_8:
; .FSTART _CRC_8
; 0001 0048 char Registr_CRC = 0xFF; // ��������� �������� �������� CRC
; 0001 0049 unsigned char i; // ��������� ����������
; 0001 004A 
; 0001 004B while (Length_Data--)  //��������� CRC ��� ����� ������
	RCALL __SAVELOCR6
	MOV  R19,R26
	__GETWRS 20,21,6
;	*Data -> R20,R21
;	Length_Data -> R19
;	Registr_CRC -> R17
;	i -> R16
	LDI  R17,255
_0x20007:
	MOV  R30,R19
	SUBI R19,1
	CPI  R30,0
	BREQ _0x20009
; 0001 004C {
; 0001 004D Registr_CRC ^= *Data++;
	MOVW R26,R20
	__ADDWRN 20,21,1
	LD   R30,X
	EOR  R17,R30
; 0001 004E for (i = 0; i < 8; i++)
	LDI  R16,LOW(0)
_0x2000B:
	CPI  R16,8
	BRSH _0x2000C
; 0001 004F {
; 0001 0050 Registr_CRC >>= 1;
	LSR  R17
; 0001 0051 if ( (Registr_CRC & 0b00000001) != 0 )
	SBRS R17,0
	RJMP _0x2000D
; 0001 0052 Registr_CRC ^= 0x31;
	LDI  R30,LOW(49)
	EOR  R17,R30
; 0001 0053 }
_0x2000D:
	SUBI R16,-1
	RJMP _0x2000B
_0x2000C:
; 0001 0054 }
	RJMP _0x20007
_0x20009:
; 0001 0055 return Registr_CRC;
	MOV  R30,R17
_0x2000002:
	RCALL __LOADLOCR6
	ADIW R28,8
	RET
; 0001 0056 }
; .FEND
;void RadioPriem(void)
; 0001 005B {
_RadioPriem:
; .FSTART _RadioPriem
; 0001 005C // �������������� ��� � ��� ��� ���������
; 0001 005D static enum InfoBit
; 0001 005E {
; 0001 005F _0 = 0, // ��� 0
; 0001 0060 _1 = 1, // ��� 1
; 0001 0061 A_ = 2, // ������� �
; 0001 0062 Neopredelen = 4, // �������������
; 0001 0063 } InfoBit = Neopredelen;

	.DSEG

	.CSEG
; 0001 0064 // ����� ������ � ��� ��� ���������
; 0001 0065 static enum Paket
; 0001 0066 {
; 0001 0067 StartBit = 0, // ��������� 1-��� ���
; 0001 0068 Bit0_7   = 1, // ��� � 1-�� �� 7-�� (������ � ��� 0 �������� ���������)
; 0001 0069 Bit8_n   = 2, // ��� � 8-�� �� n-�� (������ ������������ + CRC)
; 0001 006A Reset    = 3, // ����� �����-�����
; 0001 006B } Paket = StartBit;
; 0001 006C /*
; 0001 006D ��������������� � 1 ��� ������������� (� ������ ������� ����������� PIN = 1)
; 0001 006E ��� ������ ���������� ���� ������
; 0001 006F */
; 0001 0070 static char FlagSinhronizaciya = 1;

	.DSEG

	.CSEG
; 0001 0071 static unsigned char PoluBitStrobCount = 0; // ���-�� ��������� ������������ ��� ...
; 0001 0072 // ������� ��������� ������� � ������ �������� ��������������� ����
; 0001 0073 static unsigned int PoluBit_A_Count = 0; // ������� ������� �������� A
; 0001 0074 static unsigned int PoluBit_B_Count = 0; // ������� ������� �������� B
; 0001 0075 static unsigned char IndexBayt = 0; // ������ ��������� �����
; 0001 0076 static unsigned char IndexPaketBayt = 0; // ������ ��������� ������ ������
; 0001 0077 char BitPreambulaIn; // ������ ��� ���� ���������
; 0001 0078 static char BaytIn; // ������ ��� ��������� �����
; 0001 0079 unsigned char adc_data;
; 0001 007A 
; 0001 007B // Read the AD conversion result
; 0001 007C adc_data = REGISTR_ADC_DATA_H;
	RCALL __SAVELOCR2
;	BitPreambulaIn -> R17
;	adc_data -> R16
	IN   R16,5
; 0001 007D // �������������
; 0001 007E if (FlagSinhronizaciya == 1)
	LDS  R26,_FlagSinhronizaciya_S0010002000
	CPI  R26,LOW(0x1)
	BRNE _0x20010
; 0001 007F {
; 0001 0080 if (adc_data >= RADIO_SIGNAL_IN_VOLT)
	CPI  R16,150
	BRLO _0x20011
; 0001 0081 FlagSinhronizaciya = 0;
	LDI  R30,LOW(0)
	STS  _FlagSinhronizaciya_S0010002000,R30
; 0001 0082 else
	RJMP _0x20012
_0x20011:
; 0001 0083 return;
	RJMP _0x2000001
; 0001 0084 }
_0x20012:
; 0001 0085 // ����� ��������������� ����
; 0001 0086 switch (InfoBit)
_0x20010:
	LDS  R30,_InfoBit_S0010002000
; 0001 0087 {
; 0001 0088 case Neopredelen:
	CPI  R30,LOW(0x4)
	BRNE _0x20016
; 0001 0089 /*
; 0001 008A � ������������ ���������� ���� ��� ���������� ������
; 0001 008B �������������� ��� ��� ������ ������ ������
; 0001 008C */
; 0001 008D if (Paket == StartBit)
	LDS  R30,_Paket_S0010002000
	CPI  R30,0
	BRNE _0x20017
; 0001 008E {
; 0001 008F if (adc_data < RADIO_SIGNAL_IN_VOLT)
	CPI  R16,150
	BRSH _0x20018
; 0001 0090 {
; 0001 0091 goto Reset;
	RJMP _0x20019
; 0001 0092 }
; 0001 0093 }
_0x20018:
; 0001 0094 PoluBit_A_Count = PoluBit_A_Count + adc_data;
_0x20017:
	MOV  R30,R16
	RCALL SUBOPT_0x0
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STS  _PoluBit_A_Count_S0010002000,R30
	STS  _PoluBit_A_Count_S0010002000+1,R31
; 0001 0095 break;
	RJMP _0x20015
; 0001 0096 case A_:
_0x20016:
	CPI  R30,LOW(0x2)
	BRNE _0x20015
; 0001 0097 PoluBit_B_Count = PoluBit_B_Count + adc_data;
	MOV  R30,R16
	LDS  R26,_PoluBit_B_Count_S0010002000
	LDS  R27,_PoluBit_B_Count_S0010002000+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STS  _PoluBit_B_Count_S0010002000,R30
	STS  _PoluBit_B_Count_S0010002000+1,R31
; 0001 0098 break;
; 0001 0099 }
_0x20015:
; 0001 009A ++PoluBitStrobCount;
	LDS  R30,_PoluBitStrobCount_S0010002000
	SUBI R30,-LOW(1)
	STS  _PoluBitStrobCount_S0010002000,R30
; 0001 009B // ������� �� �������� ������� ������
; 0001 009C if (PoluBitStrobCount == CIKL_ADC_COUNT)
	LDS  R26,_PoluBitStrobCount_S0010002000
	CPI  R26,LOW(0xA)
	BRNE _0x2001B
; 0001 009D {
; 0001 009E PoluBitStrobCount = 0;
	LDI  R30,LOW(0)
	STS  _PoluBitStrobCount_S0010002000,R30
; 0001 009F switch (InfoBit)
	LDS  R30,_InfoBit_S0010002000
; 0001 00A0 {
; 0001 00A1 case Neopredelen:
	CPI  R30,LOW(0x4)
	BRNE _0x2001F
; 0001 00A2 // ��������� ��� ������
; 0001 00A3 if (Paket == StartBit)
	LDS  R30,_Paket_S0010002000
	CPI  R30,0
	BRNE _0x20020
; 0001 00A4 {
; 0001 00A5 Paket = Bit0_7;
	LDI  R30,LOW(1)
	STS  _Paket_S0010002000,R30
; 0001 00A6 PoluBit_A_Count = 0;
	RCALL SUBOPT_0x1
; 0001 00A7 return;
	RJMP _0x2000001
; 0001 00A8 }
; 0001 00A9 InfoBit = A_;
_0x20020:
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x2
; 0001 00AA return;
	RJMP _0x2000001
; 0001 00AB case A_:
_0x2001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2001E
; 0001 00AC if (PoluBit_A_Count > PoluBit_B_Count)
	RCALL SUBOPT_0x3
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x20022
; 0001 00AD InfoBit = _1;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x2
; 0001 00AE if (PoluBit_A_Count < PoluBit_B_Count)
_0x20022:
	RCALL SUBOPT_0x3
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x20023
; 0001 00AF InfoBit = _0;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x2
; 0001 00B0 // ������������ �����-�����
; 0001 00B1 if (PoluBit_A_Count == PoluBit_B_Count)
_0x20023:
	RCALL SUBOPT_0x3
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x20024
; 0001 00B2 {
; 0001 00B3 goto Reset;
	RJMP _0x20019
; 0001 00B4 }
; 0001 00B5 PoluBit_A_Count = 0;
_0x20024:
	RCALL SUBOPT_0x1
; 0001 00B6 PoluBit_B_Count = 0;
	RCALL SUBOPT_0x4
; 0001 00B7 break;
; 0001 00B8 }
_0x2001E:
; 0001 00B9 }
; 0001 00BA switch (Paket)
_0x2001B:
	LDS  R30,_Paket_S0010002000
; 0001 00BB {
; 0001 00BC //����� ���� ����� ���������
; 0001 00BD case Bit0_7:
	CPI  R30,LOW(0x1)
	BRNE _0x20028
; 0001 00BE switch (InfoBit)
	LDS  R30,_InfoBit_S0010002000
; 0001 00BF {
; 0001 00C0 case _0: case _1:
	CPI  R30,0
	BREQ _0x2002D
	CPI  R30,LOW(0x1)
	BRNE _0x2002B
_0x2002D:
; 0001 00C1 /*
; 0001 00C2 ��������� �������� ��� � ������ ���������
; 0001 00C3 ���� ���������� ������������ ����� ������������ �����-�����
; 0001 00C4 */
; 0001 00C5 if (BIT_RAVEN_0(PREAMBULA, IndexBayt)) // n-��� ��������� ����� 0
	RCALL SUBOPT_0x5
	LDI  R26,LOW(1)
	RCALL __LSLB12
	ANDI R30,LOW(0x55)
	BRNE _0x2002F
; 0001 00C6 BitPreambulaIn = 0;
	LDI  R17,LOW(0)
; 0001 00C7 else // n-��� ��������� ����� 1
	RJMP _0x20030
_0x2002F:
; 0001 00C8 BitPreambulaIn = 1;
	LDI  R17,LOW(1)
; 0001 00C9 if (InfoBit == BitPreambulaIn)
_0x20030:
	LDS  R26,_InfoBit_S0010002000
	CP   R17,R26
	BRNE _0x20031
; 0001 00CA ++IndexBayt;
	RCALL SUBOPT_0x6
; 0001 00CB else // ������������ �����-�����
	RJMP _0x20032
_0x20031:
; 0001 00CC {
; 0001 00CD goto Reset;
	RJMP _0x20019
; 0001 00CE }
_0x20032:
; 0001 00CF InfoBit = Neopredelen;
	RCALL SUBOPT_0x7
; 0001 00D0 // ��������� �������
; 0001 00D1 if (IndexBayt == 8)
	BRNE _0x20033
; 0001 00D2 {
; 0001 00D3 IndexBayt = 0;
	RCALL SUBOPT_0x8
; 0001 00D4 Paket = Bit8_n;
	LDI  R30,LOW(2)
	STS  _Paket_S0010002000,R30
; 0001 00D5 }
; 0001 00D6 }
_0x20033:
_0x2002B:
; 0001 00D7 break;
	RJMP _0x20027
; 0001 00D8 /*
; 0001 00D9 ����� ���� ��������� �������������� ����� ������
; 0001 00DA ���� ���������������� ������
; 0001 00DB */
; 0001 00DC case Bit8_n:
_0x20028:
	CPI  R30,LOW(0x2)
	BREQ PC+2
	RJMP _0x20034
; 0001 00DD switch (InfoBit)
	LDS  R30,_InfoBit_S0010002000
; 0001 00DE {
; 0001 00DF case _0: case _1:
	CPI  R30,0
	BREQ _0x20039
	CPI  R30,LOW(0x1)
	BREQ PC+2
	RJMP _0x20037
_0x20039:
; 0001 00E0 // ��������� ������� ��� � �������
; 0001 00E1 if (InfoBit == 1)
	LDS  R26,_InfoBit_S0010002000
	CPI  R26,LOW(0x1)
	BRNE _0x2003B
; 0001 00E2 BIT_1(BaytIn,IndexBayt);
	RCALL SUBOPT_0x5
	LDI  R26,LOW(1)
	RCALL __LSLB12
	LDS  R26,_BaytIn_S0010002000
	OR   R30,R26
	RJMP _0x20043
; 0001 00E3 else
_0x2003B:
; 0001 00E4 BIT_0(BaytIn,IndexBayt);
	RCALL SUBOPT_0x5
	LDI  R26,LOW(1)
	RCALL __LSLB12
	COM  R30
	LDS  R26,_BaytIn_S0010002000
	AND  R30,R26
_0x20043:
	STS  _BaytIn_S0010002000,R30
; 0001 00E5 ++IndexBayt;
	RCALL SUBOPT_0x6
; 0001 00E6 InfoBit = Neopredelen;
	RCALL SUBOPT_0x7
; 0001 00E7 // ������ ��� 1 ����
; 0001 00E8 if (IndexBayt == 8)
	BRNE _0x2003D
; 0001 00E9 {
; 0001 00EA IndexBayt = 0;
	RCALL SUBOPT_0x8
; 0001 00EB // ���������� ����� �������
; 0001 00EC if (RadioPaketPrinyat == 1)
	LDS  R26,_RadioPaketPrinyat
	CPI  R26,LOW(0x1)
	BRNE _0x2003E
; 0001 00ED {
; 0001 00EE RadioPaketOverflow = 1;
	LDI  R30,LOW(1)
	STS  _RadioPaketOverflow,R30
; 0001 00EF }
; 0001 00F0 // ������ ���������������� ����
; 0001 00F1 if (IndexPaketBayt < RADIO_PAKET_DATA_BAYT_COUNT + 1)
_0x2003E:
	LDS  R26,_IndexPaketBayt_S0010002000
	CPI  R26,LOW(0x6)
	BRSH _0x2003F
; 0001 00F2 {
; 0001 00F3 RadioPaketIn[IndexPaketBayt] = BaytIn; // ��������� �������� ���� � ������
	LDS  R30,_IndexPaketBayt_S0010002000
	LDI  R31,0
	SUBI R30,LOW(-_RadioPaketIn)
	SBCI R31,HIGH(-_RadioPaketIn)
	LDS  R26,_BaytIn_S0010002000
	STD  Z+0,R26
; 0001 00F4 ++IndexPaketBayt;
	LDS  R30,_IndexPaketBayt_S0010002000
	SUBI R30,-LOW(1)
	STS  _IndexPaketBayt_S0010002000,R30
; 0001 00F5 }
; 0001 00F6 // ���� ����� ������ ������ ��������
; 0001 00F7 if (IndexPaketBayt == (RADIO_PAKET_DATA_BAYT_COUNT + 1))
_0x2003F:
	LDS  R26,_IndexPaketBayt_S0010002000
	CPI  R26,LOW(0x6)
	BRNE _0x20040
; 0001 00F8 {
; 0001 00F9 // �������� ����������� ���������������� ������ ��������� ������
; 0001 00FA if (RadioPaketIn[RADIO_PAKET_DATA_BAYT_COUNT] == CRC_8(RadioPaketIn, RADIO_PAKET ...
	LDI  R30,LOW(_RadioPaketIn)
	LDI  R31,HIGH(_RadioPaketIn)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(5)
	RCALL _CRC_8
	__GETB2MN _RadioPaketIn,5
	CP   R30,R26
	BRNE _0x20041
; 0001 00FB RadioPaketPrinyat = 1; // ������ � �������
	LDI  R30,LOW(1)
	STS  _RadioPaketPrinyat,R30
; 0001 00FC // ������ ����� ������ ������
; 0001 00FD goto Reset;
_0x20041:
	RJMP _0x20019
; 0001 00FE }
; 0001 00FF }
_0x20040:
; 0001 0100 }
_0x2003D:
_0x20037:
; 0001 0101 return;
	RJMP _0x2000001
; 0001 0102 // ����� �����-�����
; 0001 0103 case Reset:
_0x20034:
	CPI  R30,LOW(0x3)
	BRNE _0x20027
; 0001 0104 Reset:
_0x20019:
; 0001 0105 Paket = StartBit;
	LDI  R30,LOW(0)
	STS  _Paket_S0010002000,R30
; 0001 0106 InfoBit = Neopredelen;
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x2
; 0001 0107 FlagSinhronizaciya = 1;
	LDI  R30,LOW(1)
	STS  _FlagSinhronizaciya_S0010002000,R30
; 0001 0108 PoluBitStrobCount = 0;
	LDI  R30,LOW(0)
	STS  _PoluBitStrobCount_S0010002000,R30
; 0001 0109 PoluBit_A_Count = 0;
	RCALL SUBOPT_0x1
; 0001 010A PoluBit_B_Count = 0;
	RCALL SUBOPT_0x4
; 0001 010B IndexBayt = 0;
	RCALL SUBOPT_0x8
; 0001 010C IndexPaketBayt = 0;
	LDI  R30,LOW(0)
	STS  _IndexPaketBayt_S0010002000,R30
; 0001 010D }
_0x20027:
; 0001 010E }
_0x2000001:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND

	.DSEG
_msLedB:
	.BYTE 0x1
_msLedR:
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
_PoluBit_A_Count_S0010002000:
	.BYTE 0x2
_PoluBit_B_Count_S0010002000:
	.BYTE 0x2
_IndexBayt_S0010002000:
	.BYTE 0x1
_IndexPaketBayt_S0010002000:
	.BYTE 0x1
_BaytIn_S0010002000:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x0:
	LDS  R26,_PoluBit_A_Count_S0010002000
	LDS  R27,_PoluBit_A_Count_S0010002000+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(0)
	STS  _PoluBit_A_Count_S0010002000,R30
	STS  _PoluBit_A_Count_S0010002000+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	STS  _InfoBit_S0010002000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3:
	LDS  R30,_PoluBit_B_Count_S0010002000
	LDS  R31,_PoluBit_B_Count_S0010002000+1
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(0)
	STS  _PoluBit_B_Count_S0010002000,R30
	STS  _PoluBit_B_Count_S0010002000+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	LDS  R30,_IndexBayt_S0010002000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	RCALL SUBOPT_0x5
	SUBI R30,-LOW(1)
	STS  _IndexBayt_S0010002000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x2
	LDS  R26,_IndexBayt_S0010002000
	CPI  R26,LOW(0x8)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(0)
	STS  _IndexBayt_S0010002000,R30
	RET

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
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
