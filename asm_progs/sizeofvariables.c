#include <stdio.h>
#include <stdbool.h> // rqeuired for the C bool typedef

int main()
{
  double a = 3.14159;
  float b = 25.0;
  int c = 545; // Note: variables are not = 0 by default!
  long int d = 123;
  char e = 'A';
  bool f = true; // no need for definition in C++
  printf("a val %.4f & size %d bytes (@addr %p).\n", a, sizeof(a), &a);
  printf("b val %4.2f & size %d bytes (@addr %p).\n", b, sizeof(b), &b);
  printf("c val %d (oct %o, hex %x) & "
         "size %d bytes (@addr %p).\n",
         c, c, c, sizeof(c), &c);
  printf("d val %d & size %d bytes (@addr %p).\n", d, sizeof(d), &d);
  printf("e val %d & size %d bytes (@addr %p).\n", e, sizeof(e), &e);
  printf("f val %d & size %d bytes (@addr %p).\n", f, sizeof(f), &f);
}