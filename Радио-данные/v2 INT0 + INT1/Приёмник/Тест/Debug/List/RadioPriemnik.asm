
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
	RJMP _ext_int0_isr
	RJMP _ext_int1_isr
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

_0x20003:
	.DB  0x1
_0x20010:
	.DB  0x3

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  _InSignal
	.DW  _0x20003*2

	.DW  0x01
	.DW  _InfoBit_S0010004000
	.DW  _0x20010*2

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
;interrupt[EXT_INT0] void ext_int0_isr(void);
;interrupt[EXT_INT1] void ext_int1_isr(void);
;interrupt[TIM1_COMPA] void timer1_compa_isr(void);
;void main(void);
;interrupt[EXT_INT0] void ext_int0_isr(void)
; 0000 002E {

	.CSEG
_ext_int0_isr:
; .FSTART _ext_int0_isr
	RCALL SUBOPT_0x0
; 0000 002F EventNarastayuschiyFront();
	RCALL _EventNarastayuschiyFront
; 0000 0030 }
	RJMP _0x18
; .FEND
;interrupt[EXT_INT1] void ext_int1_isr(void)
; 0000 0035 {
_ext_int1_isr:
; .FSTART _ext_int1_isr
	RCALL SUBOPT_0x0
; 0000 0036 EventSpadayuschiyFront();
	RCALL _EventSpadayuschiyFront
; 0000 0037 }
	RJMP _0x18
; .FEND
;interrupt[TIM1_COMPA] void timer1_compa_isr(void)
; 0000 003D {
_timer1_compa_isr:
; .FSTART _timer1_compa_isr
	RCALL SUBOPT_0x0
; 0000 003E RadioPriem();
	RCALL _RadioPriem
; 0000 003F 
; 0000 0040 if (msLedG != 0)
	LDS  R30,_msLedG
	CPI  R30,0
	BREQ _0x3
; 0000 0041 --msLedG;
	LDS  R30,_msLedG
	SUBI R30,LOW(1)
	STS  _msLedG,R30
; 0000 0042 if (msLedB != 0)
_0x3:
	LDS  R30,_msLedB
	CPI  R30,0
	BREQ _0x4
; 0000 0043 --msLedB;
	LDS  R30,_msLedB
	SUBI R30,LOW(1)
	STS  _msLedB,R30
; 0000 0044 }
_0x4:
_0x18:
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
; 0000 0048 {
_main:
; .FSTART _main
; 0000 0049 // Пользовательский пакет данных содержащий принятые по радио-каналу данные
; 0000 004A char RadioPaketData[RADIO_PAKET_DATA_BAYT_COUNT];
; 0000 004B char FlagOwerflow; // Пользовательский флаг потери предыдущего пакета
; 0000 004C // Crystal Oscillator division factor: 1
; 0000 004D #pragma optsize -
; 0000 004E CLKPR = (1 << CLKPCE);
	SBIW R28,5
;	RadioPaketData -> Y+0
;	FlagOwerflow -> R17
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 004F CLKPR = (0 << CLKPCE) | (0 << CLKPS3) | (0 << CLKPS2) | (0 << CLKPS1) | (0 << CL ...
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 0050 #ifdef _OPTIMIZE_SIZE_
; 0000 0051 #pragma optsize +
; 0000 0052 #endif
; 0000 0053 
; 0000 0054 // Input/Output Ports initialization
; 0000 0055 // Port A initialization
; 0000 0056 // Function: Bit2=In Bit1=In Bit0=In
; 0000 0057 DDRA=(0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	OUT  0x1A,R30
; 0000 0058 // State: Bit2=T Bit1=T Bit0=T
; 0000 0059 PORTA=(0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 005A 
; 0000 005B // Port B initialization
; 0000 005C // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=Out Bit1=In Bit0=In
; 0000 005D DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (1<<DDB3) | (1<<DDB2) | (0< ...
	LDI  R30,LOW(12)
	OUT  0x17,R30
; 0000 005E // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=0 Bit2=0 Bit1=T Bit0=T
; 0000 005F PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<< ...
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0060 
; 0000 0061 // Port D initialization
; 0000 0062 // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0063 DDRD=(0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0< ...
	OUT  0x11,R30
; 0000 0064 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0065 PORTD=(0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<< ...
	OUT  0x12,R30
; 0000 0066 
; 0000 0067 // Timer/Counter 0 initialization
; 0000 0068 // Clock source: System Clock
; 0000 0069 // Clock value: 62,500 kHz
; 0000 006A // Mode: CTC top=OCR0A
; 0000 006B // OC0A output: Disconnected
; 0000 006C // OC0B output: Disconnected
; 0000 006D // Timer Period: 1,2 ms
; 0000 006E TCCR0A = (0 << COM0A1) | (0 << COM0A0) | (0 << COM0B1) | (0 << COM0B0) | (1 << W ...
	LDI  R30,LOW(2)
	OUT  0x30,R30
; 0000 006F TCCR0B = (0 << WGM02) | (0 << CS02) | (1 << CS01) | (1 << CS00);
	LDI  R30,LOW(3)
	OUT  0x33,R30
; 0000 0070 TCNT0 = 0x00;
	RCALL SUBOPT_0x1
; 0000 0071 OCR0A = 0x4A;
	LDI  R30,LOW(74)
	OUT  0x36,R30
; 0000 0072 OCR0B = 0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 0073 
; 0000 0074 // Timer/Counter 1 initialization
; 0000 0075 // Clock source: System Clock
; 0000 0076 // Clock value: 4000,000 kHz
; 0000 0077 // Mode: CTC top=OCR1A
; 0000 0078 // OC1A output: Disconnected
; 0000 0079 // OC1B output: Disconnected
; 0000 007A // Noise Canceler: Off
; 0000 007B // Input Capture on Falling Edge
; 0000 007C // Timer Period: 1 ms
; 0000 007D // Timer1 Overflow Interrupt: Off
; 0000 007E // Input Capture Interrupt: Off
; 0000 007F // Compare A Match Interrupt: On
; 0000 0080 // Compare B Match Interrupt: Off
; 0000 0081 TCCR1A = (0 << COM1A1) | (0 << COM1A0) | (0 << COM1B1) | (0 << COM1B0) | (0 << W ...
	OUT  0x2F,R30
; 0000 0082 TCCR1B = (0 << ICNC1) | (0 << ICES1) | (0 << WGM13) | (1 << WGM12) | (0 << CS12) ...
	LDI  R30,LOW(9)
	OUT  0x2E,R30
; 0000 0083 TCNT1H = 0x00;
	RCALL SUBOPT_0x2
; 0000 0084 TCNT1L = 0x00;
; 0000 0085 ICR1H = 0x00;
	LDI  R30,LOW(0)
	OUT  0x25,R30
; 0000 0086 ICR1L = 0x00;
	OUT  0x24,R30
; 0000 0087 OCR1AH = 0x0F;
	LDI  R30,LOW(15)
	OUT  0x2B,R30
; 0000 0088 OCR1AL = 0x9F;
	LDI  R30,LOW(159)
	OUT  0x2A,R30
; 0000 0089 OCR1BH = 0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
; 0000 008A OCR1BL = 0x00;
	OUT  0x28,R30
; 0000 008B 
; 0000 008C // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 008D TIMSK = (0 << TOIE1) | (1 << OCIE1A) | (0 << OCIE1B) | (0 << ICIE1) | (0 << OCIE ...
	LDI  R30,LOW(64)
	OUT  0x39,R30
; 0000 008E 
; 0000 008F // External Interrupt(s) initialization
; 0000 0090 // INT0: On
; 0000 0091 // INT0 Mode: Rising Edge
; 0000 0092 // INT1: On
; 0000 0093 // INT1 Mode: Falling Edge
; 0000 0094 // Interrupt on any change on pins PCINT0-7: Off
; 0000 0095 // Interrupt on any change on pins PCINT8-10: Off
; 0000 0096 // Interrupt on any change on pins PCINT11-17: Off
; 0000 0097 MCUCR = (1 << ISC11) | (0 << ISC10) | (1 << ISC01) | (1 << ISC00);
	LDI  R30,LOW(11)
	OUT  0x35,R30
; 0000 0098 GIMSK = (1 << INT1) | (1 << INT0) | (0 << PCIE0) | (0 << PCIE2) | (0 << PCIE1);
	LDI  R30,LOW(192)
	OUT  0x3B,R30
; 0000 0099 GIFR = (1 << INTF1) | (1 << INTF0) | (0 << PCIF0) | (0 << PCIF2) | (0 << PCIF1);
	OUT  0x3A,R30
; 0000 009A 
; 0000 009B // USI initialization
; 0000 009C // Mode: Disabled
; 0000 009D // Clock source: Register & Counter=no clk.
; 0000 009E // USI Counter Overflow Interrupt: Off
; 0000 009F USICR = (0 << USISIE) | (0 << USIOIE) | (0 << USIWM1) | (0 << USIWM0) | (0 << US ...
	LDI  R30,LOW(0)
	OUT  0xD,R30
; 0000 00A0 
; 0000 00A1 // USART initialization
; 0000 00A2 // USART disabled
; 0000 00A3 UCSRB = (0 << RXCIE) | (0 << TXCIE) | (0 << UDRIE) | (0 << RXEN) | (0 << TXEN) | ...
	OUT  0xA,R30
; 0000 00A4 
; 0000 00A5 // Analog Comparator initialization
; 0000 00A6 // Analog Comparator: Off
; 0000 00A7 // The Analog Comparator's positive input is
; 0000 00A8 // connected to the AIN0 pin
; 0000 00A9 // The Analog Comparator's negative input is
; 0000 00AA // connected to the AIN1 pin
; 0000 00AB ACSR = (1 << ACD) | (0 << ACBG) | (0 << ACO) | (0 << ACI) | (0 << ACIE) | (0 <<  ...
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00AC // Digital input buffer on AIN0: On
; 0000 00AD // Digital input buffer on AIN1: On
; 0000 00AE DIDR = (0 << AIN0D) | (0 << AIN1D);
	LDI  R30,LOW(0)
	OUT  0x1,R30
; 0000 00AF 
; 0000 00B0 // Globally enable interrupts
; 0000 00B1 #asm("sei")
	SEI
; 0000 00B2 
; 0000 00B3 while (1)
_0x5:
; 0000 00B4 {
; 0000 00B5 // Получение пакета данных, принятые по радио-каналу
; 0000 00B6 if (RadioRead(RadioPaketData, &FlagOwerflow) == 1)
	MOV  R30,R28
	ST   -Y,R30
	IN   R26,SPL
	PUSH R17
	RCALL _RadioRead
	POP  R17
	CPI  R30,LOW(0x1)
	BRNE _0x8
; 0000 00B7 {
; 0000 00B8 if ( (RadioPaketData[0] == 11) &&
; 0000 00B9 (RadioPaketData[1] == 22) &&
; 0000 00BA (RadioPaketData[2] == 33) &&
; 0000 00BB (RadioPaketData[3] == 44) &&
; 0000 00BC (RadioPaketData[4] == 55))
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
; 0000 00BD {
; 0000 00BE msLedB = 150;
	LDI  R30,LOW(150)
	STS  _msLedB,R30
; 0000 00BF PORTB.3 = 1; // Включить LED B
	SBI  0x18,3
; 0000 00C0 }
; 0000 00C1 if (FlagOwerflow == 1)
_0x9:
	CPI  R17,1
	BRNE _0xE
; 0000 00C2 {
; 0000 00C3 msLedG = 150;
	LDI  R30,LOW(150)
	STS  _msLedG,R30
; 0000 00C4 PORTB.2 = 1; // Включить LED G
	SBI  0x18,2
; 0000 00C5 }
; 0000 00C6 }
_0xE:
; 0000 00C7 if (msLedG == 0)
_0x8:
	LDS  R30,_msLedG
	CPI  R30,0
	BRNE _0x11
; 0000 00C8 PORTB.2 = 0; // Выключить LED G
	CBI  0x18,2
; 0000 00C9 if (msLedB == 0)
_0x11:
	LDS  R30,_msLedB
	CPI  R30,0
	BRNE _0x14
; 0000 00CA PORTB.3 = 0; // Выключить LED B
	CBI  0x18,3
; 0000 00CB }
_0x14:
	RJMP _0x5
; 0000 00CC }
_0x17:
	RJMP _0x17
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif
;volatile enum InSignal
;NarastayuschiyFront = 0, // Нарастающий фронт
;SpadayuschiyFront = 1,   // Спадающий фронт
;} InSignal = SpadayuschiyFront;

	.DSEG
;volatile enum Paket
;StartBit = 0, // Стартовый 1-ный бит
;Bit0_7 = 1, // Бит с 0-го по 7-ой (содержит преамбулу)
;Bit8_n = 2, // Бит с 8-го по n-ый (данные пользователя + CRC)
;} Paket = StartBit;
;volatile char RadioPaketIn[RADIO_PAKET_DATA_BAYT_COUNT + 1];
;volatile unsigned int InfoBit1TikTCNT = 0;
;volatile char RadioPaketPrinyat = 0;
;volatile char RadioPaketOverflow = 0;
;char RadioRead (char *Data, char *FlagOwerflow)
; 0001 003A {

	.CSEG
_RadioRead:
; .FSTART _RadioRead
; 0001 003B unsigned char i; // Индексная переменная
; 0001 003C 
; 0001 003D if (RadioPaketPrinyat == 1)
	RCALL __SAVELOCR4
	MOV  R16,R26
	LDD  R19,Y+4
;	*Data -> R19
;	*FlagOwerflow -> R16
;	i -> R17
	LDS  R26,_RadioPaketPrinyat
	CPI  R26,LOW(0x1)
	BRNE _0x20004
; 0001 003E {
; 0001 003F for (i = 0; i < RADIO_PAKET_DATA_BAYT_COUNT; i++)
	LDI  R17,LOW(0)
_0x20006:
	CPI  R17,5
	BRSH _0x20007
; 0001 0040 Data[i] = RadioPaketIn[i];
	MOV  R30,R17
	ADD  R30,R19
	MOV  R0,R30
	LDI  R26,LOW(_RadioPaketIn)
	ADD  R26,R17
	LD   R30,X
	MOV  R26,R0
	ST   X,R30
	SUBI R17,-1
	RJMP _0x20006
_0x20007:
; 0001 0041 *FlagOwerflow = RadioPaketOverflow;
	LDS  R30,_RadioPaketOverflow
	MOV  R26,R16
	ST   X,R30
; 0001 0042 RadioPaketOverflow = 0;
	LDI  R30,LOW(0)
	STS  _RadioPaketOverflow,R30
; 0001 0043 RadioPaketPrinyat = 0;
	STS  _RadioPaketPrinyat,R30
; 0001 0044 return 1;
	LDI  R30,LOW(1)
	RJMP _0x2000002
; 0001 0045 }
; 0001 0046 return 0;
_0x20004:
	LDI  R30,LOW(0)
	RJMP _0x2000002
; 0001 0047 }
; .FEND
;void EventNarastayuschiyFront (void)
; 0001 004C {
_EventNarastayuschiyFront:
; .FSTART _EventNarastayuschiyFront
; 0001 004D // Поиск 1-ного стартового бита
; 0001 004E if (Paket == StartBit)
	LDS  R30,_Paket
	CPI  R30,0
	BRNE _0x20008
; 0001 004F {
; 0001 0050 // Синхронизация внутриннего тактового генератора для приёма данных по радио-кан ...
; 0001 0051 // Обнуление счётного регистра
; 0001 0052 #ifdef REGISTR_TCNT_TIMER_CLK
; 0001 0053 REGISTR_TCNT_TIMER_CLK = 0;
; 0001 0054 #endif
; 0001 0055 #ifdef REGISTR_TCNTH_TIMER_CLK
; 0001 0056 REGISTR_TCNTH_TIMER_CLK = 0; // Сначало старший байт
	RCALL SUBOPT_0x2
; 0001 0057 #endif
; 0001 0058 #ifdef REGISTR_TCNTL_TIMER_CLK
; 0001 0059 REGISTR_TCNTL_TIMER_CLK = 0; // а затем младший
; 0001 005A #endif
; 0001 005B // Сбросс флага прерывания таймера/счётчика
; 0001 005C BIT_1(REGISTR_FLAG_PRERYIVANIYA, FLAG_PRERYIVANIYA);
	IN   R30,0x38
	ORI  R30,0x40
	OUT  0x38,R30
; 0001 005D }
; 0001 005E InSignal = NarastayuschiyFront;
_0x20008:
	LDI  R30,LOW(0)
	STS  _InSignal,R30
; 0001 005F // Начать отсчёт длительности периуда 1-ного информационного бита
; 0001 0060 #ifdef REGISTR_TCNT_TIMER_PERIUD
; 0001 0061 REGISTR_TCNT_TIMER_PERIUD = 0;
	RCALL SUBOPT_0x1
; 0001 0062 #endif
; 0001 0063 #ifdef REGISTR_TCNTH_TIMER_PERIUD
; 0001 0064 REGISTR_TCNTH_TIMER_PERIUD = 0;
; 0001 0065 #endif
; 0001 0066 #ifdef REGISTR_TCNTL_TIMER_PERIUD
; 0001 0067 REGISTR_TCNTL_TIMER_PERIUD = 0;
; 0001 0068 #endif
; 0001 0069 }
	RET
; .FEND
;void EventSpadayuschiyFront (void)
; 0001 006E {
_EventSpadayuschiyFront:
; .FSTART _EventSpadayuschiyFront
; 0001 006F InSignal = SpadayuschiyFront;
	LDI  R30,LOW(1)
	STS  _InSignal,R30
; 0001 0070 // Суммировать все длительности периуда 1-ного состояния принимаемого информацио ...
; 0001 0071 InfoBit1TikTCNT = InfoBit1TikTCNT +
; 0001 0072 #ifdef REGISTR_TCNT_TIMER_PERIUD
; 0001 0073 REGISTR_TCNT_TIMER_PERIUD;
	RCALL SUBOPT_0x3
; 0001 0074 #endif
; 0001 0075 #ifdef REGISTR_TCNTH_TIMER_PERIUD
; 0001 0076 REGISTR_TCNTH_TIMER_PERIUD;
; 0001 0077 #endif
; 0001 0078 #ifdef REGISTR_TCNTL_TIMER_PERIUD
; 0001 0079 REGISTR_TCNTL_TIMER_PERIUD;
; 0001 007A #endif
; 0001 007B }
	RET
; .FEND
;char CRC_8(char *Data, unsigned char Length_Data)
; 0001 0089 {
_CRC_8:
; .FSTART _CRC_8
; 0001 008A char Registr_CRC = 0xFF; // Начальное значение регистра CRC
; 0001 008B unsigned char i; // Индексная переменная
; 0001 008C 
; 0001 008D while (Length_Data--)  //Вычислить CRC для блока данных
	RCALL __SAVELOCR4
	MOV  R19,R26
	LDD  R18,Y+4
;	*Data -> R18
;	Length_Data -> R19
;	Registr_CRC -> R17
;	i -> R16
	LDI  R17,255
_0x20009:
	MOV  R30,R19
	SUBI R19,1
	CPI  R30,0
	BREQ _0x2000B
; 0001 008E {
; 0001 008F Registr_CRC ^= *Data++;
	MOV  R26,R18
	SUBI R18,-1
	LD   R30,X
	EOR  R17,R30
; 0001 0090 for (i = 0; i < 8; i++)
	LDI  R16,LOW(0)
_0x2000D:
	CPI  R16,8
	BRSH _0x2000E
; 0001 0091 {
; 0001 0092 Registr_CRC >>= 1;
	LSR  R17
; 0001 0093 if ( (Registr_CRC & 0b00000001) != 0 )
	SBRS R17,0
	RJMP _0x2000F
; 0001 0094 Registr_CRC ^= 0x31;
	LDI  R30,LOW(49)
	EOR  R17,R30
; 0001 0095 }
_0x2000F:
	SUBI R16,-1
	RJMP _0x2000D
_0x2000E:
; 0001 0096 }
	RJMP _0x20009
_0x2000B:
; 0001 0097 return Registr_CRC;
	MOV  R30,R17
_0x2000002:
	RCALL __LOADLOCR4
	ADIW R28,5
	RET
; 0001 0098 }
; .FEND
;void RadioPriem(void)
; 0001 009D {
_RadioPriem:
; .FSTART _RadioPriem
; 0001 009E // Информационный бит и все его состояния
; 0001 009F static enum InfoBit
; 0001 00A0 {
; 0001 00A1 _0 = 0, // Бит 0
; 0001 00A2 _1 = 1, // Бит 1
; 0001 00A3 A_ = 2, // Полубит А
; 0001 00A4 Neopredelen = 3, // Неопределённое
; 0001 00A5 } InfoBit = Neopredelen;

	.DSEG

	.CSEG
; 0001 00A6 static unsigned int PoluBit_A_Count1 = 0; // Кол-во принятых 1-ных сигналов полу ...
; 0001 00A7 static unsigned int PoluBit_B_Count1 = 0; // Кол-во принятых 1-ных сигналов полу ...
; 0001 00A8 static unsigned char IndexBayt = 0; // Индекс принятого байта
; 0001 00A9 static unsigned char IndexPaketBayt = 0; // Индекс принятого пакета байтов
; 0001 00AA char BitPreambula; // Буффер для бита преамбулы
; 0001 00AB static char BaytIn; // Буффер для принятого байта
; 0001 00AC 
; 0001 00AD // Поиск 1-ного стартового бита
; 0001 00AE if (Paket == StartBit)
	ST   -Y,R17
;	BitPreambula -> R17
	LDS  R30,_Paket
	CPI  R30,0
	BRNE _0x20011
; 0001 00AF {
; 0001 00B0 switch (InSignal)
	LDS  R30,_InSignal
; 0001 00B1 {
; 0001 00B2 // У стартового бита нет спадающего фронта
; 0001 00B3 case SpadayuschiyFront:
	CPI  R30,LOW(0x1)
	BRNE _0x20015
; 0001 00B4 return;
	RJMP _0x2000001
; 0001 00B5 // Цикл приёма стартового бита завершён
; 0001 00B6 case NarastayuschiyFront:
_0x20015:
	CPI  R30,0
	BRNE _0x20014
; 0001 00B7 Paket = Bit0_7;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x4
; 0001 00B8 InfoBit1TikTCNT = 0;
	RCALL SUBOPT_0x5
; 0001 00B9 #ifdef REGISTR_TCNT_TIMER_PERIUD
; 0001 00BA REGISTR_TCNT_TIMER_PERIUD = 0;
	RCALL SUBOPT_0x1
; 0001 00BB #endif
; 0001 00BC #ifdef REGISTR_TCNTH_TIMER_PERIUD
; 0001 00BD REGISTR_TCNTH_TIMER_PERIUD = 0;
; 0001 00BE #endif
; 0001 00BF #ifdef REGISTR_TCNTL_TIMER_PERIUD
; 0001 00C0 REGISTR_TCNTL_TIMER_PERIUD = 0;
; 0001 00C1 #endif
; 0001 00C2 return;
	RJMP _0x2000001
; 0001 00C3 }
_0x20014:
; 0001 00C4 }
; 0001 00C5 // Поиск информационного бита
; 0001 00C6 if (InSignal == NarastayuschiyFront)
_0x20011:
	LDS  R30,_InSignal
	CPI  R30,0
	BRNE _0x20017
; 0001 00C7 {
; 0001 00C8 InfoBit1TikTCNT = InfoBit1TikTCNT +
; 0001 00C9 #ifdef REGISTR_TCNT_TIMER_PERIUD
; 0001 00CA REGISTR_TCNT_TIMER_PERIUD;
	RCALL SUBOPT_0x3
; 0001 00CB #endif
; 0001 00CC #ifdef REGISTR_TCNTH_TIMER_PERIUD
; 0001 00CD REGISTR_TCNTH_TIMER_PERIUD;
; 0001 00CE #endif
; 0001 00CF #ifdef REGISTR_TCNTL_TIMER_PERIUD
; 0001 00D0 REGISTR_TCNTL_TIMER_PERIUD;
; 0001 00D1 #endif
; 0001 00D2 }
; 0001 00D3 #ifdef REGISTR_TCNT_TIMER_PERIUD
; 0001 00D4 REGISTR_TCNT_TIMER_PERIUD = 0;
_0x20017:
	RCALL SUBOPT_0x1
; 0001 00D5 #endif
; 0001 00D6 #ifdef REGISTR_TCNTH_TIMER_PERIUD
; 0001 00D7 REGISTR_TCNTH_TIMER_PERIUD = 0;
; 0001 00D8 #endif
; 0001 00D9 #ifdef REGISTR_TCNTL_TIMER_PERIUD
; 0001 00DA REGISTR_TCNTL_TIMER_PERIUD = 0;
; 0001 00DB #endif
; 0001 00DC switch (InfoBit)
	LDS  R30,_InfoBit_S0010004000
; 0001 00DD {
; 0001 00DE // Полубит из входного сигнала найден
; 0001 00DF case Neopredelen:
	CPI  R30,LOW(0x3)
	BRNE _0x2001B
; 0001 00E0 InfoBit = A_;
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x6
; 0001 00E1 PoluBit_A_Count1 = InfoBit1TikTCNT;
	RCALL SUBOPT_0x7
	STS  _PoluBit_A_Count1_S0010004000,R30
	STS  _PoluBit_A_Count1_S0010004000+1,R31
; 0001 00E2 // Цикл приёма полубита завершён
; 0001 00E3 InfoBit1TikTCNT = 0;
	RCALL SUBOPT_0x5
; 0001 00E4 return;
	RJMP _0x2000001
; 0001 00E5 // Полубит из входного сигнала найден
; 0001 00E6 case A_:
_0x2001B:
	CPI  R30,LOW(0x2)
	BRNE _0x2001A
; 0001 00E7 PoluBit_B_Count1 = InfoBit1TikTCNT;
	RCALL SUBOPT_0x7
	STS  _PoluBit_B_Count1_S0010004000,R30
	STS  _PoluBit_B_Count1_S0010004000+1,R31
; 0001 00E8 // Цикл приёма полубита завершён
; 0001 00E9 InfoBit1TikTCNT = 0;
	RCALL SUBOPT_0x5
; 0001 00EA if (PoluBit_A_Count1 > PoluBit_B_Count1)
	RCALL SUBOPT_0x8
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x2001D
; 0001 00EB InfoBit = _1;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x6
; 0001 00EC if (PoluBit_A_Count1 < PoluBit_B_Count1)
_0x2001D:
	RCALL SUBOPT_0x8
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x2001E
; 0001 00ED InfoBit = _0;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x6
; 0001 00EE // Перезагрузка радио-приёма
; 0001 00EF if (PoluBit_A_Count1 == PoluBit_B_Count1)
_0x2001E:
	RCALL SUBOPT_0x8
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x2001F
; 0001 00F0 {
; 0001 00F1 PoluBit_A_Count1 = 0;
	RCALL SUBOPT_0x9
; 0001 00F2 PoluBit_B_Count1 = 0;
; 0001 00F3 IndexBayt = 0;
	RCALL SUBOPT_0xA
; 0001 00F4 IndexPaketBayt = 0;
; 0001 00F5 InfoBit = Neopredelen;
; 0001 00F6 Paket = StartBit;
; 0001 00F7 return;
	RJMP _0x2000001
; 0001 00F8 }
; 0001 00F9 PoluBit_A_Count1 = 0;
_0x2001F:
	RCALL SUBOPT_0x9
; 0001 00FA PoluBit_B_Count1 = 0;
; 0001 00FB break;
; 0001 00FC }
_0x2001A:
; 0001 00FD switch (Paket)
	LDS  R30,_Paket
; 0001 00FE {
; 0001 00FF // Поиск всех битов преамбулы
; 0001 0100 case Bit0_7:
	CPI  R30,LOW(0x1)
	BRNE _0x20023
; 0001 0101 switch (InfoBit)
	LDS  R30,_InfoBit_S0010004000
; 0001 0102 {
; 0001 0103 case _0: case _1:
	CPI  R30,0
	BREQ _0x20028
	CPI  R30,LOW(0x1)
	BRNE _0x20026
_0x20028:
; 0001 0104 /*
; 0001 0105 Сравнение принятых бит с битами преамбулы
; 0001 0106 Если обнаружено несовпадение тогда перезагрузка радио-приёма
; 0001 0107 */
; 0001 0108 if (BIT_RAVEN_0(PREAMBULA, IndexBayt)) // n-бит преамбулы равен 0
	RCALL SUBOPT_0xB
	LDI  R26,LOW(1)
	RCALL __LSLB12
	ANDI R30,LOW(0x55)
	BRNE _0x2002A
; 0001 0109 BitPreambula = 0;
	LDI  R17,LOW(0)
; 0001 010A else // n-бит преамбулы равен 1
	RJMP _0x2002B
_0x2002A:
; 0001 010B BitPreambula = 1;
	LDI  R17,LOW(1)
; 0001 010C if (InfoBit == BitPreambula)
_0x2002B:
	LDS  R26,_InfoBit_S0010004000
	CP   R17,R26
	BRNE _0x2002C
; 0001 010D ++IndexBayt;
	RCALL SUBOPT_0xC
; 0001 010E else // Перезагрузка радио-приёма
	RJMP _0x2002D
_0x2002C:
; 0001 010F {
; 0001 0110 PoluBit_A_Count1 = 0;
	RCALL SUBOPT_0x9
; 0001 0111 PoluBit_B_Count1 = 0;
; 0001 0112 IndexBayt = 0;
	RCALL SUBOPT_0xA
; 0001 0113 IndexPaketBayt = 0;
; 0001 0114 InfoBit = Neopredelen;
; 0001 0115 Paket = StartBit;
; 0001 0116 return;
	RJMP _0x2000001
; 0001 0117 }
_0x2002D:
; 0001 0118 InfoBit = Neopredelen;
	RCALL SUBOPT_0xD
; 0001 0119 // Преамбула найдена
; 0001 011A if (IndexBayt == 8)
	BRNE _0x2002E
; 0001 011B {
; 0001 011C IndexBayt = 0;
	LDI  R30,LOW(0)
	STS  _IndexBayt_S0010004000,R30
; 0001 011D Paket = Bit8_n;
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x4
; 0001 011E }
; 0001 011F }
_0x2002E:
_0x20026:
; 0001 0120 break;
	RJMP _0x20022
; 0001 0121 /*
; 0001 0122 Поиск всех остальных информационных битов пакета
; 0001 0123 Приём пользовательских данных
; 0001 0124 */
; 0001 0125 case Bit8_n:
_0x20023:
	CPI  R30,LOW(0x2)
	BREQ PC+2
	RJMP _0x20022
; 0001 0126 switch (InfoBit)
	LDS  R30,_InfoBit_S0010004000
; 0001 0127 {
; 0001 0128 case _0: case _1:
	CPI  R30,0
	BREQ _0x20034
	CPI  R30,LOW(0x1)
	BREQ PC+2
	RJMP _0x20032
_0x20034:
; 0001 0129 // Сохранить входной бит в буффере
; 0001 012A if (InfoBit == 1)
	LDS  R26,_InfoBit_S0010004000
	CPI  R26,LOW(0x1)
	BRNE _0x20036
; 0001 012B BIT_1(BaytIn,IndexBayt);
	RCALL SUBOPT_0xB
	LDI  R26,LOW(1)
	RCALL __LSLB12
	LDS  R26,_BaytIn_S0010004000
	OR   R30,R26
	RJMP _0x2003D
; 0001 012C else
_0x20036:
; 0001 012D BIT_0(BaytIn,IndexBayt);
	RCALL SUBOPT_0xB
	LDI  R26,LOW(1)
	RCALL __LSLB12
	COM  R30
	LDS  R26,_BaytIn_S0010004000
	AND  R30,R26
_0x2003D:
	STS  _BaytIn_S0010004000,R30
; 0001 012E ++IndexBayt;
	RCALL SUBOPT_0xC
; 0001 012F InfoBit = Neopredelen;
	RCALL SUBOPT_0xD
; 0001 0130 // Принят ещё 1 байт
; 0001 0131 if (IndexBayt == 8)
	BRNE _0x20038
; 0001 0132 {
; 0001 0133 IndexBayt = 0;
	LDI  R30,LOW(0)
	STS  _IndexBayt_S0010004000,R30
; 0001 0134 // Предыдущий пакет потерян
; 0001 0135 if (RadioPaketPrinyat == 1)
	LDS  R26,_RadioPaketPrinyat
	CPI  R26,LOW(0x1)
	BRNE _0x20039
; 0001 0136 {
; 0001 0137 RadioPaketOverflow = 1;
	LDI  R30,LOW(1)
	STS  _RadioPaketOverflow,R30
; 0001 0138 }
; 0001 0139 // Принят пользовательский байт
; 0001 013A if (IndexPaketBayt < RADIO_PAKET_DATA_BAYT_COUNT + 1)
_0x20039:
	LDS  R26,_IndexPaketBayt_S0010004000
	CPI  R26,LOW(0x6)
	BRSH _0x2003A
; 0001 013B {
; 0001 013C RadioPaketIn[IndexPaketBayt] = BaytIn; // Сохранить принятый байт в пакете
	LDS  R30,_IndexPaketBayt_S0010004000
	SUBI R30,-LOW(_RadioPaketIn)
	LDS  R26,_BaytIn_S0010004000
	STD  Z+0,R26
; 0001 013D ++IndexPaketBayt;
	LDS  R30,_IndexPaketBayt_S0010004000
	SUBI R30,-LOW(1)
	STS  _IndexPaketBayt_S0010004000,R30
; 0001 013E }
; 0001 013F // Приём всего пакета данных завершён
; 0001 0140 if (IndexPaketBayt == (RADIO_PAKET_DATA_BAYT_COUNT + 1))
_0x2003A:
	LDS  R26,_IndexPaketBayt_S0010004000
	CPI  R26,LOW(0x6)
	BRNE _0x2003B
; 0001 0141 {
; 0001 0142 // Проверка целостности пользовательских данных принятого пакета
; 0001 0143 if (RadioPaketIn[RADIO_PAKET_DATA_BAYT_COUNT] == CRC_8(RadioPaketIn, RADIO_PAKET ...
	LDI  R30,LOW(_RadioPaketIn)
	ST   -Y,R30
	LDI  R26,LOW(5)
	RCALL _CRC_8
	__GETB2MN _RadioPaketIn,5
	CP   R30,R26
	BRNE _0x2003C
; 0001 0144 RadioPaketPrinyat = 1; // Данные в целости
	LDI  R30,LOW(1)
	STS  _RadioPaketPrinyat,R30
; 0001 0145 // Начать поиск нового пакета
; 0001 0146 // Перезагрузка радио-приёма
; 0001 0147 PoluBit_A_Count1 = 0;
_0x2003C:
	RCALL SUBOPT_0x9
; 0001 0148 PoluBit_B_Count1 = 0;
; 0001 0149 IndexBayt = 0;
	RCALL SUBOPT_0xA
; 0001 014A IndexPaketBayt = 0;
; 0001 014B InfoBit = Neopredelen;
; 0001 014C Paket = StartBit;
; 0001 014D }
; 0001 014E }
_0x2003B:
; 0001 014F }
_0x20038:
_0x20032:
; 0001 0150 }
_0x20022:
; 0001 0151 }
_0x2000001:
	LD   R17,Y+
	RET
; .FEND

	.DSEG
_msLedG:
	.BYTE 0x1
_msLedB:
	.BYTE 0x1
_InSignal:
	.BYTE 0x1
_Paket:
	.BYTE 0x1
_RadioPaketIn:
	.BYTE 0x6
_InfoBit1TikTCNT:
	.BYTE 0x2
_RadioPaketPrinyat:
	.BYTE 0x1
_RadioPaketOverflow:
	.BYTE 0x1
_InfoBit_S0010004000:
	.BYTE 0x1
_PoluBit_A_Count1_S0010004000:
	.BYTE 0x2
_PoluBit_B_Count1_S0010004000:
	.BYTE 0x2
_IndexBayt_S0010004000:
	.BYTE 0x1
_IndexPaketBayt_S0010004000:
	.BYTE 0x1
_BaytIn_S0010004000:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x0:
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
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(0)
	OUT  0x32,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(0)
	OUT  0x2D,R30
	OUT  0x2C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3:
	IN   R30,0x32
	LDS  R26,_InfoBit1TikTCNT
	LDS  R27,_InfoBit1TikTCNT+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STS  _InfoBit1TikTCNT,R30
	STS  _InfoBit1TikTCNT+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	STS  _Paket,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(0)
	STS  _InfoBit1TikTCNT,R30
	STS  _InfoBit1TikTCNT+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6:
	STS  _InfoBit_S0010004000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDS  R30,_InfoBit1TikTCNT
	LDS  R31,_InfoBit1TikTCNT+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x8:
	LDS  R30,_PoluBit_B_Count1_S0010004000
	LDS  R31,_PoluBit_B_Count1_S0010004000+1
	LDS  R26,_PoluBit_A_Count1_S0010004000
	LDS  R27,_PoluBit_A_Count1_S0010004000+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(0)
	STS  _PoluBit_A_Count1_S0010004000,R30
	STS  _PoluBit_A_Count1_S0010004000+1,R30
	STS  _PoluBit_B_Count1_S0010004000,R30
	STS  _PoluBit_B_Count1_S0010004000+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(0)
	STS  _IndexBayt_S0010004000,R30
	STS  _IndexPaketBayt_S0010004000,R30
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x6
	LDI  R30,LOW(0)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	LDS  R30,_IndexBayt_S0010004000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	RCALL SUBOPT_0xB
	SUBI R30,-LOW(1)
	STS  _IndexBayt_S0010004000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x6
	LDS  R26,_IndexBayt_S0010004000
	CPI  R26,LOW(0x8)
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
