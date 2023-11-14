#include "RadioPriem.h"

// ���������������� ==============================================================
#define BIT_0(chislo, poziciya)           (chislo) &= (~(1 << (poziciya)))
#define BIT_1(chislo, poziciya)           (chislo) |=   (1 << (poziciya))
#define BIT_RAVEN_1(chislo, poziciya)   (((chislo) &    (1 << (poziciya))) != 0)
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
   ���� ��������������� � 1 �������������, ���� � ������ ���������� ����� 1-�� �����������������
    ����� ������ ������, ������ � RadioPaketIn ����� �� ���� ���������. 
   ������������ ���� ������������� ����� ��������� ������ � RadioPaketIn. 
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
	} Paket = StartBit;
	/*
	   ��������������� � 1 ��� ������������� (� ������ ������� ����������� PIN = 1)
	    ��� ������ 0-�� ���� ������
	*/ 
	static char FlagSinhronizaciya = 1;
	// ������� ���������� 1 ��������� ������� � ������ �������� ��������������� ����
	static unsigned char PoluBitStrobCount = 0; // ���-�� ��������� ������������ ��������
	static unsigned char PoluBit_A_Count1 = 0; // ���-�� �������� 1-��� �������� �������� A
	static unsigned char PoluBit_B_Count1 = 0; // ���-�� �������� 1-��� �������� �������� B
	static unsigned char IndexBayt = 0; // ������ ��������� �����
	static unsigned char IndexPaketBayt = 0; // ������ ��������� ������ ������
	char BitPreambulaIn; // ������ ��� ���� ���������
	static char BaytIn; // ������ ��� ��������� �����
	static char FlagReset = 0; // ������ �����-�����
  
  // ������ �����-�����
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
  // �������������
  if (FlagSinhronizaciya == 1)
  {
  	if (BIT_RAVEN_1(RADIO_SIGNAL_IN_PINX, RADIO_SIGNAL_IN_PIN))	      		  		  			
      FlagSinhronizaciya = 0;           
  	else 
  		return;     
  }	 
  // ����� ��������������� ����
  switch (InfoBit)
  {
  case Neopredelen:
    if (BIT_RAVEN_1(RADIO_SIGNAL_IN_PINX, RADIO_SIGNAL_IN_PIN))      
	    ++PoluBit_A_Count1;
	  else 
	  {
	  	/*	
	  		 � ������������ ���������� ���� ��� ���������� ������
	  		 �������������� ��� ��� ������ ������ ������
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
  // ������� �� �������� ������� ������
  if (PoluBitStrobCount == 8)
  {
  	PoluBitStrobCount = 0;
  	switch (InfoBit)
  	{
  	case Neopredelen:
  		// ��������� ��� ������
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
  		// ������������ �����-�����	
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
	      FlagReset = 1;
		    return;     
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
	        FlagReset = 1;
	      }
	    }   		
		}
  }
}