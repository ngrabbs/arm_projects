main:
	SUB	r0, r15, r15
        SUB	r1, r15, r15
       	ADD	r1, r1, #15
	TST     r0,#0x3F8
	TEQEQ   r10,r9
 	TSTNE   r1,r5,ASR r1
