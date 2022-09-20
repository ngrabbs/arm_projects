#include <stdio.h>
#include <stdlib.h>

void main(void) {
 //int y = 0x2x;
 //unsigned char y = 42;

 char *greeting = "Hello!";
 printf("greeting: %s", greeting);

 int y = 1;
 y++;
 y &= 0xF;
 printf("what suckah: %b\r\n", y);
}