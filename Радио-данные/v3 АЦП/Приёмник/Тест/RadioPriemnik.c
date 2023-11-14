/*******************************************************
This program was created by the CodeWizardAVR V3.40 
Automatic Program Generator
© Copyright 1998-2020 Pavel Haiduc, HP InfoTech S.R.L.
http://www.hpinfotech.ro

Project : Радиоприёмник
Version : 3
Date    : 22.10.2023
Author  : Sergey
Company : 
Comments: 
					Микроконтроллер тактируется от
          кварцевого генератора частотой 4 МГц
          Радио данные поступают на вход ADC0 порт (PORTC) пин (0)
          2 светодиода
          LED Blue  - порт (PORTB) пин (2) - "Пакет принят"
          LED Red   - порт (PORTB) пин (1) - "Потеря предыдущего пакета"


Chip type               : ATmega8A
Program type            : Application
AVR Core Clock frequency: 4,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <mega8.h>
#include <RadioPriem.h>

// Voltage Reference AVCC pin
#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (1<<ADLAR))

volatile unsigned char msLedB = 0; // Переменная для подсчёта миллисекунд для LED Blue
volatile unsigned char msLedR = 0; // Переменная для подсчёта миллисекунд для LED Red


// Прерывание каждые 1 миллисекунду
// Timer2 output compare interrupt service routine
interrupt [TIM2_COMP] void timer2_comp_isr(void)
{
  if (msLedB != 0)
    --msLedB;	
	if (msLedR != 0)
    --msLedR;  
}


// ADC interrupt service routine
interrupt [ADC_INT] void adc_isr(void)
{
	RadioPriem();
}


void main(void)
{
	// Пользовательский пакет данных содержащий принятые по радио-каналу данные
	char RadioPaketData[RADIO_PAKET_DATA_BAYT_COUNT];
	char FlagOwerflow; // Пользовательский флаг потери предыдущего пакета

  // Input/Output Ports initialization
  // Port B initialization
  // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=Out Bit0=In 
  DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (1<<DDB2) | (1<<DDB1) | (0<<DDB0);
  // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=0 Bit1=0 Bit0=T 
  PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

  // Port C initialization
  // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
  DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
  // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
  PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

  // Port D initialization
  // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
  DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
  // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
  PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

	// Timer/Counter 0 initialization
	// Clock source: System Clock
	// Clock value: Timer 0 Stopped
	TCCR0=(0<<CS02) | (0<<CS01) | (0<<CS00);
	TCNT0=0x00;

	// Timer/Counter 1 initialization
	// Clock source: System Clock
	// Clock value: Timer1 Stopped
	// Mode: Normal top=0xFFFF
	// OC1A output: Disconnected
	// OC1B output: Disconnected
	// Noise Canceler: Off
	// Input Capture on Falling Edge
	// Timer1 Overflow Interrupt: Off
	// Input Capture Interrupt: Off
	// Compare A Match Interrupt: Off
	// Compare B Match Interrupt: Off
	TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	TCNT1H=0x00;
	TCNT1L=0x00;
	ICR1H=0x00;
	ICR1L=0x00;
	OCR1AH=0x00;
	OCR1AL=0x00;
	OCR1BH=0x00;
	OCR1BL=0x00;

	// Timer/Counter 2 initialization
	// Clock source: System Clock
	// Clock value: 125,000 kHz
	// Mode: CTC top=OCR2A
	// OC2 output: Disconnected
	// Timer Period: 1 ms
	ASSR=0<<AS2;
	TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (1<<CTC2) | (0<<CS22) | (1<<CS21) | (1<<CS20);
	TCNT2=0x00;
	OCR2=0x7C;

	// Timer(s)/Counter(s) Interrupt(s) initialization
	TIMSK=(1<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<TOIE0);

	// External Interrupt(s) initialization
	// INT0: Off
	// INT1: Off
	MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);

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

	// ADC initialization
	// ADC Clock frequency: 125,000 kHz
	// ADC Voltage Reference: AVCC pin
	ADMUX=ADC_VREF_TYPE;
	ADCSRA=(1<<ADEN) | (1<<ADSC) | (1<<ADFR) | (0<<ADIF) | (1<<ADIE) | (1<<ADPS2) | (0<<ADPS1) | (1<<ADPS0);
	//SFIOR=(0<<ACME);

	// SPI initialization
	// SPI disabled
	SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

	// TWI initialization
	// TWI disabled
	TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

	// Globally enable interrupts
	#asm("sei")

	while (1)
	{
		// Получение пакета данных, принятые по радио-каналу 
    if (RadioRead(RadioPaketData, &FlagOwerflow) == 1)
    {
    	if ( (RadioPaketData[0] == 11) && 
    			 (RadioPaketData[1] == 22) && 
    		   (RadioPaketData[2] == 33) && 
    		   (RadioPaketData[3] == 44) && 
    		   (RadioPaketData[4] == 55))
    	{	
    		msLedB = 150;    
		    PORTB.2 = 1; // Включить LED B
    	}
    	if (FlagOwerflow == 1)
    	{
    		msLedR = 150;
    		PORTB.1 = 1; // Включить LED R
    	}
    }            	
    if (msLedR == 0)
    	PORTB.1 = 0; // Выключить LED R
    if (msLedB == 0)
    	PORTB.2 = 0; // Выключить LED B	  	
	}
}
