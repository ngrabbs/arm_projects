#include <stddef.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>

#define BCM2835_PERI_BASE 0x20000000
#define BCM2711_PERI_BASE 0xFE000000
//#define GPIO_BASE         (BCM2835_PERI_BASE + 0x200000)
#define GPIO_BASE         BCM2711_PERI_BASE
#define SPIO_BASE         (BCM2711_PERI_BASE + 0x4000)
volatile unsigned int     *gpio; // Pointer to base of gpio
#define GPLEV0            (*(volatile unsigned int *) (gpio + 13))
#define BLOCK_SIZE        (4*1024)

#define GPFSEL            ((volatile unsigned int *) (gpio + 0))
#define GPSET             ((volatile unsigned int *) (gpio + 7))
#define GPCLR             ((volatile unsigned int *) (gpio + 10))
#define GPLEV             ((volatile unsigned int *) (gpio + 13))

#define SPI0CS            (*(volatile unsigned int *) (gpio + 4000))
#define SPI0FIFO          (*(volatile unsigned int *) (gpio + 4001))
#define SPI0CLK           (*(volatile unsigned int *) (gpio + 4002))

#define INPUT             0
#define OUTPUT            1

#define ALT0              0b100

void pioInit() {
  int mem_fd;
  void *reg_map;

  // /dev/mem is a psuedo-driver for accessing memory in linux
  mem_fd = open("/dev/mem", O_RDWR|O_SYNC);
  reg_map = mmap(
    NULL,                   // Address at which to start local mapping ( null = don't-case)
    BLOCK_SIZE,             // 4KB mappedmemory block
    PROT_READ|PROT_WRITE,   // Enable both reading and writing to the mapped memory
    MAP_SHARED,             // Nonexclusing access to this memory
    mem_fd,                 // Map to /dev/mem
    GPIO_BASE);             // Offset to GPIO peripheral
  gpio = (volatile unsigned *)reg_map;
  close(mem_fd);


}
void pinMode(int pin, int function) {
  int reg        =   pin/10;
  int offset     =  (pin%10)*3;

  GPFSEL[reg]   &= ~((0b111 & ~function) << offset);
  GPFSEL[reg]   |=  ((0b111 &  function) << offset);
}

void digitalWrite(int pin, int val) {
  int reg        = pin / 32;
  int offset     = pin % 32;

  if  (val)  GPSET[reg] = 1 << offset;
  else       GPCLR[reg] = 1 << offset;
}

int digitalRead(int pin) {
  int reg        = pin / 32;
  int offset     = pin % 32;

  return (GPLEV[reg] >> offset) & 0x00000001;
}


void spiInit(int freq, int settings) {

  printf("test1\r\n");
  pinMode(8, ALT0);     // CE0b
  printf("test2\r\n");
  pinMode(9, ALT0);     // MISO
  printf("test3\r\n");
  pinMode(10, ALT0);    // MOSI
  printf("test4\r\n");
  pinMode(11, ALT0);    // SCLK
  printf("test5\r\n");

  printf("test6\r\n");
  unsigned int spioclk = (250000000/freq);
  printf("test7\r\n");
  printf("SPI0CLK: [%x]\r\n", &SPI0CLK);
  printf("gpio: [%x]\r\n", &gpio);
  printf("gpio: [%x]\r\n", gpio);
  SPI0CLK = 250000000/freq;

  printf("test8\r\n");
  // flip bit 7 to on
  //  SPI0CSbits.TA = 1;     // Turn SPI on
  SPI0CS |= (1 << 7);

  printf("test9\r\n");
}

char spiSendReceive(char send) {
  SPI0FIFO = send;           // Send data to slave
  printf("what\r\n");
  printf("what bits: %x\r\n", ((SPI0CS & (1<<7)) >> 7));
  while (!((SPI0CS & (1<<7)) >> 7));
//  while (!SPI0CSbits.DONE);  // Wait until SPI complete
  return SPI0FIFO;           // Return received data
}