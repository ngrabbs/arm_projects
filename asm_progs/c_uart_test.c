#include "EasyPIO.h"

#define MAX_STR_LEN 80

void uartInit(int baud)
{
  unsigned int fb = 12000000 / baud; // 3 MHz UART clock

  pinMode(14, ALT0);   // TX
  pinMode(15, ALT0);   // RX
  UART_IBRD = fb >> 6; // 6 Fract, 16 Int bits of BRD
  UART_FBRD = fb & 63;
  UART_LCRHbits.WLEN = 3; // 8 Data, 1 Stop, no Parity, no FIFO, no Flow
  UART_CRbits.UARTEN = 1; // Enable uart
}

char getCharSerial(void)
{
  while (UART_FRbits.RXFE)
    ;                      // Wait until data is available
  return UART_DRbits.DATA; // Return char from serial port
}

void putCharSerial(char c)
{
  while (!UART_FRbits.TXFE)
    ;                   // Wait until ready to transmit
  UART_DRbits.DATA = c; // Send char to serial port
}

void getStrSerial(char *str)
{
  int i = 0;
  do
  {                                                  // Read an entire string until
    str[i] = getCharSerial();                        // Carriage return
  } while ((str[i]++ != '\r') && (i < MAX_STR_LEN)); // Look for carriage return
  str[i - 1] = 0;                                    // Null-terminate the string
}

void putStrSerial(char *str)
{
  int i = 0;
  while (str[i] != 0)
  {                          // Iterate over string
    putCharSerial(str[i++]); // Send each character
  }
}

int main(void)
{
  char str[MAX_STR_LEN];
  pioInit();
  uartInit(115200); // Initialize UART with baud rate

  while (1)
  {
    putStrSerial("Please type something: \r\n");
    getStrSerial(str);
    putStrSerial("You typed: ");
    putStrSerial(str);
    putStrSerial("\r\n");
  }
}