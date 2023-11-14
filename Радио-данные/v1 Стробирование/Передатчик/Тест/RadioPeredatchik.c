/*******************************************************
This program was created by the CodeWizardAVR V3.40 
Automatic Program Generator
© Copyright 1998-2020 Pavel Haiduc, HP InfoTech S.R.L.
http://www.hpinfotech.ro

Project : Радио-передатчик
Version : 1
Date    : 12.10.2023
Author  : Sergey
Company : 
Comments: 
          Микроконтроллер тактируется от
          кварцевого генератора частотой 4 МГц
          Выходной сигнал для радио-передатчика
          	выдаётся на         порт (PORTB) пин (2)
          Кнопка подключена   к порт (PORTB) пин (1)
          Светодиод подключён к порт (PORTB) пин (0)

Chip type               : ATtiny45
AVR Core Clock frequency: 4,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 64
*******************************************************/

#include <tiny45.h>
#include <RadioPeredacha.h>

#define BIT_RAVEN_0(chislo, poziciya)  (((chislo) & (1 << (poziciya))) == 0)
//Считать кнопку нажатой если на неё нажимали в течении (время в миллисекундах)
const char TMR_SCHITAT_KNOPKU_NAZHATOY = 50;

//Програмного таймера (время в миллисекундах) для определения длительности нажатия на кнопку
volatile unsigned char tmr_knopki;
// Переменная для подсчёта миллисекунд для LED Red
volatile unsigned char msLedR = 0; 

// прототипы функций ===================================
interrupt[TIM1_COMPA] void timer1_compa_isr(void);
void main(void);
//=====================================================


// Timer1 output compare A interrupt service routine
// Прерывание каждые 1 мс (синхронизация для передачи данных по радио каналу)
interrupt[TIM1_COMPA] void timer1_compa_isr(void)
{
	RadioPeredacha();
	
	//RadioPeredachaMeandr();
	
  if (tmr_knopki != 0)
    --tmr_knopki;
  if (msLedR != 0)
    --msLedR;  
}


void main(void)
{
	// Пользовательский пакет данных для отправки по радио-каналу
	char RadioPaketData[RADIO_PAKET_DATA_BAYT_COUNT];
	// Флаг для кнопки
	char FlagKnopkaNazhata = 0;
	// Crystal Oscillator division factor: 1
	#pragma optsize-
		CLKPR=(1<<CLKPCE);
		CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	#ifdef _OPTIMIZE_SIZE_
	#pragma optsize+
	#endif

	// Input/Output Ports initialization
	// Port B initialization
	// Function: Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=In Bit0=Out 
	DDRB=(0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (1<<DDB2) | (0<<DDB1) | (1<<DDB0);
	// State: Bit5=T Bit4=T Bit3=T Bit2=0 Bit1=P Bit0=0 
	PORTB=(0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (1<<PORTB1) | (0<<PORTB0);

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
	// Clock value: 250,000 kHz
	// Mode: CTC top=OCR1C
	// OC1A output: Disconnected
	// OC1B output: Disconnected
	// Timer Period: 1 ms
	// Timer1 Overflow Interrupt: Off
	// Compare A Match Interrupt: On
	// Compare B Match Interrupt: Off
	PLLCSR=(0<<PCKE) | (0<<PLLE) | (0<<PLOCK);

	TCCR1=(1<<CTC1) | (0<<PWM1A) | (0<<COM1A1) | (0<<COM1A0) | (0<<CS13) | (1<<CS12) | (0<<CS11) | (1<<CS10);
	GTCCR=(0<<TSM) | (0<<PWM1B) | (0<<COM1B1) | (0<<COM1B0) | (0<<PSR1) | (0<<PSR0);
	TCNT1=0x00;
	OCR1A=0x00;
	OCR1B=0x00;
	OCR1C=0xF9;

	// Timer(s)/Counter(s) Interrupt(s) initialization
	TIMSK=(1<<OCIE1A) | (0<<OCIE1B) | (0<<OCIE0A) | (0<<OCIE0B) | (0<<TOIE1) | (0<<TOIE0);

	// External Interrupt(s) initialization
	// INT0: Off
	// Interrupt on any change on pins PCINT0-5: Off
	GIMSK=(0<<INT0) | (0<<PCIE);
	MCUCR=(0<<ISC01) | (0<<ISC00);

	// USI initialization
	// Mode: Disabled
	// Clock source: Register & Counter=no clk.
	// USI Counter Overflow Interrupt: Off
	USICR=(0<<USISIE) | (0<<USIOIE) | (0<<USIWM1) | (0<<USIWM0) | (0<<USICS1) | (0<<USICS0) | (0<<USICLK) | (0<<USITC);

	// Analog Comparator initialization
	// Analog Comparator: Off
	// The Analog Comparator's positive input is
	// connected to the AIN0 pin
	// The Analog Comparator's negative input is
	// connected to the AIN1 pin
	ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIS1) | (0<<ACIS0);
	ADCSRB=(0<<ACME);
	// Digital input buffer on AIN0: On
	// Digital input buffer on AIN1: On
	DIDR0=(0<<AIN0D) | (0<<AIN1D);

  // ADC initialization
  // ADC disabled
  ADCSRA = (0 << ADEN) | (0 << ADSC) | (0 << ADATE) | (0 << ADIF) | (0 << ADIE) | (0 << ADPS2) | (0 << ADPS1) | (0 << ADPS0);
	
	// Заполнение пользовательских данных    
	RadioPaketData[0] = 11;
	RadioPaketData[1] = 22;
	RadioPaketData[2] = 33;
	RadioPaketData[3] = 44;
	RadioPaketData[4] = 55;
		
	// Globally enable interrupts
	#asm("sei")
	
  while (1)
  {
  	// Определяет состояние кнопки (нажата она или нет)
  	if (BIT_RAVEN_0(PINB, 1))
  	{
  		//Начать отсчёт общего времени нажатия на кнопку
      //Запустить програмный таймер отсчёта времени нажатия на кнопку
  		tmr_knopki = TMR_SCHITAT_KNOPKU_NAZHATOY;
  		//Пока кнопка нажата
  		while (BIT_RAVEN_0(PINB, 1))
  		{
  			//Если кнопка была нажата положеное время, тогда
  			if (tmr_knopki == 0)
  			{
  				if (FlagKnopkaNazhata == 0)
					{
						FlagKnopkaNazhata = 1;
						if (RadioWrite(RadioPaketData) == 1)
				  	{
				  		msLedR = 150;
				      PORTB.0 = 1;
				  	}
					}
  			}
  		if (msLedR == 0)   
      	PORTB.0 = 0; 
  		}  		 		
  	FlagKnopkaNazhata = 0;
  	} 	
    if (msLedR == 0)   
      PORTB.0 = 0;   
  }
}
