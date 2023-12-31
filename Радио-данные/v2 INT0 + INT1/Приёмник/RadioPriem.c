#include "RadioPriem.h"

// ���������������� ==============================================================
#define BIT_0(chislo, poziciya)         (chislo) &= (~(1 << (poziciya)))
#define BIT_1(chislo, poziciya)         (chislo) |=   (1 << (poziciya))            
#define BIT_RAVEN_0(chislo, poziciya)   (((chislo) & (1 << (poziciya))) == 0)
// ��������� �����������
#define PREAMBULA 0b01010101
// ���������� =====================================================================================
// ������� ������ � �����-�������� � ��� ��� ���������
volatile enum InSignal
	{
	  NarastayuschiyFront = 0, // ����������� �����
	  SpadayuschiyFront = 1,   // ��������� �����
	} InSignal = SpadayuschiyFront;
// ����� ������ � ��� ��� ���������
volatile enum Paket
{
	StartBit = 0, // ��������� 1-��� ���
	Bit0_7 = 1, // ��� � 0-�� �� 7-�� (�������� ���������)
	Bit8_n = 2, // ��� � 8-�� �� n-�� (������ ������������ + CRC)
} Paket = StartBit;
// ��������� ����� ��� ����� ������ �� �����-������
volatile char RadioPaketIn[RADIO_PAKET_DATA_BAYT_COUNT + 1];
// ��������� ������������ ������� �������� 1-���� ��������������� ����
volatile unsigned int InfoBit1TikTCNT = 0; 
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


// ������������ ������� ����������� �����
void EventNarastayuschiyFront (void)
{	       
  // ����� 1-���� ���������� ����
  if (Paket == StartBit)
  {   	 	
		// ������������� ����������� ��������� ���������� ��� ����� ������ �� �����-������		
		// ��������� �������� ��������
    #ifdef REGISTR_TCNT_TIMER_CLK
    			 REGISTR_TCNT_TIMER_CLK = 0;
    #endif 
    #ifdef REGISTR_TCNTH_TIMER_CLK
    			 REGISTR_TCNTH_TIMER_CLK = 0; // ������� ������� ����
    #endif			 
    #ifdef REGISTR_TCNTL_TIMER_CLK
    			 REGISTR_TCNTL_TIMER_CLK = 0; // � ����� �������
    #endif
    // ������ ����� ���������� �������/��������
		BIT_1(REGISTR_FLAG_PRERYIVANIYA, FLAG_PRERYIVANIYA);	      	
  }	
	InSignal = NarastayuschiyFront;
	// ������ ������ ������������ ������� 1-���� ��������������� ����
	#ifdef REGISTR_TCNT_TIMER_PERIUD
  			 REGISTR_TCNT_TIMER_PERIUD = 0; 	
	#endif
	#ifdef REGISTR_TCNTH_TIMER_PERIUD
				 REGISTR_TCNTH_TIMER_PERIUD = 0;
	#endif
	#ifdef REGISTR_TCNTL_TIMER_PERIUD
				 REGISTR_TCNTL_TIMER_PERIUD = 0;
	#endif	
}


// ������������ ������� ��������� �����
void EventSpadayuschiyFront (void)
{    
  InSignal = SpadayuschiyFront;
  // ����������� ��� ������������ ������� 1-���� ��������� ������������ ��������������� ����
  InfoBit1TikTCNT = InfoBit1TikTCNT +
  #ifdef REGISTR_TCNT_TIMER_PERIUD
  			 REGISTR_TCNT_TIMER_PERIUD; 	
	#endif
	#ifdef REGISTR_TCNTH_TIMER_PERIUD
				 REGISTR_TCNTH_TIMER_PERIUD;
	#endif
	#ifdef REGISTR_TCNTL_TIMER_PERIUD
				 REGISTR_TCNTL_TIMER_PERIUD;
	#endif 
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
		Neopredelen = 3, // ������������� 
	} InfoBit = Neopredelen;
	static unsigned int PoluBit_A_Count1 = 0; // ���-�� �������� 1-��� �������� �������� A
	static unsigned int PoluBit_B_Count1 = 0; // ���-�� �������� 1-��� �������� �������� B
  static unsigned char IndexBayt = 0; // ������ ��������� �����
  static unsigned char IndexPaketBayt = 0; // ������ ��������� ������ ������
  char BitPreambula; // ������ ��� ���� ���������
  static char BaytIn; // ������ ��� ��������� ����� 
        
  // ����� 1-���� ���������� ����
  if (Paket == StartBit)
  { 
  	switch (InSignal)
  	{
  	// � ���������� ���� ��� ���������� ������	
  	case SpadayuschiyFront:
  	  return;
  	// ���� ����� ���������� ���� ��������   
  	case NarastayuschiyFront:
  	  Paket = Bit0_7;
  	  InfoBit1TikTCNT = 0; 
  	  #ifdef REGISTR_TCNT_TIMER_PERIUD
		  			 REGISTR_TCNT_TIMER_PERIUD = 0; 	
			#endif
			#ifdef REGISTR_TCNTH_TIMER_PERIUD
						 REGISTR_TCNTH_TIMER_PERIUD = 0;
			#endif
			#ifdef REGISTR_TCNTL_TIMER_PERIUD
						 REGISTR_TCNTL_TIMER_PERIUD = 0;
			#endif
    	return;	
  	} 	 		
  }
  // ����� ��������������� ����
  if (InSignal == NarastayuschiyFront)
  {	
  	InfoBit1TikTCNT = InfoBit1TikTCNT +
  	#ifdef REGISTR_TCNT_TIMER_PERIUD
	  			 REGISTR_TCNT_TIMER_PERIUD; 	
		#endif
		#ifdef REGISTR_TCNTH_TIMER_PERIUD
					 REGISTR_TCNTH_TIMER_PERIUD;
		#endif
		#ifdef REGISTR_TCNTL_TIMER_PERIUD
					 REGISTR_TCNTL_TIMER_PERIUD;
		#endif
	}	 
  #ifdef REGISTR_TCNT_TIMER_PERIUD	
  			 REGISTR_TCNT_TIMER_PERIUD = 0; 	
	#endif
	#ifdef REGISTR_TCNTH_TIMER_PERIUD
				 REGISTR_TCNTH_TIMER_PERIUD = 0;
	#endif
	#ifdef REGISTR_TCNTL_TIMER_PERIUD
				 REGISTR_TCNTL_TIMER_PERIUD = 0;
	#endif
  switch (InfoBit)
  {
  // ������� �� �������� ������� ������	
  case Neopredelen:
    InfoBit = A_; 
    PoluBit_A_Count1 = InfoBit1TikTCNT;
    // ���� ����� �������� ��������
    InfoBit1TikTCNT = 0; 
    return;
  // ������� �� �������� ������� ������  
  case A_:
    PoluBit_B_Count1 = InfoBit1TikTCNT;
    // ���� ����� �������� ��������
    InfoBit1TikTCNT = 0;
    if (PoluBit_A_Count1 > PoluBit_B_Count1)    	
			InfoBit = _1;	    	
		if (PoluBit_A_Count1 < PoluBit_B_Count1)						
			InfoBit = _0;		
		// ������������ �����-�����	
		if (PoluBit_A_Count1 == PoluBit_B_Count1)
		{        
			PoluBit_A_Count1 = 0;
			PoluBit_B_Count1 = 0;
			IndexBayt = 0;
			IndexPaketBayt = 0;
			InfoBit = Neopredelen;		
			Paket = StartBit;
			return;
		}
		PoluBit_A_Count1 = 0;
		PoluBit_B_Count1 = 0; 
    break;	
  }
  switch (Paket)
  {
  // ����� ���� ����� ���������	
  case Bit0_7:
    switch (InfoBit)
	  {
	  case _0: case _1:
	  	/*
	       ��������� �������� ��� � ������ ���������
	       ���� ���������� ������������ ����� ������������ �����-�����
	    */   
	    if (BIT_RAVEN_0(PREAMBULA, IndexBayt)) // n-��� ��������� ����� 0
	    	BitPreambula = 0;
	    else // n-��� ��������� ����� 1 
	    	BitPreambula = 1;          		
	    if (InfoBit == BitPreambula)	
	    	++IndexBayt;
	    else // ������������ �����-�����
	    {	      
				PoluBit_A_Count1 = 0;
				PoluBit_B_Count1 = 0;
				IndexBayt = 0;
				IndexPaketBayt = 0;     
		    InfoBit = Neopredelen;		
				Paket = StartBit;
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
	        // ������������ �����-�����
	        PoluBit_A_Count1 = 0;
					PoluBit_B_Count1 = 0;
					IndexBayt = 0;
					IndexPaketBayt = 0;     
			    InfoBit = Neopredelen;		
					Paket = StartBit;
	      }
	    }   		
		}   	
  }  
}