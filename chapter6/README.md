# Digital Design and Computer Architecture Exercises
Exercises and examples from Digital Design and Computer Architecture - Harris &amp; Harris

## Chapter 6 Interview Questions 
### Exercise 6.1
Write ARM assembly code for swapping the contents of two registers, R0 and R1, You may not use any other registers.
```assembly
.global main
main:
  sub sp, sp, #8
  sub r0, r15, r15
  add r1, r0, #7
  str r1, [sp]
  str r0, [sp, #4]
  ldr r0, [sp]
  ldr r1, [sp, #4]
  add sp, sp , #8
endmodule