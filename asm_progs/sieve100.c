/* sieve100.c */
#include <stdlib.h>
#include <stdio.h>

int main(void) 
{
  int sieveArray[100];
  for(int i = 0; i< 100; i++)
  {
    sieveArray[i] = i;
  }

  int maxCount = 10;
  for(int count = 2; count < maxCount; count++)
  {
//    printf("Working count: %d\n", count);
    
    for(int count2 = (count + count); count2 < 100; )
    {
//      printf("Working count: %d count2: %d\n", count, count2);
      sieveArray[count2] = 0;
      count2 = count2 + count;
    }
  }
  for(int i = 0; i < 100; i++)
  {
    if(sieveArray[i] != 0)
      printf("sieveArray[%d] = %d\n", i, sieveArray[i]);
  }
}