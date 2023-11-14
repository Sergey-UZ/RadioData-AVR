/*
	 Project  : ���� ������ �� �����-������
	 Version  : 1
	 Date     : 16.10.2023
	 Author   : Sergey
	 Chip     : AVR
	 Comments : 
	 						������� ������ �� 2 PIN-� INT0 + INT1
	 						2 ��������� �������/��������
	 						��� ���� �������� ������������ � ����������� ������. � �������� ������
	 						������� RadioPriem �������� �� ������ ������.
	 						��� ������� �� ��� ���������� ��������� ���������� (� ������ normal ��� CTC) 
	 							� �������� ������ ������� 1-�� ����, � ���������� �������� ����� ���������
	 							������� RadioPriem
	 						��� ������� ���������� ��������� ������/������� �� ������������ ������ 
	 						������ ��� � ������� �� 20 �� 100% � ��� ���������� (� ������ normal ��� CTC)
	 						��������:
	 							������� RadioPriem ��������� ������ 1 ������������
	 							����� ������������ ������ ���������� ������� �������/��������
	 							����� ����� 1,2 ������������
	 						������ ������/������� ��������� ������� ����������� ��������� �������
	 						������ �������� ������������ ������� ���������� ������� 1-����
	 							�������� �����-�������
	 						
	 						������������� �����������
              ������� ��� ������ 1 --- ��������� ��� ������� 1 ����� 0
              ������� ��� ������ 0 --- ��������� ��� ������� 0 ����� 1
              ������ �������� ������:
               * ��������� ��� (1 ������ ���������� 1-����)
               * ��������� 1 ���� = (0b01010101)
               * ���������������� ������ (n ����)
               * CRC 1 ����
              ���� � �������� ������ CRC �� ��������� - �� ���� ����� ���-�� ���������
              
              ������� EventNarastayuschiyFront
              ������������ ������� ����������� ����� �������� �������
              ��� ���� ������� ���������� ��������� ���������� �� ������������ ������
              ������������ PIN-� ���������������� (������� ���������� - INT0) �
              �������� ��� ������� ������ ����� ����������
              
              ������� EventSpadayuschiyFront
              ������������ ������� ��������� ����� �������� �������
              ��� ���� ������� ���������� ��������� ���������� �� ���������� ������
              ������������ PIN-� ���������������� (������� ���������� - INT1) �
              �������� ��� ������� ������ ����� ����������
              
              ������� RadioPriem
              ��������� ��������� �������� �������
              ��� ���� ������� ���������� ��������� ���������� ��� �������/��������
              (� ������ normal ��� CTC) � �������� ������ ������� 1-�� ����. � � ����
              ���������� �������� ������� RadioPriem
              ��������:
                ������� ������ ���������� 1-�� ���� ������ 1 ������������
                ������� RadioPriem ������ ��������� ������ 1 ������������
              
              ������� RadioRead         
              �������� ���������������� ������ �� ���������� ������ ������, 
            	 ��������� �� �����-������ � ��������� ��� � ���������������� ����� ������
            	 (��������� � CRC ��� �� �����)
              ���������:
                char *Data         - ��������� �� ������ � ���������������� ������� ������
                char *FlagOwerflow - ��������� �� ���������� ��� ����������� ������
                     	                ����������� ������ 
              ������������ ��������:
                        char (1) - ����� ������ �������
                        char (0) - ��� �������� ������
                FlagOwerflow (1) - ���������� ����� �������
                FlagOwerflow (0) - ��� ������ ������                               
*/

#ifndef RADIO_PRIEM_INCLUDED
#define RADIO_PRIEM_INCLUDED

#include <io.h>
#include <stdint.h>

// ���������������� ��������� ===============================================
/*
	 ������� ������� �������/�������� ������� �������� ������������ 
	 	 ������� ���������� ������� 1-���� �������� �����-�������
	 ��������������� ���� �� ��������� � ����������� �� ���� ����� � 
	 	 ��� ������ ������/������� (8-�� ��� 16-�� ���������)
	 ������ ��������������� ������� ��� �� ATTyny2313 
	 	 ������/������� 0 (8-�� ���������)
*/
// ������� 8-�� ��������� -----------------------
#define REGISTR_TCNT_TIMER_PERIUD  TCNT0
// ������� 16-�� ��������� ----------------------
//#define REGISTR_TCNTH_TIMER_PERIUD  TCNT1H
//#define REGISTR_TCNTL_TIMER_PERIUD  TCNT1L
//-----------------------------------------------
/*
	 ������� ������� �������/�������� ������� ��������� ������� 
	 	 ����������� ��������� �������, � ���������� �������� 
	 	 ��������� ������� RadioPriem
	 ��������������� ���� �� ��������� � ����������� �� ���� ����� � 
	 	 ��� ������ ������/������� (8-�� ��� 16-�� ���������)
	 ������ ��������������� ������� ��� �� ATTyny2313 
	 	 ������/������� 1 (16-�� ���������) 	 
*/
// ������� 8-�� ��������� -----------------------
//#define REGISTR_TCNT_TIMER_CLK  TCNT0
// ������� 16-�� ��������� ----------------------
#define REGISTR_TCNTH_TIMER_CLK  TCNT1H
#define REGISTR_TCNTL_TIMER_CLK  TCNT1L
//-----------------------------------------------
/*
	 ������� ������ ���������� �� �������/�������� ������� ��������� 
	 	 ������� ����������� ��������� �������, � ���������� �������� 
	 	 ��������� ������� RadioPriem, � ������� ���� ���� �����
	 	 ���������� ���� �������� ���������� 	 	 
	 ������ ������� ������� ��� �� ATTyny2313 
	 	 ������/������� 1, ����� ������ CTC, ���������� ��� ����������
	 	 �������� ��������� OCR1A �� ������� ��������� TCNT1
*/
#define REGISTR_FLAG_PRERYIVANIYA  TIFR
#define FLAG_PRERYIVANIYA          OCF1A
//-----------------------------------------------
// ���-�� ���������������� ������ � ������
#define RADIO_PAKET_DATA_BAYT_COUNT  5
//==============================================================================
/*
   ��� ��������� ��������� ����������� �������� �������������� � ���, 
    ��� ������� ���������, �� � ��������� �� ������������.
*/
#pragma used+
// ��������� ������� ===============================
char RadioRead (char *Data, char *FlagOwerflow);
void EventNarastayuschiyFront (void);
void EventSpadayuschiyFront (void);
void RadioPriem(void);
//==================================================
/* 
   ��� ��������� ��������� ����������� �������� �������������� � ���, 
    ��� ������� ���������, �� � ��������� �� ������������.
*/
#pragma used-
#endif 