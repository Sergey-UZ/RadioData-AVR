#include "RadioPriem.h"

// Макроопределения ==============================================================
#define BIT_0(chislo, poziciya)           (chislo) &= (~(1 << (poziciya)))
#define BIT_1(chislo, poziciya)           (chislo) |=   (1 << (poziciya))
#define BIT_RAVEN_1(chislo, poziciya)   (((chislo) &    (1 << (poziciya))) != 0)
#define BIT_RAVEN_0(chislo, poziciya)   (((chislo) &    (1 << (poziciya))) == 0)
// Преамбула передатчика
#define PREAMBULA 0b01010101
//================================================================================

// Переменные =====================================================================================
// Служебный пакет для приёма данных по радио-каналу
volatile char RadioPaketIn[RADIO_PAKET_DATA_BAYT_COUNT + 1];
/* 
	 Флаг завершения приёма пакета.
   Флаг устанавливается в 1 после завершения приёма пакета.
   Сбрасывается флаг после прочтения данных в RadioPaketIn. 
*/
volatile char RadioPaketPrinyat = 0;  
/* 
	 Флаг переполнения RadioPaketIn. Индицирует потерю предыдущего пакета.
   Флаг устанавливается в 1 автоматически, если в момент завершения приёма 1-го пользовательского
    байта нового пакета, данные в RadioPaketIn ранее не были прочитаны. 
   Сбрасывается флаг автоматически после прочтения данных в RadioPaketIn. 
*/
 volatile char RadioPaketOverflow = 0;

// Реализация функций ===============================================================================


/*
   Функция копирует пользовательские данные из служебного пакета данных, 
   	 принятого по радио-каналу и сохраняет его в пользовательский пакет данных.
   Параметры:
    char *Data - Указатель на массив с пользовательским пакетом данных
    char *FlagOwerflow - Указатель на переменную для определения потери
    	                    предыдущего пакета 
    const RADIO_PAKET_DATA_BAYT_COUNT
   Возвращаемое значение:
    char (1) - Пакет данных получен
    char (0) - Нет принятых данных
    FlagOwerflow (1) - предыдущий пакет потерян
    FlagOwerflow (0) - нет потери пакета
*/
char RadioRead (char *Data, char *FlagOwerflow)
{
	unsigned char i; // Индексная переменная
	
	if (RadioPaketPrinyat == 1)
	{
		for (i = 0; i < RADIO_PAKET_DATA_BAYT_COUNT; i++)
		  Data[i] = RadioPaketIn[i];
		*FlagOwerflow = RadioPaketOverflow;
		RadioPaketOverflow = 0;
		RadioPaketPrinyat = 0;
		return 1;
	}
	return 0;	
}


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


// Радио-приём данных
void RadioPriem(void)
{
	// Информационный бит и все его состояния
	static enum InfoBit
	{
		_0 = 0, // Бит 0
		_1 = 1, // Бит 1
		A_ = 2, // Полубит А
	  Neopredelen = 4, // Неопределённое
	} InfoBit = Neopredelen;
	// Поиск пакета и все его состояния
	static enum Paket
	{
		StartBit = 0, // Стартовый 1-ный бит
		Bit0_7   = 1, // Бит с 1-го по 7-ой (вместе с бит 0 содержит преамбулу)
		Bit8_n   = 2, // Бит с 8-го по n-ый (данные пользователя + CRC)
	} Paket = StartBit;
	/*
	   Устанавливается в 1 для синхронизации (в момент первого обнаружения PIN = 1)
	    при поиске 0-го бита пакета
	*/ 
	static char FlagSinhronizaciya = 1;
	// Счётчик логических 1 принятого сигнала в каждом полубите информационного бита
	static unsigned char PoluBitStrobCount = 0; // Кол-во прошедшых стробирующих периудов
	static unsigned char PoluBit_A_Count1 = 0; // Кол-во принятых 1-ных сигналов полубита A
	static unsigned char PoluBit_B_Count1 = 0; // Кол-во принятых 1-ных сигналов полубита B
	static unsigned char IndexBayt = 0; // Индекс принятого байта
	static unsigned char IndexPaketBayt = 0; // Индекс принятого пакета байтов
	char BitPreambulaIn; // Буффер для бита преамбулы
	static char BaytIn; // Буффер для принятого байта
	static char FlagReset = 0; // Сбросс радио-приёма
  
  // Сбросс радио-приёма
  if (FlagReset == 1)
  {   
  	FlagReset = 0;
  	FlagSinhronizaciya = 1;  	
		InfoBit = Neopredelen;		
		Paket = StartBit;
		PoluBitStrobCount = 0;
  	PoluBit_A_Count1 = 0;
		PoluBit_B_Count1 = 0;
		IndexBayt = 0;
		IndexPaketBayt = 0;
  }	 
  // Синхронизации
  if (FlagSinhronizaciya == 1)
  {
  	if (BIT_RAVEN_1(RADIO_SIGNAL_IN_PINX, RADIO_SIGNAL_IN_PIN))	      		  		  			
      FlagSinhronizaciya = 0;           
  	else 
  		return;     
  }	 
  // Поиск информационного бита
  switch (InfoBit)
  {
  case Neopredelen:
    if (BIT_RAVEN_1(RADIO_SIGNAL_IN_PINX, RADIO_SIGNAL_IN_PIN))      
	    ++PoluBit_A_Count1;
	  else 
	  {
	  	/*	
	  		 У принимаемого стартового бита нет спадающего фронта
	  		 Соответственно это был принят сигнал помехи
	  	*/
	    if (Paket == StartBit)
	    {
	    	FlagReset = 1;
	  		return;
	    }	
	  }      
  	break;
  case A_:
    if (BIT_RAVEN_1(RADIO_SIGNAL_IN_PINX, RADIO_SIGNAL_IN_PIN))    	
  		++PoluBit_B_Count1;
  	break;
  }
  ++PoluBitStrobCount;	    
  // Полубит из входного сигнала найден
  if (PoluBitStrobCount == 8)
  {
  	PoluBitStrobCount = 0;
  	switch (InfoBit)
  	{
  	case Neopredelen:
  		// Стартовый бит принят
  		if (Paket == StartBit)
  		{
  			Paket = Bit0_7;
	  		PoluBit_A_Count1 = 0;
	  		return;
  		}	
  	  InfoBit = A_; 
  		return;
  	case A_:
  		if (PoluBit_A_Count1 > PoluBit_B_Count1)    	
  			InfoBit = _1;
  		if (PoluBit_A_Count1 < PoluBit_B_Count1)
  			InfoBit = _0;
  		// Перезагрузка радио-приёма	
  		if (PoluBit_A_Count1 == PoluBit_B_Count1)
  		{        
        FlagReset = 1;
  			return;
  		}
  		PoluBit_A_Count1 = 0;
  		PoluBit_B_Count1 = 0;  		
  		break;  			
  	}  		  		
  }			
  switch (Paket)
  {
  //Поиск всех битов преамбулы
  case Bit0_7:
	  switch (InfoBit)
	  {
	  case _0: case _1:	  	
	  	/*
	       Сравнение принятых бит с битами преамбулы
	       Если обнаружено несовпадение тогда перезагрузка радио-приёма
	    */   
	    if (BIT_RAVEN_0(PREAMBULA, IndexBayt)) // n-бит преамбулы равен 0
	    	BitPreambulaIn = 0;
	    else // n-бит преамбулы равен 1 
	    	BitPreambulaIn = 1;          		
	    if (InfoBit == BitPreambulaIn)	
	    	++IndexBayt;
	    else // Перезагрузка радио-приёма
	    {	      
	      FlagReset = 1;
		    return;     
	    }
	    InfoBit = Neopredelen;
	  	// Преамбула найдена
	    if (IndexBayt == 8)
	    {							  
			  IndexBayt = 0;
	      Paket = Bit8_n;      
	    }  	
	  }			
		break;
	/*
     Поиск всех остальных информационных битов пакета
     Приём пользовательских данных
  */	
	case Bit8_n:
		switch (InfoBit)
	  {
	  case _0: case _1:
	  	// Сохранить входной бит в буффере
			if (InfoBit == 1)
				BIT_1(BaytIn,IndexBayt);
			else
				BIT_0(BaytIn,IndexBayt);	
			++IndexBayt;
			InfoBit = Neopredelen;
	    // Принят ещё 1 байт
	    if (IndexBayt == 8)
	    {	      
	      IndexBayt = 0;
	      // Предыдущий пакет потерян
	      if (RadioPaketPrinyat == 1)
	      {
	      	RadioPaketOverflow = 1;
	      }
	      // Принят пользовательский байт
	      if (IndexPaketBayt < RADIO_PAKET_DATA_BAYT_COUNT + 1)
	      {
	        RadioPaketIn[IndexPaketBayt] = BaytIn; // Сохранить принятый байт в пакете
	        ++IndexPaketBayt;
	      }
	      // Приём всего пакета данных завершён
	      if (IndexPaketBayt == (RADIO_PAKET_DATA_BAYT_COUNT + 1))	
	      {	        
					// Проверка целостности пользовательских данных принятого пакета
					if (RadioPaketIn[RADIO_PAKET_DATA_BAYT_COUNT] == CRC_8(RadioPaketIn, RADIO_PAKET_DATA_BAYT_COUNT))
		        RadioPaketPrinyat = 1; // Данные в целости             		        
	        // Начать поиск нового пакета
	        FlagReset = 1;
	      }
	    }   		
		}
  }
}