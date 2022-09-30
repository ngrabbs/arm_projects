#include <stdio.h>
#include "easyPIO.h"
// User enters 3 student scores into an array long scores[3];
int main(void)
{
  pioInit();
  // spiInit(1250)
  spiInit(125000000, 0);

  int scores[3];
  int i, entered;

  int command;
  while (1)
  {
    getCommand();
    response = spiSendReceive(command);
    printf("response: %s\r\n", response);
  }
}

char getCommand(char)
{
  printf("Enter a command and press enter.\n");
  scanf("%d", &command);
}
