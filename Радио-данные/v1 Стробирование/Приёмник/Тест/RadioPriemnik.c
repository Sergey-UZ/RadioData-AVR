/*******************************************************
This program was created by the CodeWizardAVR V3.40 
Automatic Program Generator
� Copyright 1998-2020 Pavel Haiduc, HP InfoTech S.R.L.
http://www.hpinfotech.ro

Project : ���� ������ �� �����-������
Version : 1
Date    : 16.10.2023
Author  : Sergey
Company : 
Comments: 
          ��������������� ����������� ��
          ���������� ���������� �������� 4 ���
          ����� ������ ��������� �� ���� ���� (PORTD) ��� (3)
          2 ����������
          LED Blue  - ���� (PORTB) ��� (3) - "����� ������"
          LED Green - ���� (PORTB) ��� (2) - "������ ����������� ������"

Chip type               : ATtiny2313A
AVR Core Clock frequency: 4,000000 MHz
Memory model            : Tiny
External RAM size       : 0
Data Stack size         : 32
*******************************************************/

#include <tiny2313a.h>
#include <RadioPriem.h>
 
volatile unsigned char msLedG = 0; // ���������� ��� �������� ����������� ��� LED Green
volatile unsigned char msLedB = 0; // ���������� ��� �������� ����������� ��� LED Blue 

// ��������� ������� ===============================
interrupt [TIM1_COMPA] void timer1_compa_isr(void);
void main(void);
//==================================================


// Timer1 output compare A interrupt service routine
// ���������� ������ 0,125 ms
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
	static unsigned char Periud_1ms = 8;
	
	RadioPriem();
	
	if (Periud_1ms != 0)
	{
		--Periud_1ms;
		// ������ ������ 1��		
  	if (Periud_1ms == 0)
		{
			Periud_1ms = 8;
		  if (msLedG != 0)
		    --msLedG;  
		  if (msLedB != 0)
		    --msLedB;	
		}	
	}
}


void main(void)
{
	// ���������������� ����� ������ ���������� �������� �� �����-������ ������
	char RadioPaketData[RADIO_PAKET_DATA_BAYT_COUNT];
	char FlagOwerflow; // ���������������� ���� ������ ����������� ������
	// Crystal Oscillator division factor: 1
	#pragma optsize-
		CLKPR=(1<<CLKPCE);
		CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	#ifdef _OPTIMIZE_SIZE_
	#pragma optsize+
	#endif
  
  // Input/Output Ports initialization
  // Port A initialization
  // Function: Bit2=In Bit1=In Bit0=In 
  DDRA=(0<<DDA2) | (0<<DDA1) | (0<<DDA0);
  // State: Bit2=T Bit1=T Bit0=T 
  PORTA=(0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

  // Port B initialization
  // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=Out Bit1=In Bit0=In 
  DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (1<<DDB3) | (1<<DDB2) | (0<<DDB1) | (0<<DDB0);
  // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=0 Bit2=0 Bit1=T Bit0=T 
  PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

  // Port D initialization
  // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
  DDRD=(0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
  // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
  PORTD=(0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

	// Timer/Counter 0 initialization
	// Clock source: System Clock
	// Clock value: Timer 0 Stopped
	// Mode: Normal top=0xFF
	// OC0A output: Disconnected
	// OC0B output: Disconnected
	TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
	TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	TCNT0=0x00;
	OCR0A=0x00;
	OCR0B=0x00;

	// Timer/Counter 1 initialization
	// Clock source: System Clock
	// Clock value: 4000,000 kHz
	// Mode: CTC top=OCR1A
	// OC1A output: Disconnected
	// OC1B output: Disconnected
	// Noise Canceler: Off
	// Input Capture on Falling Edge
	// Timer Period: 0,125 ms
	// Timer1 Overflow Interrupt: Off
	// Input Capture Interrupt: Off
	// Compare A Match Interrupt: On
	// Compare B Match Interrupt: Off
	TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
	TCNT1H=0x00;
	TCNT1L=0x00;
	ICR1H=0x00;
	ICR1L=0x00;
	OCR1AH=0x01;
	OCR1AL=0xF3;
	OCR1BH=0x00;
	OCR1BL=0x00;

	// Timer(s)/Counter(s) Interrupt(s) initialization
	TIMSK=(0<<TOIE1) | (1<<OCIE1A) | (0<<OCIE1B) | (0<<ICIE1) | (0<<OCIE0B) | (0<<TOIE0) | (0<<OCIE0A);

	// External Interrupt(s) initialization
	// INT0: Off
	// INT1: Off
	// Interrupt on any change on pins PCINT0-7: Off
	// Interrupt on any change on pins PCINT8-10: Off
	// Interrupt on any change on pins PCINT11-17: Off
	MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	GIMSK=(0<<INT1) | (0<<INT0) | (0<<PCIE0) | (0<<PCIE2) | (0<<PCIE1);

	// USI initialization
	// Mode: Disabled
	// Clock source: Register & Counter=no clk.
	// USI Counter Overflow Interrupt: Off
	USICR=(0<<USISIE) | (0<<USIOIE) | (0<<USIWM1) | (0<<USIWM0) | (0<<USICS1) | (0<<USICS0) | (0<<USICLK) | (0<<USITC);

	// USART initialization
	// USART disabled
	UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

	// Analog Comparator initialization
	// Analog Comparator: Off
	// The Analog Comparator's positive input is
	// connected to the AIN0 pin
	// The Analog Comparator's negative input is
	// connected to the AIN1 pin
	ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	// Digital input buffer on AIN0: On
	// Digital input buffer on AIN1: On
	DIDR=(0<<AIN0D) | (0<<AIN1D);


	// Globally enable interrupts
	#asm("sei")

	while (1)
  {
  	// ��������� ������ ������, �������� �� �����-������ 
    if (RadioRead(RadioPaketData, &FlagOwerflow) == 1)
    {
    	if ( (RadioPaketData[0] == 11) && 
    			 (RadioPaketData[1] == 22) && 
    		   (RadioPaketData[2] == 33) && 
    		   (RadioPaketData[3] == 44) && 
    		   (RadioPaketData[4] == 55))
    	{	
    		msLedB = 150;    
		    PORTB.3 = 1; // �������� LED B
    	}
    	if (FlagOwerflow == 1)
    	{
    		msLedG = 150;
    		PORTB.2 = 1; // �������� LED G
    	}
    }            	
    if (msLedG == 0)
    	PORTB.2 = 0; // ��������� LED G
    if (msLedB == 0)
    	PORTB.3 = 0; // ��������� LED B	  	
  }
}
