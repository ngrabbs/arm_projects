# Digital Design and Computer Architecture Exercises
Exercises and examples from Digital Design and Computer Architecture - Harris &amp; Harris

## Chapter 7 exercises
### Exercise 7.1
Suppose that one of the following control signals in the single-cycle ARM processor has a stuck-at-0 fault, meaning that the signal is always 0, regardless of its inteded value.  What instructions would malfujnction?  Why?
a) RegW - ldr ( cant store value), add, sub, orr
b) ALUOp - and, sub, orr, cant run alu
c) MemW - str, cant write mem

### Exercise 7.2
Repeat 7.1 but with a stuck-at-1 fault. 
a) RegW - values will always be over wrote
b) ALUOp - only add will work as its 01 
c) MemW - str will over write all the time.

### Exercise 7.3
Modifiy the single-cycle ARM processor to implement one of the following instructions.  See Appendix B fora definition of the instructions.  Mark up a copy of Figure 7.13 to indicate the changes in the data path.  Name any new control signals.  Mark up a copy of Tables 7.2 and 7.3 to show the changes to hte Main Decoder and teh CLU Decoder.  Describe any other changes that are required.
a) TST (1000(S=1), TST Rd, Rn, Src2, Set Flags based on Rn & Src2)
b) LSL
c) CMN
d) ADC