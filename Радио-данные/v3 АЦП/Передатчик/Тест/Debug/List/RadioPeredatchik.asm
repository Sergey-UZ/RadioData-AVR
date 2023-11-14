
;CodeVisionAVR C Compiler V3.40 Advanced
;(C) Copyright 1998-2020 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro

;Build configuration    : Debug
;Chip type              : ATtiny45
;Program type           : Application
;Clock frequency        : 4,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 64 byte(s)
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

	#pragma AVRPART ADMIN PART_NAME ATtiny45
	#pragma AVRPART MEMORY PROG_FLASH 4096
	#pragma AVRPART MEMORY EEPROM 256
	#pragma AVRPART MEMORY INT_SRAM SIZE 256
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E

	.EQU WDTCR=0x21
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x11
	.EQU GPIOR1=0x12
	.EQU GPIOR2=0x13

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
	.EQU __SRAM_END=0x015F
	.EQU __DSTACK_SIZE=0x0040
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

_0x2001B:
	.DB  0x1

__GLOBAL_INI_TBL:
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
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0x00

	.DSEG
	.ORG 0xA0

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x18
	.EQU __sm_adc_noise_red=0x08
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x18
	.SET power_ctrl_reg=mcucr
	#endif
;const char TMR_SCHITAT_KNOPKU_NAZHATOY = 50;
;volatile unsigned char tmr_knopki;
;volatile unsigned char msLedR = 0;
;interrupt[TIM1_COMPA] void timer1_compa_isr(void);
;void main(void);
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 0030 {

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
; 0000 0031 RadioPeredacha();
	RCALL _RadioPeredacha
; 0000 0032 
; 0000 0033 //RadioPeredachaMeandr();
; 0000 0034 
; 0000 0035 if (tmr_knopki != 0)
	LDS  R30,_tmr_knopki
	CPI  R30,0
	BREQ _0x3
; 0000 0036 --tmr_knopki;
	LDS  R30,_tmr_knopki
	SUBI R30,LOW(1)
	STS  _tmr_knopki,R30
; 0000 0037 if (msLedR != 0)
_0x3:
	RCALL SUBOPT_0x0
	CPI  R30,0
	BREQ _0x4
; 0000 0038 --msLedR;
	RCALL SUBOPT_0x0
	SUBI R30,LOW(1)
	STS  _msLedR,R30
; 0000 0039 }
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
; 0000 003C {
_main:
; .FSTART _main
; 0000 003D // Пользовательский пакет данных для отправки по радио-каналу
; 0000 003E char RadioPaketData[RADIO_PAKET_DATA_BAYT_COUNT];
; 0000 003F // Флаг для кнопки
; 0000 0040 char FlagKnopkaNazhata = 0;
; 0000 0041 
; 0000 0042 // Crystal Oscillator division factor: 1
; 0000 0043 #pragma optsize-
; 0000 0044 CLKPR=(1<<CLKPCE);
	SBIW R28,5
;	RadioPaketData -> Y+0
;	FlagKnopkaNazhata -> R17
	LDI  R17,0
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 0045 CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 0046 #ifdef _OPTIMIZE_SIZE_
; 0000 0047 #pragma optsize+
; 0000 0048 #endif
; 0000 0049 
; 0000 004A // Input/Output Ports initialization
; 0000 004B // Port B initialization
; 0000 004C // Function: Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=In Bit0=Out
; 0000 004D DDRB=(0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (1<<DDB2) | (0<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(5)
	OUT  0x17,R30
; 0000 004E // State: Bit5=T Bit4=T Bit3=T Bit2=0 Bit1=P Bit0=0
; 0000 004F PORTB=(0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (1<<PORTB1) | (0<< ...
	LDI  R30,LOW(2)
	OUT  0x18,R30
; 0000 0050 
; 0000 0051 // Timer/Counter 0 initialization
; 0000 0052 // Clock source: System Clock
; 0000 0053 // Clock value: Timer 0 Stopped
; 0000 0054 // Mode: Normal top=0xFF
; 0000 0055 // OC0A output: Disconnected
; 0000 0056 // OC0B output: Disconnected
; 0000 0057 TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<< ...
	LDI  R30,LOW(0)
	OUT  0x2A,R30
; 0000 0058 TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 0059 TCNT0=0x00;
	OUT  0x32,R30
; 0000 005A OCR0A=0x00;
	OUT  0x29,R30
; 0000 005B OCR0B=0x00;
	OUT  0x28,R30
; 0000 005C 
; 0000 005D // Timer/Counter 1 initialization
; 0000 005E // Clock source: System Clock
; 0000 005F // Clock value: 125,000 kHz
; 0000 0060 // Mode: CTC top=OCR1C
; 0000 0061 // OC1A output: Disconnected
; 0000 0062 // OC1B output: Disconnected
; 0000 0063 // Timer Period: 1,04 ms
; 0000 0064 // Timer1 Overflow Interrupt: Off
; 0000 0065 // Compare A Match Interrupt: On
; 0000 0066 // Compare B Match Interrupt: Off
; 0000 0067 PLLCSR=(0<<PCKE) | (0<<PLLE) | (0<<PLOCK);
	OUT  0x27,R30
; 0000 0068 
; 0000 0069 TCCR1=(1<<CTC1) | (0<<PWM1A) | (0<<COM1A1) | (0<<COM1A0) | (0<<CS13) | (1<<CS12) ...
	LDI  R30,LOW(134)
	OUT  0x30,R30
; 0000 006A GTCCR=(0<<TSM) | (0<<PWM1B) | (0<<COM1B1) | (0<<COM1B0) | (0<<PSR1) | (0<<PSR0);
	LDI  R30,LOW(0)
	OUT  0x2C,R30
; 0000 006B TCNT1=0x00;
	OUT  0x2F,R30
; 0000 006C OCR1A=0x00;
	OUT  0x2E,R30
; 0000 006D OCR1B=0x00;
	OUT  0x2B,R30
; 0000 006E OCR1C=0x81;
	LDI  R30,LOW(129)
	OUT  0x2D,R30
; 0000 006F 
; 0000 0070 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0071 TIMSK=(1<<OCIE1A) | (0<<OCIE1B) | (0<<OCIE0A) | (0<<OCIE0B) | (0<<TOIE1) | (0<<T ...
	LDI  R30,LOW(64)
	OUT  0x39,R30
; 0000 0072 
; 0000 0073 // External Interrupt(s) initialization
; 0000 0074 // INT0: Off
; 0000 0075 // Interrupt on any change on pins PCINT0-5: Off
; 0000 0076 GIMSK=(0<<INT0) | (0<<PCIE);
	LDI  R30,LOW(0)
	OUT  0x3B,R30
; 0000 0077 MCUCR=(0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 0078 
; 0000 0079 // USI initialization
; 0000 007A // Mode: Disabled
; 0000 007B // Clock source: Register & Counter=no clk.
; 0000 007C // USI Counter Overflow Interrupt: Off
; 0000 007D USICR=(0<<USISIE) | (0<<USIOIE) | (0<<USIWM1) | (0<<USIWM0) | (0<<USICS1) | (0<< ...
	OUT  0xD,R30
; 0000 007E 
; 0000 007F // Analog Comparator initialization
; 0000 0080 // Analog Comparator: Off
; 0000 0081 // The Analog Comparator's positive input is
; 0000 0082 // connected to the AIN0 pin
; 0000 0083 // The Analog Comparator's negative input is
; 0000 0084 // connected to the AIN1 pin
; 0000 0085 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIS1) | (0<<A ...
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0086 ADCSRB=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 0087 // Digital input buffer on AIN0: On
; 0000 0088 // Digital input buffer on AIN1: On
; 0000 0089 DIDR0=(0<<AIN0D) | (0<<AIN1D);
	OUT  0x14,R30
; 0000 008A 
; 0000 008B // ADC initialization
; 0000 008C // ADC disabled
; 0000 008D ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | ...
	OUT  0x6,R30
; 0000 008E 
; 0000 008F // Заполнение пользовательских данных
; 0000 0090 RadioPaketData[0] = 11;
	LDI  R30,LOW(11)
	ST   Y,R30
; 0000 0091 RadioPaketData[1] = 22;
	LDI  R30,LOW(22)
	STD  Y+1,R30
; 0000 0092 RadioPaketData[2] = 33;
	LDI  R30,LOW(33)
	STD  Y+2,R30
; 0000 0093 RadioPaketData[3] = 44;
	LDI  R30,LOW(44)
	STD  Y+3,R30
; 0000 0094 RadioPaketData[4] = 55;
	LDI  R30,LOW(55)
	STD  Y+4,R30
; 0000 0095 
; 0000 0096 // Globally enable interrupts
; 0000 0097 #asm("sei")
	SEI
; 0000 0098 
; 0000 0099 while (1)
_0x5:
; 0000 009A {
; 0000 009B // Определяет состояние кнопки (нажата она или нет)
; 0000 009C if (BIT_RAVEN_0(PINB, 1))
	SBIC 0x16,1
	RJMP _0x8
; 0000 009D {
; 0000 009E //Начать отсчёт общего времени нажатия на кнопку
; 0000 009F //Запустить програмный таймер отсчёта времени нажатия на кнопку
; 0000 00A0 tmr_knopki = TMR_SCHITAT_KNOPKU_NAZHATOY;
	LDI  R30,LOW(50)
	STS  _tmr_knopki,R30
; 0000 00A1 //Пока кнопка нажата
; 0000 00A2 while (BIT_RAVEN_0(PINB, 1))
_0x9:
	SBIC 0x16,1
	RJMP _0xB
; 0000 00A3 {
; 0000 00A4 //Если кнопка была нажата положеное время, тогда
; 0000 00A5 if (tmr_knopki == 0)
	LDS  R30,_tmr_knopki
	CPI  R30,0
	BRNE _0xC
; 0000 00A6 {
; 0000 00A7 if (FlagKnopkaNazhata == 0)
	CPI  R17,0
	BRNE _0xD
; 0000 00A8 {
; 0000 00A9 FlagKnopkaNazhata = 1;
	LDI  R17,LOW(1)
; 0000 00AA if (RadioWrite(RadioPaketData) == 1)
	MOVW R26,R28
	RCALL _RadioWrite
	CPI  R30,LOW(0x1)
	BRNE _0xE
; 0000 00AB {
; 0000 00AC msLedR = 150;
	LDI  R30,LOW(150)
	STS  _msLedR,R30
; 0000 00AD PORTB.0 = 1;
	SBI  0x18,0
; 0000 00AE }
; 0000 00AF }
_0xE:
; 0000 00B0 }
_0xD:
; 0000 00B1 if (msLedR == 0)
_0xC:
	RCALL SUBOPT_0x0
	CPI  R30,0
	BRNE _0x11
; 0000 00B2 PORTB.0 = 0;
	CBI  0x18,0
; 0000 00B3 }
_0x11:
	RJMP _0x9
_0xB:
; 0000 00B4 FlagKnopkaNazhata = 0;
	LDI  R17,LOW(0)
; 0000 00B5 }
; 0000 00B6 if (msLedR == 0)
_0x8:
	RCALL SUBOPT_0x0
	CPI  R30,0
	BRNE _0x14
; 0000 00B7 PORTB.0 = 0;
	CBI  0x18,0
; 0000 00B8 }
_0x14:
	RJMP _0x5
; 0000 00B9 }
_0x17:
	RJMP _0x17
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x18
	.EQU __sm_adc_noise_red=0x08
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x18
	.SET power_ctrl_reg=mcucr
	#endif
;volatile char RadioPaketOut[RADIO_PAKET_DATA_BAYT_COUNT + 2];
;volatile char RadioPaketPeredacha = 0;
;char CRC_8(char *Data, unsigned char Length_Data)
; 0001 0022 {

	.CSEG
_CRC_8:
; .FSTART _CRC_8
; 0001 0023 char Registr_CRC = 0xFF; // Начальное значение регистра CRC
; 0001 0024 unsigned char i; // Индексная переменная
; 0001 0025 
; 0001 0026 while (Length_Data--)  //Вычислить CRC для блока данных
	RCALL __SAVELOCR6
	MOV  R19,R26
	__GETWRS 20,21,6
;	*Data -> R20,R21
;	Length_Data -> R19
;	Registr_CRC -> R17
;	i -> R16
	LDI  R17,255
_0x20003:
	MOV  R30,R19
	SUBI R19,1
	CPI  R30,0
	BREQ _0x20005
; 0001 0027 {
; 0001 0028 Registr_CRC ^= *Data++;
	MOVW R26,R20
	__ADDWRN 20,21,1
	LD   R30,X
	EOR  R17,R30
; 0001 0029 for (i = 0; i < 8; i++)
	LDI  R16,LOW(0)
_0x20007:
	CPI  R16,8
	BRSH _0x20008
; 0001 002A {
; 0001 002B Registr_CRC >>= 1;
	LSR  R17
; 0001 002C if ( (Registr_CRC & 0b00000001) != 0 )
	SBRS R17,0
	RJMP _0x20009
; 0001 002D Registr_CRC ^= 0x31;
	LDI  R30,LOW(49)
	EOR  R17,R30
; 0001 002E }
_0x20009:
	SUBI R16,-1
	RJMP _0x20007
_0x20008:
; 0001 002F }
	RJMP _0x20003
_0x20005:
; 0001 0030 return Registr_CRC;
	MOV  R30,R17
	RCALL __LOADLOCR6
	ADIW R28,8
	RET
; 0001 0031 }
; .FEND
;char RadioWrite (char *Data)
; 0001 0040 {
_RadioWrite:
; .FSTART _RadioWrite
; 0001 0041 unsigned char i; // Индексная переменная
; 0001 0042 
; 0001 0043 // Если радио-передатчик свободен
; 0001 0044 if (RadioPaketPeredacha == 0)
	RCALL __SAVELOCR4
	MOVW R18,R26
;	*Data -> R18,R19
;	i -> R17
	LDS  R30,_RadioPaketPeredacha
	CPI  R30,0
	BRNE _0x2000A
; 0001 0045 {
; 0001 0046 // Заполнение служебного пакета данными
; 0001 0047 RadioPaketOut[0] = PREAMBULA;
	LDI  R30,LOW(85)
	STS  _RadioPaketOut,R30
; 0001 0048 for (i = 0; i < RADIO_PAKET_DATA_BAYT_COUNT; i++)
	LDI  R17,LOW(0)
_0x2000C:
	CPI  R17,5
	BRSH _0x2000D
; 0001 0049 RadioPaketOut[i+1] = Data[i];
	MOV  R30,R17
	LDI  R31,0
	__ADDW1MN _RadioPaketOut,1
	MOVW R0,R30
	MOVW R26,R18
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	SUBI R17,-1
	RJMP _0x2000C
_0x2000D:
; 0001 004A RadioPaketOut[5 + 1] = CRC_8(Data, 5);
	ST   -Y,R19
	ST   -Y,R18
	LDI  R26,LOW(5)
	RCALL _CRC_8
	__PUTB1MN _RadioPaketOut,6
; 0001 004B RadioPaketPeredacha = 1; // Разрешить передачу данных по радио-каналу
	LDI  R30,LOW(1)
	STS  _RadioPaketPeredacha,R30
; 0001 004C return 1;
	RJMP _0x2000001
; 0001 004D }
; 0001 004E else
_0x2000A:
; 0001 004F return 0;
	LDI  R30,LOW(0)
; 0001 0050 }
_0x2000001:
	RCALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
;void RadioPeredacha(void)
; 0001 0055 {
_RadioPeredacha:
; .FSTART _RadioPeredacha
; 0001 0056 static unsigned char IndexBayt = 0; // Индекс байта
; 0001 0057 static unsigned char IndexPaketBayt = 0; // Индекс пакета байтов
; 0001 0058 static char Bit1, Bit0 = 0;
; 0001 0059 static char StartBit = 0; // Для передачи 1-ного стартового бита
; 0001 005A /*
; 0001 005B После выставления последнего выходного сигнала
; 0001 005C отсчитать один периуд и завершить передачу
; 0001 005D */
; 0001 005E static char FlagPeriudPoslednegoBita = 0;
; 0001 005F 
; 0001 0060 // Есть данные для передачи по радио-каналу
; 0001 0061 if (RadioPaketPeredacha == 1)
	LDS  R26,_RadioPaketPeredacha
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0x2000F
; 0001 0062 {
; 0001 0063 if (FlagPeriudPoslednegoBita == 0)
	LDS  R30,_FlagPeriudPoslednegoBita_S0010002000
	CPI  R30,0
	BREQ PC+2
	RJMP _0x20010
; 0001 0064 {
; 0001 0065 // Передача стартового бита
; 0001 0066 if (StartBit == 0)
	LDS  R30,_StartBit_S0010002000
	CPI  R30,0
	BRNE _0x20011
; 0001 0067 {
; 0001 0068 StartBit = 1;
	LDI  R30,LOW(1)
	STS  _StartBit_S0010002000,R30
; 0001 0069 BIT_1(RADIO_SIGNAL_OUT_PORTX, RADIO_SIGNAL_OUT_PIN);
	SBI  0x18,2
; 0001 006A return;
	RET
; 0001 006B }
; 0001 006C // Передача 1 байта данных (манчестерское кодирование)
; 0001 006D if (BIT_RAVEN_0 (RadioPaketOut[IndexPaketBayt], IndexBayt))
_0x20011:
	LDS  R30,_IndexPaketBayt_S0010002000
	LDI  R31,0
	SUBI R30,LOW(-_RadioPaketOut)
	SBCI R31,HIGH(-_RadioPaketOut)
	LD   R1,Z
	LDS  R30,_IndexBayt_S0010002000
	LDI  R26,LOW(1)
	RCALL __LSLB12
	AND  R30,R1
	BRNE _0x20012
; 0001 006E {
; 0001 006F // Выходной бит данных 0 --- передаётся как сначало 0 потом 1
; 0001 0070 if (Bit0 == 0)
	LDS  R30,_Bit0_S0010002000
	CPI  R30,0
	BRNE _0x20013
; 0001 0071 {
; 0001 0072 BIT_0(RADIO_SIGNAL_OUT_PORTX, RADIO_SIGNAL_OUT_PIN);
	CBI  0x18,2
; 0001 0073 Bit0 = 1;
	LDI  R30,LOW(1)
	STS  _Bit0_S0010002000,R30
; 0001 0074 }
; 0001 0075 else
	RJMP _0x20014
_0x20013:
; 0001 0076 {
; 0001 0077 BIT_1(RADIO_SIGNAL_OUT_PORTX, RADIO_SIGNAL_OUT_PIN);
	SBI  0x18,2
; 0001 0078 Bit0 = 0;
	LDI  R30,LOW(0)
	STS  _Bit0_S0010002000,R30
; 0001 0079 ++IndexBayt;
	RCALL SUBOPT_0x1
; 0001 007A }
_0x20014:
; 0001 007B }
; 0001 007C else // Выходной бит данных 1 --- передаётся как сначало 1 потом 0
	RJMP _0x20015
_0x20012:
; 0001 007D {
; 0001 007E if (Bit1 == 0)
	LDS  R30,_Bit1_S0010002000
	CPI  R30,0
	BRNE _0x20016
; 0001 007F {
; 0001 0080 BIT_1(RADIO_SIGNAL_OUT_PORTX, RADIO_SIGNAL_OUT_PIN);
	SBI  0x18,2
; 0001 0081 Bit1 = 1;
	LDI  R30,LOW(1)
	STS  _Bit1_S0010002000,R30
; 0001 0082 }
; 0001 0083 else
	RJMP _0x20017
_0x20016:
; 0001 0084 {
; 0001 0085 BIT_0(RADIO_SIGNAL_OUT_PORTX, RADIO_SIGNAL_OUT_PIN);
	CBI  0x18,2
; 0001 0086 Bit1 = 0;
	LDI  R30,LOW(0)
	STS  _Bit1_S0010002000,R30
; 0001 0087 ++IndexBayt;
	RCALL SUBOPT_0x1
; 0001 0088 }
_0x20017:
; 0001 0089 }
_0x20015:
; 0001 008A // Отправлен ещё 1 байт данных
; 0001 008B if (IndexBayt == 8)
	LDS  R26,_IndexBayt_S0010002000
	CPI  R26,LOW(0x8)
	BRNE _0x20018
; 0001 008C {
; 0001 008D IndexBayt = 0;
	LDI  R30,LOW(0)
	STS  _IndexBayt_S0010002000,R30
; 0001 008E ++IndexPaketBayt;
	LDS  R30,_IndexPaketBayt_S0010002000
	SUBI R30,-LOW(1)
	STS  _IndexPaketBayt_S0010002000,R30
; 0001 008F // Передача всего пакета данных завершена
; 0001 0090 if (IndexPaketBayt == (RADIO_PAKET_DATA_BAYT_COUNT + 2))
	LDS  R26,_IndexPaketBayt_S0010002000
	CPI  R26,LOW(0x7)
	BRNE _0x20019
; 0001 0091 {
; 0001 0092 // Остался последний периуд
; 0001 0093 IndexPaketBayt = 0;
	LDI  R30,LOW(0)
	STS  _IndexPaketBayt_S0010002000,R30
; 0001 0094 FlagPeriudPoslednegoBita = 1;
	LDI  R30,LOW(1)
	STS  _FlagPeriudPoslednegoBita_S0010002000,R30
; 0001 0095 }
; 0001 0096 }
_0x20019:
; 0001 0097 }
_0x20018:
; 0001 0098 else // Передача завершена
	RJMP _0x2001A
_0x20010:
; 0001 0099 {
; 0001 009A FlagPeriudPoslednegoBita = 0;
	LDI  R30,LOW(0)
	STS  _FlagPeriudPoslednegoBita_S0010002000,R30
; 0001 009B StartBit = 0;
	STS  _StartBit_S0010002000,R30
; 0001 009C BIT_0(RADIO_SIGNAL_OUT_PORTX, RADIO_SIGNAL_OUT_PIN);
	CBI  0x18,2
; 0001 009D RadioPaketPeredacha = 0;
	STS  _RadioPaketPeredacha,R30
; 0001 009E }
_0x2001A:
; 0001 009F }
; 0001 00A0 }
_0x2000F:
	RET
; .FEND
;void RadioPeredachaMeandr (void)
; 0001 00A5 {
; 0001 00A6 static char BitOut = 1;

	.DSEG

	.CSEG
; 0001 00A7 
; 0001 00A8 if (BitOut == 1)
; 0001 00A9 {
; 0001 00AA BIT_1(RADIO_SIGNAL_OUT_PORTX, RADIO_SIGNAL_OUT_PIN);
; 0001 00AB BitOut = 0;
; 0001 00AC }
; 0001 00AD else
; 0001 00AE {
; 0001 00AF BIT_0(RADIO_SIGNAL_OUT_PORTX, RADIO_SIGNAL_OUT_PIN);
; 0001 00B0 BitOut = 1;
; 0001 00B1 }
; 0001 00B2 }

	.DSEG
_tmr_knopki:
	.BYTE 0x1
_msLedR:
	.BYTE 0x1
_RadioPaketOut:
	.BYTE 0x7
_RadioPaketPeredacha:
	.BYTE 0x1
_IndexBayt_S0010002000:
	.BYTE 0x1
_IndexPaketBayt_S0010002000:
	.BYTE 0x1
_Bit1_S0010002000:
	.BYTE 0x1
_Bit0_S0010002000:
	.BYTE 0x1
_StartBit_S0010002000:
	.BYTE 0x1
_FlagPeriudPoslednegoBita_S0010002000:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDS  R30,_msLedR
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	LDS  R30,_IndexBayt_S0010002000
	SUBI R30,-LOW(1)
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
