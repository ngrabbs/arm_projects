MAIN:
  SUB R3, PC, PC       /* R3 = 0 */
  ADD R3, R3, #1       /* R3 = 0x1 */
  LSL R3, R3, #30      /* R3 = 0x80000000 */
  ADD R4, R3, #1       /* R4 = 0x80000001 */
  CMN R3, R4           /* set flags according to R3+R4: NZCV=0011 */
  ADC R3, R3, #5       /* R3 = 0x80000006 */
  TST R3, R4           /* set NZ flags according to R3&R4: NZCV=1011 */
  LSL R3, R3, #1       /* R3 = 0x0000000c */
  LSL R4, R4, #1       /* R4 = 0x00000002 */
  STRVC R4, [R3, #4]   /* mem[16]<=0x2 if V=0: */
                       /* shouldn't happen */
  STRVS R4, [R3, #8]   /* mem[20]<=0x2 if V=1: should happen */
