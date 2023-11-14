#include "RadioPriem.h"

// ���������������� ==============================================================
#define BIT_0(chislo, poziciya)           (chislo) &= (~(1 << (poziciya)))
#define BIT_1(chislo, poziciya)           (chislo) |=   (1 << (poziciya))
#define BIT_RAVEN_0(chislo, poziciya)   (((chislo) &    (1 << (poziciya))) == 0)
// ��������� �����������
#define PREAMBULA 0b01010101
//================================================================================

// ���������� =====================================================================================
// ��������� ����� ��� ����� ������ �� �����-������
volatile char RadioPaketIn[RADIO_PAKET_DATA_BAYT_COUNT + 1];
/* 
	 ���� ���������� ����� ������.
   ���� ��������������� � 1 ����� ���������� ����� ������.
   ������������ ���� ����� ��������� ������ � RadioPaketIn. 
*/
volatile char RadioPaketPrinyat = 0;  
/* 
	 ���� ������������ RadioPaketIn. ���������� ������ ����������� ������.
   ���� ��������������� � 1, ���� � ������ ���������� ����� 1-�� �����������������
    ����� ������ ������, ������ � RadioPaketIn ����� �� ���� ���������. 
   ������������ ���� ����� ��������� ������ � RadioPaketIn. 
*/
 volatile char RadioPaketOverflow = 0;
 
// ���������� ������� ===============================================================================
/*
   ������� �������� ���������������� ������ �� ���������� ������ ������, 
   	 ��������� �� �����-������ � ��������� ��� � ���������������� ����� ������.
   ���������:
    char *Data - ��������� �� ������ � ���������������� ������� ������
    char *FlagOwerflow - ��������� �� ���������� ��� ����������� ������
    	                    ����������� ������ 
    const RADIO_PAKET_DATA_BAYT_COUNT
   ������������ ��������:
    char (1) - ����� ������ �������
    char (0) - ��� �������� ������
    FlagOwerflow (1) - ���������� ����� �������
    FlagOwerflow (0) - ��� ������ ������
*/
char RadioRead (char *Data, char *FlagOwerflow)
{
	unsigned char i; // ��������� ����������
	
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


// �����-���� ������
void RadioPriem(void)
{
	// �������������� ��� � ��� ��� ���������
	static enum InfoBit
	{
		_0 = 0, // ��� 0
		_1 = 1, // ��� 1
		A_ = 2, // ������� �
	  Neopredelen = 4, // �������������
	} InfoBit = Neopredelen;
	// ����� ������ � ��� ��� ���������
	static enum Paket
	{
		StartBit = 0, // ��������� 1-��� ���
		Bit0_7   = 1, // ��� � 1-�� �� 7-�� (������ � ��� 0 �������� ���������)
		Bit8_n   = 2, // ��� � 8-�� �� n-�� (������ ������������ + CRC)
		Reset    = 3, // ����� �����-�����
	} Paket = StartBit;
	/*
	   ��������������� � 1 ��� ������������� (� ������ ������� ����������� PIN = 1)
	    ��� ������ ���������� ���� ������
	*/ 
	static char FlagSinhronizaciya = 1;
	static unsigned char PoluBitStrobCount = 0; // ���-�� ��������� ������������ ��������
	// ������� ��������� ������� � ������ �������� ��������������� ����
	static unsigned int PoluBit_A_Count = 0; // ������� ������� �������� A
	static unsigned int PoluBit_B_Count = 0; // ������� ������� �������� B
	static unsigned char IndexBayt = 0; // ������ ��������� �����
	static unsigned char IndexPaketBayt = 0; // ������ ��������� ������ ������
	char BitPreambulaIn; // ������ ��� ���� ���������
	static char BaytIn; // ������ ��� ��������� �����	
	unsigned char adc_data;
  
	// Read the AD conversion result
	adc_data = REGISTR_ADC_DATA_H;
	// �������������
  if (FlagSinhronizaciya == 1)
  {
  	if (adc_data >= RADIO_SIGNAL_IN_VOLT)	      		  		  			
      FlagSinhronizaciya = 0;           
  	else
  		return;     
  }	 
	// ����� ��������������� ����
  switch (InfoBit)
  {
  case Neopredelen:     
  	/*	
  		 � ������������ ���������� ���� ��� ���������� ������
  		 �������������� ��� ��� ������ ������ ������
  	*/
    if (Paket == StartBit)
    {
    	if (adc_data < RADIO_SIGNAL_IN_VOLT)
    	{
    		goto Reset;
    	}	
    }		        
	  PoluBit_A_Count = PoluBit_A_Count + adc_data;	 
  	break;
  case A_:
	  PoluBit_B_Count = PoluBit_B_Count + adc_data;	     
  	break;
  }
  ++PoluBitStrobCount;
  // ������� �� �������� ������� ������
  if (PoluBitStrobCount == CIKL_ADC_COUNT)
  {
  	PoluBitStrobCount = 0;
  	switch (InfoBit)
  	{
  	case Neopredelen:
  		// ��������� ��� ������
  		if (Paket == StartBit)
  		{  			
  			Paket = Bit0_7;
	  		PoluBit_A_Count = 0;
	  		return;
  		}	
  	  InfoBit = A_; 
  		return;
  	case A_:
  		if (PoluBit_A_Count > PoluBit_B_Count)
  			InfoBit = _1;    	
  		if (PoluBit_A_Count < PoluBit_B_Count)
  			InfoBit = _0;
  		// ������������ �����-�����	
  		if (PoluBit_A_Count == PoluBit_B_Count)
  		{
  			goto Reset;
  		}
  		PoluBit_A_Count = 0;
  		PoluBit_B_Count = 0;  		
  		break;  			
  	}  		  		
  }			
	switch (Paket)
  {
  //����� ���� ����� ���������
  case Bit0_7:
	  switch (InfoBit)
	  {
	  case _0: case _1:	  	
	  	/*
	       ��������� �������� ��� � ������ ���������
	       ���� ���������� ������������ ����� ������������ �����-�����
	    */   
	    if (BIT_RAVEN_0(PREAMBULA, IndexBayt)) // n-��� ��������� ����� 0
	    	BitPreambulaIn = 0;
	    else // n-��� ��������� ����� 1 
	    	BitPreambulaIn = 1;          		
	    if (InfoBit == BitPreambulaIn)	
	    	++IndexBayt;
	    else // ������������ �����-�����
	    {	
	    	goto Reset;           
	    }
	    InfoBit = Neopredelen;
	  	// ��������� �������
	    if (IndexBayt == 8)
	    {							  
			  IndexBayt = 0;
	      Paket = Bit8_n;      
	    }  	
	  }			
		break;
	/*
     ����� ���� ��������� �������������� ����� ������
     ���� ���������������� ������
  */	
	case Bit8_n:
		switch (InfoBit)
	  {
	  case _0: case _1:
	  	// ��������� ������� ��� � �������
			if (InfoBit == 1)
				BIT_1(BaytIn,IndexBayt);
			else
				BIT_0(BaytIn,IndexBayt);	
			++IndexBayt;
			InfoBit = Neopredelen;
	    // ������ ��� 1 ����
	    if (IndexBayt == 8)
	    {	     
	      IndexBayt = 0;
	      // ���������� ����� �������
	      if (RadioPaketPrinyat == 1)
	      {
	      	RadioPaketOverflow = 1;
	      }
	      // ������ ���������������� ����
	      if (IndexPaketBayt < RADIO_PAKET_DATA_BAYT_COUNT + 1)
	      {
	        RadioPaketIn[IndexPaketBayt] = BaytIn; // ��������� �������� ���� � ������
	        ++IndexPaketBayt;
	      }
	      // ���� ����� ������ ������ ��������
	      if (IndexPaketBayt == (RADIO_PAKET_DATA_BAYT_COUNT + 1))	
	      {	        
					// �������� ����������� ���������������� ������ ��������� ������
					if (RadioPaketIn[RADIO_PAKET_DATA_BAYT_COUNT] == CRC_8(RadioPaketIn, RADIO_PAKET_DATA_BAYT_COUNT))
		        RadioPaketPrinyat = 1; // ������ � �������             		        
	        // ������ ����� ������ ������
	        goto Reset;
	      }
	    }   		
		}
		return;	
	// ����� �����-�����
	case Reset:
		Reset:
		Paket = StartBit;
		InfoBit = Neopredelen;		
  	FlagSinhronizaciya = 1;  	
		PoluBitStrobCount = 0;
  	PoluBit_A_Count = 0;
		PoluBit_B_Count = 0;
		IndexBayt = 0;
		IndexPaketBayt = 0;	
	}
}	