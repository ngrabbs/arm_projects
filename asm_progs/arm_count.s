/* -- arm_count.s */
/* This is a counting program that is ported from */
/* the counting program that Xark uses in his */
/* BenEaterSV https://github.com/XarkLabs/BenEaterSV */
/* I'm not porting the OUT function yet, just gonna use */
/* WriteMem with LED's linked to the low bits */

/* -- Data section */
.data
.balign 4
myvar1:
	.word 0


/* -- Code section */
.text
/* Ensure code is 4 byte aligned */
.balign 4
.global main
main:
  sub r0, r15, r15    /* R0 = 0 */
  mov r1, #1          /* R1 = 1 */
  mov r2, #0xFF       /* R2 = FF */
  add r3, r0, #0xEA   /* R3 = EA */
  add r3, r3, #0x04   /* R3 = EE */
  ldr r4, addr_of_myvar1 
  str r3, [r4]        /* mem[0] = EE */

loop:
  subs r3, r2          /* r3 == FF ? */
  beq reset_loop

  add r3, r3, #1      /* increment r3 */
  str r3, [r4]        /* mem[0] = r3 */
  subs r3, r2          /* r3 == FF ? */
  bne loop

reset_loop:
  str r3, [r0]        /* r3 = 0 */
  b loop              /* start loop over */

addr_of_myvar1 : .word myvar1
