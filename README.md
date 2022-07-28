# dd_and_ca_fpga
Exercises and examples from Digital Design and Computer Architecture - Harris &amp; Harris

## Exercises
4.3 Write an HDL module that computes a four-input XOR function.  The input is a3:0, and the output is y. 
`
module exercise4_3(input  logic [3:0] a,
                   output logic y);
//  assign y = ((a[0] ^ a[1]) ^ (a[2] ^ a[3]));
  assign y = ^a;
endmodule
`