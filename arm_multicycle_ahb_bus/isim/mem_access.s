/* try and read ram 0x00020000 */
.globl main
main:
  sub r0, r15, r15
  sub r1, r15, r15
  add r0, r0, #1
  lsl r0, r0, #17
  add r1, r1, #1
  lsl r1, r1, #21
  sub r1, r15, r15
  add r1, r1, #5
  str r1, [r0, #0]
  ldr r3, [r0, #0]
  add r4, r15, r15
  add r4, r15, r15
  add r4, r15, r15

