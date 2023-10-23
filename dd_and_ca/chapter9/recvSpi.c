#include "easyPIO.h"
#include <stdio.h>
#include <unistd.h>
void main(void)
{
  char received;
  pioInit();
  //  spiInit(125000000, 0);
  spiInit(122000, 0);
  int i = 100;
  int count = 0;
  for (count = 0; count < i; count++)
  {
    printf("sending: %d\r\n", count);
    received = spiSendReceive(count);
    usleep(100000);
    printf("received: %d\r\n", received);
  }
  // Initialize the SPI:
  // 244 kHz clk, default settings // Send letter A and receive byte
}