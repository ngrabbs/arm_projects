#include <stddef.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>

#define BCM2835_PERI_BASE 0x20000000
//#define BCM2835_PERI_BASE 0x3F000000
#define GPIO_BASE (BCM2835_PERI_BASE + 0x200000)
#define UART_BASE (BCM2835_PERI_BASE + 0x201000)
#define SPI0_BASE (BCM2835_PERI_BASE + 0x204000)

volatile unsigned int *gpio; // Pointer to base of gpio
volatile unsigned int *spi;  // Pointer to base of spi

#define GPLEV0 (*(volatile unsigned int *)(gpio + 13))
#define BLOCK_SIZE (4 * 1024)

#define GPFSEL ((volatile unsigned int *)(gpio + 0))
#define GPSET ((volatile unsigned int *)(gpio + 7))
#define GPCLR ((volatile unsigned int *)(gpio + 10))
#define GPLEV ((volatile unsigned int *)(gpio + 13))

#define INPUT 0
#define OUTPUT 1

#define ALT0 4

/////////////////////////////////////////////////////////////////////
// SPI Registers
/////////////////////////////////////////////////////////////////////

typedef struct
{
  unsigned CS : 2;
  unsigned CPHA : 1;
  unsigned CPOL : 1;
  unsigned CLEAR : 2;
  unsigned CSPOL : 1;
  unsigned TA : 1;
  unsigned DMAEN : 1;
  unsigned INTD : 1;
  unsigned INTR : 1;
  unsigned ADCS : 1;
  unsigned REN : 1;
  unsigned LEN : 1;
  unsigned LMONO : 1;
  unsigned TE_EN : 1;
  unsigned DONE : 1;
  unsigned RXD : 1;
  unsigned TXD : 1;
  unsigned RXR : 1;
  unsigned RXF : 1;
  unsigned CSPOL0 : 1;
  unsigned CSPOL1 : 1;
  unsigned CSPOL2 : 1;
  unsigned DMA_LEN : 1;
  unsigned LEN_LONG : 1;
  unsigned : 6;
} spi0csbits;
#define SPI0CSbits (*(volatile spi0csbits *)(spi + 0))
#define SPI0CS (*(volatile unsigned int *)(spi + 0))

#define SPI0FIFO (*(volatile unsigned int *)(spi + 1))
#define SPI0CLK (*(volatile unsigned int *)(spi + 2))
#define SPI0DLEN (*(volatile unsigned int *)(spi + 3))

void pioInit()
{
  int mem_fd;
  void *reg_map;

  // /dev/mem is a psuedo-driver for accessing memory in linux
  mem_fd = open("/dev/mem", O_RDWR | O_SYNC);
  reg_map = mmap(
      NULL,                   // Address at which to start local mapping ( null = don't-case)
      BLOCK_SIZE,             // 4KB mappedmemory block
      PROT_READ | PROT_WRITE, // Enable both reading and writing to the mapped memory
      MAP_SHARED,             // Nonexclusing access to this memory
      mem_fd,                 // Map to /dev/mem
      GPIO_BASE);             // Offset to GPIO peripheral
  gpio = (volatile unsigned *)reg_map;

  reg_map = mmap(
      NULL,                   // Address at which to start local mapping (null means don't-care)
      BLOCK_SIZE,             // Size of mapped memory block
      PROT_READ | PROT_WRITE, // Enable both reading and writing to the mapped memory
      MAP_SHARED,             // This program does not have exclusive access to this memory
      mem_fd,                 // Map to /dev/mem
      SPI0_BASE);             // Offset to SPI peripheral

  spi = (volatile unsigned *)reg_map;

  close(mem_fd);
}
void pinMode(int pin, int function)
{
  int reg = pin / 10;
  int offset = (pin % 10) * 3;

  GPFSEL[reg] &= ~((0b111 & ~function) << offset);
  GPFSEL[reg] |= ((0b111 & function) << offset);
}

void digitalWrite(int pin, int val)
{
  int reg = pin / 32;
  int offset = pin % 32;

  if (val)
    GPSET[reg] = 1 << offset;
  else
    GPCLR[reg] = 1 << offset;
}

int digitalRead(int pin)
{
  int reg = pin / 32;
  int offset = pin % 32;

  return (GPLEV[reg] >> offset) & 0x00000001;
}

/////////////////////////////////////////////////////////////////////
// SPI Functions
/////////////////////////////////////////////////////////////////////

void spiInit(int freq, int settings)
{
  // set GPIO 8 (CE), 9 (MISO), 10 (MOSI), 11 (SCLK) alt fxn 0 (SPI0)
  pinMode(8, ALT0);
  pinMode(9, ALT0);
  pinMode(10, ALT0);
  pinMode(11, ALT0);

  // Note: clock divisor will be rounded to the nearest power of 2
  SPI0CLK = 250000000 / freq; // set SPI clock to 250MHz / freq
  SPI0CS = settings;
  SPI0CSbits.TA = 1; // turn SPI on with the "transfer active" bit
}

char spiSendReceive(char send)
{
  SPI0FIFO = send; // send data to slave
  while (!SPI0CSbits.DONE)
    ;              // wait until SPI transmission complete
                   //    printf("SPI0CSbits: %x\r\n", SPI0CSbits);
                   //    printf("SPI0CSbits.DONE: %x\r\n", SPI0CSbits.DONE);
                   //    printf("SPI0FIFO: %x\r\n", SPI0FIFO);
  return SPI0FIFO; // return received data
}

short spiSendReceive16(short send)
{
  short rec;
  SPI0CSbits.TA = 1;                          // turn SPI on with the "transfer active" bit
  rec = spiSendReceive((send & 0xFF00) >> 8); // send data MSB first
  rec = (rec << 8) | spiSendReceive(send & 0xFF);
  SPI0CSbits.TA = 0; // turn off SPI
  return rec;
}