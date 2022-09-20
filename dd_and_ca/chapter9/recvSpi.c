#include "easyPIO.h"
void main(void)
{
  char received;
  pioInit();
  spiInit(244000, 0);
  received = spiSendReceive('A');
  // Initialize the SPI:
  // 244 kHz clk, default settings // Send letter A and receive byte
}
