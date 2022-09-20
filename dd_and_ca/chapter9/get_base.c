#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

int main(int argc, char *argv[])
{
   FILE *fp;
   uint32_t base;
   unsigned char buf[12];
   if (fp = fopen("/proc/device-tree/soc/ranges" , "rb"))
   {
      if (fread(buf, 1, sizeof(buf), fp) >= 8)
      {
         base = buf[4]<<24 | buf[5]<<16 | buf[6]<<8 | buf[7];
         if (!base)
            base = buf[8]<<24 | buf[9]<<16 | buf[10]<<8 | buf[11];
         printf("peri base is %x\n", base);
      }
      fclose(fp);
   }
}
