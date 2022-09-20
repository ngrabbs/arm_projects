/* -- arm_count.s */
/* This is a counting program that is ported from */
/* the counting program that Xark uses in his */
/* BenEaterSV https://github.com/XarkLabs/BenEaterSV */
/* I'm not porting the OUT function yet, just gonna use */
/* WriteMem with LED's linked to the low bits */

/* -- Code section */
.text
.balign 4
.global main
main:
  sub r0, r15, r15    /* R0 = 0 */
  sub r1, r15, r15
  sub r2, r15, r15
  sub r3, r15, r15
  add r3, r3, #1

loop:
  subs r1, r3, r2          /* r3 == FF ? */
  beq reset_loop

  add r3, r3, #1      /* increment r3 */
  str r3, [r0, #0x14]        /* mem[0] = r3 */
  subs r1, r3, r2          /* r3 == FF ? */
  bne loop

reset_loop:
  str r3, [r0]        /* r3 = 0 */
  b loop              /* start loop over */
