.global main
main:
   sub r0, r15, r15
   sub r1, r15, r15
   add r0, r0, #1
   lsl r0, r0, #1
   lsl r0, r0, #1
   lsr r0, r0, #1
   lsr r0, r0, #1
   sub r0, r15, r15
   add r1, r1, #1
   teq r0, r1
   teq r0, r0
   eor r0, r0, r1
   add r0, r0, #3
   rsb r0, r0, r1
   sub r0, r15, r15
