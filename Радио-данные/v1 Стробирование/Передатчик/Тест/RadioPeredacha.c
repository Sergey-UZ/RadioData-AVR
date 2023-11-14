#include "RadioPeredacha.h"

// ���������������� ==============================================================
#define BIT_1(chislo, poziciya)          (chislo) |=   (1 << (poziciya))            
#define BIT_0(chislo, poziciya)          (chislo) &= (~(1 << (poziciya)))
#define BIT_RAVEN_0(chislo, poziciya)  (((chislo) &    (1 << (poziciya))) == 0)
// ��������� �����������
#define PREAMBULA 0b01010101
//================================================================================

// ���������� =====================================================================================
// ��������� ����� ������ ��� �������� �� �����-������
volatile char RadioPaketOut[RADIO_PAKET_DATA_BAYT_COUNT + 2];
/* ���� �������� ������ �� �����-������
   ���� ��������������� � 1 ����� ������� ����� �������� ������
   ������������ ���� � 0 ��� ���������� ��������  
*/
volatile char RadioPaketPeredacha = 0;

// ���������� ������� =============================================================================


/* 
   ������� ���������� CRC-8
   ���������:
    ������������ ������� = x^8 + x^5 + x^4 + 1 = 0x31 
    ��������� �������� �������� CRC = 0xFF 
    char *Data - ��������� �� ������ ������ ��� ������� ����������� �� CRC
    unsigned char Length_Data - ������� ������ ����������� ���� ������� ������ ��� ������� ����������� CRC
   ������������ ��������:
    char - CRC-8 
 */
char CRC_8(char *Data, unsigned char Length_Data)
{
  char Registr_CRC = 0xFF; // ��������� �������� �������� CRC
  unsigned char i; // ��������� ����������

  while (Length_Data--)  //��������� CRC ��� ����� ������
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
   ������� �������� ���������������� ������ � ��������� ����� ������
    ��� �� ����������� �������� �� �����-������
   ���������:
    char *Data - ��������� �� ������ � ���������������� ������� ������ 
                  ��� �������� �� �����-������.
    const RADIO_PAKET_DATA_BAYT_COUNT
   ������������ ��������:
    char - (1) ������ ������� �������� �� �������� �� �����-������
    char - (0) �����-���������� �����
*/
char RadioWrite (char *Data)
{
  unsigned char i; // ��������� ����������

  // ���� �����-���������� ��������
  if (RadioPaketPeredacha == 0)
  {
    // ���������� ���������� ������ �������
    RadioPaketOut[0] = PREAMBULA;
    for (i = 0; i < RADIO_PAKET_DATA_BAYT_COUNT; i++)
      RadioPaketOut[i+1] = Data[i];
    RadioPaketOut[RADIO_PAKET_DATA_BAYT_COUNT + 1] = CRC_8(Data, RADIO_PAKET_DATA_BAYT_COUNT);
    RadioPaketPeredacha = 1; // ��������� �������� ������ �� �����-������
    return 1;     
  }
  else
    return 0;  
}


// �������� ������ �� �����-������
void RadioPeredacha(void)
{
  static unsigned char IndexBayt = 0; // ������ �����
  static unsigned char IndexPaketBayt = 0; // ������ ������ ������
	static char Bit1, Bit0 = 0;
	static char StartBit = 0; // ��� �������� 1-���� ���������� ����
	/*
	   ����� ����������� ���������� ��������� �������
	    ��������� ���� ������ � ��������� ��������
	*/    
	static char FlagPeriudPoslednegoBita = 0; 
	
  // ���� ������ ��� �������� �� �����-������
  if (RadioPaketPeredacha == 1)
  {
  	if (FlagPeriudPoslednegoBita == 0)
  	{	
  		// �������� ���������� ����
  		if (StartBit == 0)
  		{
  			StartBit = 1;
  			BIT_1(RADIO_SIGNAL_OUT_PORTX, RADIO_SIGNAL_OUT_PIN);
  			return;
  		}	
	    // �������� 1 ����� ������ (������������� �����������)
	    if (BIT_RAVEN_0 (RadioPaketOut[IndexPaketBayt], IndexBayt))
	    {	
	    	// �������� ��� ������ 0 --- ��������� ��� ������� 0 ����� 1
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
	    else // �������� ��� ������ 1 --- ��������� ��� ������� 1 ����� 0
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
	    // ��������� ��� 1 ���� ������
	    if (IndexBayt == 8)
	    {
	      IndexBayt = 0;
	      ++IndexPaketBayt;
	      // �������� ����� ������ ������ ���������
	      if (IndexPaketBayt == (RADIO_PAKET_DATA_BAYT_COUNT + 2))
	      { 
	      	// ������� ��������� ������
	        IndexPaketBayt = 0;
	        FlagPeriudPoslednegoBita = 1;  
	      }      
	    }
	  }
	  else // �������� ��������� 
	  {	  	
	    FlagPeriudPoslednegoBita = 0;
	    StartBit = 0;
	    BIT_0(RADIO_SIGNAL_OUT_PORTX, RADIO_SIGNAL_OUT_PIN);
	    RadioPaketPeredacha = 0;
	  }        
  }
}


// �������� ������� ������ �� �����-������
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