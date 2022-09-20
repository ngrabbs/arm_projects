#include "easyPIO.h"

void main(void) {
  pioInit();

  // Set GPIO 4:2 as inputs
  pinMode(2, INPUT);
  pinMode(3, INPUT);
  pinMode(4, INPUT);


  // Set GPIO 9:7 as an output
  pinMode(7, OUTPUT);
  pinMode(8, OUTPUT);
  pinMode(9, OUTPUT);

  //spiInit(244000, 0);

  while (1) { // Read each switch and write corresponding LED
    printf("gpio2,3,4: [%d][%d][%d]\r\n", digitalRead(2), digitalRead(3), digitalRead(4));
    digitalWrite(7, digitalRead(2));
    digitalWrite(8, digitalRead(3));
    digitalWrite(9, digitalRead(4));
  }
}