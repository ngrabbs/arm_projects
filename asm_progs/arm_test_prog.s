/* -- arm_test.s */
/* This code is from pg 453 in the book: */
/* Digital Design and Computer Architecture */
/* ARM Edition  */
.global main /* 'main' is our entry point and must be global */

main:          		/* main */
    sub r0, r15, r15	/* R0 = 0 */
    add r2, r0, #5	/* R2 = 5 */
    add r3, r0, #12	/* R3 = 12 */
    sub r7, r3, #9	/* R7 = 3 */
    orr r4, r7, r2	/* R4 = 3 OR 5 = 7 */
    and r5, r3, r4	/* R5 = 12 AND 7 = 4 */
    and r5, r5, r4	/* R5 = 4 + 7 = 11 */
    subs r8, r5, r7	/* R8 = 11 - 3 = 8, set Flags */
    beq end		/* shouldn't be taken */
    subs r8, r3, r4	/* r8 = 12 -7 = 5 */
    bge around		/* shouldn't be taken */
    add r5, r0, #0	/* should be skipped */
around:
    subs r8, r7, r2	/* R8 = 3 -5 = -2, set Flags */
    addlt r7, r5, #1	/* R7 = 11 + 1 = 12 */
    sub r7, r7, r2	/* r7 = 12 - 7 = 7 */
    str r7, [r3, #84]	/* mem[12+83] = 7 */
    ldr r2, [r0, #96]	/* R2 = mem[96] = 7 */
    add r15, r15, r0	/* PC = PC+8 (skips next) */
    add r2, r0, #14	/* shouldn't happen */
    b end		/* always taken */
    add r2, r0, #13	/* shouldn't happen */
    add r2, r0, #10	/* shouldn't happen */
end:
    str r3, [r0, #100]	/* mem[100] = 7 */
