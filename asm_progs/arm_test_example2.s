	.text
	.global sum
	.type	sum, %function
sum:
	add	r0, r0, r1
	bx	lr
	.global	main
	.type	main, %function
main:
	push	{r3, lr}
	mov	r0, #2
	ldr	r3, .L3
	str	r0, [r3, #0]
	mov	r1, #3
	ldr	r3, .L3+4
	str	r1, [r3, #0]
	bl	sum
	ldr	r3, .L3+8
	str	r0, [r3, #0]
	pop	{r3, pc}
.L3:
	.word	4
	.word	4
	.word	4
