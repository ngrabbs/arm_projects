/* RO = array base address, R1 = i */
/* initialization code ... */
  mov r0, #0x14000000
  mov r0, #0x20000000
  mov r1, #0

loop:
  cmp r1, #200      /* i < 200? */
  bge l3            /* if i > 200, exit loop */
  lsl r2, r1, #2    /* r2 = i * 4 */
  ldr r3, [r0, r2]  /* r3 = scores[i] */
  add r3, r3, #10   /* r3 = scores[i] + 10 */
  str r3, [r0, r2]  /* scores[i] scores[i] + 10 */
  add r1, r1, #1    /* i = i + 1 */
  b loop            /* repeat loop */
l3:
