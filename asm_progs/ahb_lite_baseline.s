/* This is the baseline test for the arm multi cycle w/ahb_lite bus */
.global main
main:
  sub r0, r15, r15    /* r0 = 0 */
  add r2, r0, #5      /* r2 = 5 */
  add r3, r0, #12     /* r3 = 12 */
  sub r7, r3, #9      /* r7 = 3 */
  orr r4, r7, r2      /* r4 = 3 OR 5 = 7 */
  and r5, r3, r4      /* r5 = 12 AND 7 = 4 */
  add r5, r5, r4      /* r5 = 4 + 7 = 11 */
  subs r8, r5, r7     /* r8 = 11 - 3 = 8, set Flags */
  beq end             /* shouldn't be taken */
  subs r8, r3, r4     /* r8 = 12 - 7 = 5 */
  bge around          /* should be taken */
  add r5, r0, #0      /* should be skipped */
around:
  subs r8, r7, r2     /* r8 = 3 - 5 = -2, set Flags */
  addlt r7, r5, #1    /* r7 = 11 + 1 = 12 */
  sub r7, r7, r2      /* r7 = 12 - 5 - 7 */
  sub r9, r15, r15

  /* im building up the address 0x00020000 because i dont
     mul or lsl */
  add r9, r9, #16
/*   add r9, r9, #32 */
/*   add r9, r9, #64 */
  add r9, r9, #128 /* max count  */
  add r9, r9, #128 /* max count  */
  add r9, r9, #128 /* max count  */
  add r9, r9, #128 /* max count  */
  add r9, r9, #128 /* max count  */
  sub r1, r15, r15 /* counter */
loop:
  add r3, r3, #200
  add r0, r0, #200
  add r1, r1, #1
  cmp r1, r9
  blt loop
  sub r3, r3, #0x8c
  sub r0, r0, #0x8c
  add r0, r0, #12

/* at this point r3 has a good base address */

  str r7, [r3, #84]   /* mem[12+84] = 7 */
  add r0, r3, #1      /* set r0 to our good base address too */
  ldr r2, [r0, #72]   /* r2 = mem[96] = 7 */

  add r15, r15, r0    /* pc = pc+8 (skips next) */
  add r2, r0, #14     /* shouldn't happen */
  b end               /* always taken */
  add r2, r0, #13     /* shouldn't happen */
  add r2, r0, #10     /* shouldn't happen */
end:
  str r2, [r0, #100]  /* mem[100] = 7 */
