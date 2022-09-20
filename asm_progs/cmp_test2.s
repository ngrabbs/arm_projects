.globl _start
_start:
subs r0, r15, r15    /* R0 = 0 */
  sub r1, r15, r15    /* R1 = 0 */
  cmp r0, r1
  
  add r0, r0, #1      /* R0 = 1 */
  cmp r0, r1          /* ? result ? */
  add r0, r0, #2
  add r1, r1, #2
  sub r0, r0, #1
  cmp r0, r0
  cmp r0, r1
  add r1, r1, #1
