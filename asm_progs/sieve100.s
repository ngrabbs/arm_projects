/*
Sieve of Eratosthenes

Generate Primes on range 1 to 100

Fill the first 100 locations of RAM with values 1 to 100.
*/
.data
.balign 4
myvar1:
  .word 0

.text
.balign 4
.global main
main:
  sub r0, r15, r15       /* R0 = 0  min value */
  add r1, r0, #100       /* R1 = 100 max value */
	sub r2, r15, r15       /* R2 = 0 */
	sub r4, r15, r15
	sub r5, r15, r15
	sub r6, r15, r15
	add r6, r6, #0x4
	ldr r3, addr_of_myvar1 /* pointer to dram */
	str r1, [r3]

loop:                    /* this is the loop to setup array */
	sub r1, r1, #1         /* increment counter */
	add r3, r3, #0x4       /* increment ram / array */
	str r1, [r3]           /* store value */
  cmp r1, #0             /* if not zero, do again */
	bne loop

/* Zero all multiple locations up to Square Root(100) = 10 */
  add r2, r2, #2         /* start with 2 as base value */
loop1: /* loop1 works through the outter loop */
	/* point to base register + 2 words up = 2 */
	ldr r3, addr_of_myvar1 /* set DRAM point to address of base */
  add r3, r3, #0x190

  add r4, r0, #0
	mul r5, r2, r6 /* off set r2 * 0x4 */
	sub r3, r3, r5

loop2: /* loop2 works through the inner */

	add r4, r4, r2 /* loop counter */
	sub r3, r3, r5 /* address pointer */

	str r0, [r3]              /* strike address */
	cmp r4, #101             /* have multiples of 100 been stricken? */
	blt loop2                /* if not loop else fall through */

next_n:
  add r2, r2, #1 /* increment r2 */
	cmp r2, #10
	bne loop1

	/* the end */
	add r0, r0, #0

addr_of_myvar1 : .word myvar1

/*
  >│0x10420 <main+24>       ldr    r3, [r11, #-8]                                                                                                  │
   │0x10424 <main+28>       lsl    r3, r3, #2                                                                                                      │
   │0x10428 <main+32>       sub    r2, r11, #4                                                                                                     │
   │0x1042c <main+36>       add    r3, r2, r3                                                                                                      │
   │0x10430 <main+40>       ldr    r2, [r11, #-8]                                                                                                  │
   │0x10434 <main+44>       str    r2, [r3, #-420] ; 0xfffffe5c                                                                                    │
   │0x10438 <main+48>       ldr    r3, [r11, #-8]                                                                                                  │
   │0x1043c <main+52>       add    r3, r3, #1                                                                                                      │
   │0x10440 <main+56>       str    r3, [r11, #-8]                                                                                                  │
   │0x10444 <main+60>       ldr    r3, [r11, #-8]                                                                                                  │
   │0x10448 <main+64>       cmp    r3, #99 ; 0x63                                                                                                  │
   │0x1044c <main+68>       ble    0x10420 <main+24>
	 */
