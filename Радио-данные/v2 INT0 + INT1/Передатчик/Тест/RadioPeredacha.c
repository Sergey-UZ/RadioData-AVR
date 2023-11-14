#include "RadioPeredacha.h"

// Макроопределения ==============================================================
#define BIT_1(chislo, poziciya)          (chislo) |=   (1 << (poziciya))            
#define BIT_0(chislo, poziciya)          (chislo) &= (~(1 << (poziciya)))
#define BIT_RAVEN_0(chislo, poziciya)  (((chislo) &    (1 << (poziciya))) == 0)
// Преамбула передатчика
#define PREAMBULA 0b01010101
//================================================================================

// Переменные =====================================================================================
// Служебный пакет данных для отправки по радио-каналу
volatile char RadioPaketOut[RADIO_PAKET_DATA_BAYT_COUNT + 2];
/* Флаг передачи пакета по радио-каналу
   Флаг устанавливается в 1 перед началом новой передачи данных
   Сбрасывается флаг в 0 при завершении передачи  
*/
volatile char RadioPaketPeredacha = 0;

// Реализация функций =============================================================================


/* 
   Функция вычисления CRC-8
   Параметры:
    Используемый полином = x^8 + x^5 + x^4 + 1 = 0x31 
    Начальное значение регистра CRC = 0xFF 
    char *Data - Указатель на массив данных для которых вычисляется их CRC
    unsigned char Length_Data - Указать нужное колличество байт массива данных для которых вычисляется CRC
   Возвращаемое значение:
    char - CRC-8 
 */
char CRC_8(char *Data, unsigned char Length_Data)
{
  char Registr_CRC = 0xFF; // Начальное значение регистра CRC
  unsigned char i; // Индексная переменная

  while (Length_Data--)  //Вычислить CRC для блока данных
  {
    Registr_CRC ^= *Data++;
    for (i = 0; i < 8; i++)
    {
      Registr_CRC >>= 1;
      if ( (Registr_CRC & 0b00000001) != 0 )
        Registr_CRC ^= 0x31;
    }          
  }   
  return Registr_CRC; 
}


/*
   Функция копирует пользовательские данные в служебный пакет данных
    для их последующей передачи по радио-каналу
   Параметры:
    char *Data - Указатель на массив с пользовательским пакетом данных 
                  для отправки по радио-каналу.
    const RADIO_PAKET_DATA_BAYT_COUNT
   Возвращаемое значение:
    char - (1) Данные успешно переданы на передачу по радио-каналу
    char - (0) Радио-передатчик занят
*/
char RadioWrite (char *Data)
{
  unsigned char i; // Индексная переменная

  // Если радио-передатчик свободен
  if (RadioPaketPeredacha == 0)
  {
    // Заполнение служебного пакета данными
    RadioPaketOut[0] = PREAMBULA;
    for (i = 0; i < RADIO_PAKET_DATA_BAYT_COUNT; i++)
      RadioPaketOut[i+1] = Data[i];
    RadioPaketOut[RADIO_PAKET_DATA_BAYT_COUNT + 1] = CRC_8(Data, RADIO_PAKET_DATA_BAYT_COUNT);
    RadioPaketPeredacha = 1; // Разрешить передачу данных по радио-каналу
    return 1;     
  }
  else
    return 0;  
}


// Передача данных по радио-каналу
void RadioPeredacha(void)
{
  static unsigned char IndexBayt = 0; // Индекс байта
  static unsigned char IndexPaketBayt = 0; // Индекс пакета байтов
	static char Bit1, Bit0 = 0;
	static char StartBit = 0; // Для передачи 1-ного стартового бита
	/*
	   После выставления последнего выходного сигнала
	    отсчитать один периуд и завершить передачу
	*/    
	static char FlagPeriudPoslednegoBita = 0; 
	
  // Есть данные для передачи по радио-каналу
  if (RadioPaketPeredacha == 1)
  {
  	if (FlagPeriudPoslednegoBita == 0)
  	{	
  		// Передача стартового бита
  		if (StartBit == 0)
  		{
  			StartBit = 1;
  			BIT_1(RADIO_SIGNAL_OUT_PORTX, RADIO_SIGNAL_OUT_PIN);
  			return;
  		}	
	    // Передача 1 байта данных (манчестерское кодирование)
	    if (BIT_RAVEN_0 (RadioPaketOut[IndexPaketBayt], IndexBayt))
	    {	
	    	// Выходной бит данных 0 --- передаётся как сначало 0 потом 1
	    	if (Bit0 == 0)
	    	{
	    		BIT_0(RADIO_SIGNAL_OUT_PORTX, RADIO_SIGNAL_OUT_PIN);
	    		Bit0 = 1;    		
	    	}	
	    	else 
	    	{
	    		BIT_1(RADIO_SIGNAL_OUT_PORTX, RADIO_SIGNAL_OUT_PIN);
	    		Bit0 = 0;
	    	  ++IndexBayt;
	    	}    	
	    }    
	    else // Выходной бит данных 1 --- передаётся как сначало 1 потом 0
	    {
	    	if (Bit1 == 0)
	    	{
	    		BIT_1(RADIO_SIGNAL_OUT_PORTX, RADIO_SIGNAL_OUT_PIN);
	    		Bit1 = 1;    		
	    	}	
	    	else 
	    	{
	    		BIT_0(RADIO_SIGNAL_OUT_PORTX, RADIO_SIGNAL_OUT_PIN);
	    		Bit1 = 0;
	    	  ++IndexBayt;
	    	}
	    } 	
	    // Отправлен ещё 1 байт данных
	    if (IndexBayt == 8)
	    {
	      IndexBayt = 0;
	      ++IndexPaketBayt;
	      // Передача всего пакета данных завершена
	      if (IndexPaketBayt == (RADIO_PAKET_DATA_BAYT_COUNT + 2))
	      { 
	      	// Остался последний периуд
	        IndexPaketBayt = 0;
	        FlagPeriudPoslednegoBita = 1;  
	      }      
	    }
	  }
	  else // Передача завершена 
	  {	  	
	    FlagPeriudPoslednegoBita = 0;
	    StartBit = 0;
	    BIT_0(RADIO_SIGNAL_OUT_PORTX, RADIO_SIGNAL_OUT_PIN);
	    RadioPaketPeredacha = 0;
	  }        
  }
}


// Передача сигнала меандр по радио-каналу
void RadioPeredachaMeandr (void)
{
	static char BitOut = 1;
	
	if (BitOut == 1)
	{
		BIT_1(RADIO_SIGNAL_OUT_PORTX, RADIO_SIGNAL_OUT_PIN);
		BitOut = 0;    		
	}	
	else 
	{
		BIT_0(RADIO_SIGNAL_OUT_PORTX, RADIO_SIGNAL_OUT_PIN);
		BitOut = 1;
	}    	
}