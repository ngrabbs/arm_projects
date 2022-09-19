/* Example 6.2
  convert high level code to asm:
  int i
  for (i=0; i<10; i = i +1)
    chararray[i] = chararray[i]-20;
 */
.data
mystring: .ascii "abcdefghij"

.text
.global main
main:
  ldr  r0, addr_of_mystring 
  mov  r1, #10      /* array size */
  mov  r2, #0       /* counter */
  mov  r4, #0       /* address offset */
  mov  r5, #0       /* storage */

for:
  ldrb r5, [r0, r4] /* load up the target value */
  sub  r5, #0x20
  strb r5, [r0, r4]
  add  r2, r2, #1   /* counter */
  add  r4, r4, #1   /* address offset */
  cmp  r2, r1
  bne  for

addr_of_mystring : .word mystring

