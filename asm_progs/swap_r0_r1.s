/* Write ARM assembly code for swapping the contents of 
   two registers, R0 and R1.  You may not use any other
   registers */

.global main
main:
  sub sp, sp, #8
  sub r0, r15, r15
  add r1, r0, #7
  str r1, [sp]
  str r0, [sp, #4]
  ldr r0, [sp]
  ldr r1, [sp, #4]
  add sp, sp , #8
