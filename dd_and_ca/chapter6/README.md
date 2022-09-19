# Digital Design and Computer Architecture Exercises
Exercises and examples from Digital Design and Computer Architecture - Harris &amp; Harris

## Chapter 6 Interview Questions 
### Question 6.1
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

### Question 6.2
Suppose you are given an array of both positive and negative integers.  Write ARM assembly code that finds the subset of the array with the largest sum.  Assume that the array's base address and the number of array elements are in R0 and R1, respectively.  Your code should place the resulting subset of the array starting at the base address in R2.  Write code that runs as fast as possible.
```assembly
.data
  myvar1:
    .word 12
    .word 11
    .word 10
    .word 9 
    .word 8 
    .word 7 
    .word 6 
    .word 5 
    .word 4 
.global main
  sub r0, r15, r15
  sub r0, r15, r15
addr_of_myvar1 : .word myvar1
```