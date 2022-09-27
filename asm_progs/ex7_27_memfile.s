/* ex7.27 test covers ASR, TST, SBC, ROR */
main:
  sub r3, pc, pc       /* r3 = 0 */
  sub r4, r3, #30      /* r4 = -30 (0xFFFFFFE2) */
  asr r5, r4, #1       /* r5 = -15 (0xFFFFFFF1) */
  tst r4, r5           /* set flags based on r4 & r5: nzcv=1000 */
  addmis r6, r4, r5    /* r6 = -30 + (-15)=-45 (0xFFFFFFD3) */
                       /* also set flags: nzcv=1010 */
  sbcs r7, r5, r6      /* r7 = -15 - (-45) - 0 = 30 (0x1E) */
                       /* also set falgs: nzcv = 0010 */
  adds r3, r3, #25     /* r3 = 25, set flags: nzcv = 0000 */
  sbc r8, r7, r5       /* r8 = 30 - (-15) -1 = 44 (0x2c) */
  ror r9, r4, #4       /* r9 = 0xFFFFFFE2 ror 4 = 0x2ffffffE */
  str r9, [r8, #0x2c]  /* mem[0x30] <= 0x2FFFFFFFE */
