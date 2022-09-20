#include <stdio.h>

/* how do we flip bit 7 */

void main(void) {

  int myReg = 0b10110110111111110111000000000000;
  printf("myreg: %x\r\n", myReg);
  int myTempReg = (1 << 7);
  printf("myTempReg: %x\r\n", myTempReg);
  myReg |= myTempReg; // this can flip
  printf("myreg: %x\r\n", myReg);
  
  /* how do we get a single bit out? */
  int myBit = (1<<7);
  int myBitSet;
  myBitSet = (myReg & myBit);
  printf("myBitSet: %x\r\n", (myBitSet >> 7));

};
