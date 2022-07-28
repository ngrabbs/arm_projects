# dd_and_ca_fpga
Exercises and examples from Digital Design and Computer Architecture - Harris &amp; Harris

## Exercises
### 4.3 Write an HDL module that computes a four-input XOR function.  The input is a3:0, and the output is y. 

```systemverilog
module exercise4_3(input  logic [3:0] a,
                   output logic y);
  assign y = ^a;
endmodule
```

### Exercise 4.4 
Write a self-checking testbench for Exercise 4.3.  Create a test vector file containing all 16 test cases.  Simulate the circuit and show that it works.  Introduce an error in the test vector file and show that the testbench reports a mismatch.

[exercise4.4](https://github.com/ngrabbs/dd_and_ca_fpga/blob/main/chapter4/exercise4_4_tb.sv):
```systemverilog
module exercise4_3_tb();
  logic y, yexpected;
  logic [3:0] a;
  logic [31:0] vectornum, errors;
  logic [4:0]  testvectors[10000:0];
  integer i;
  
  // instantiate device under test
  exercise4_3 dut(a, y);

  // at start of test, load vectors
  // and pulse reset
  initial
    begin
      $readmemb("exercise4_4.tv", testvectors);
      vectornum=0; errors=0;

      forever begin
        {a[0], a[1], a[2], a[3], yexpected} = testvectors[vectornum]; #10;

        if ( y !== yexpected) begin // check result
          $display("Error: input = %b output = %b (%b expected)", a, y, yexpected);
          errors = errors + 1;
        end else begin
          $display("Pass: input = %b output = %b", a, y);
        end

        vectornum = vectornum + 1;

        if (testvectors[vectornum] === 5'bx) begin
          $display("%d tests completed with %d errors", 
            vectornum, errors);
          $finish;
        end
      end
    end
endmodule
```

Simulate output `iverilog -g2009 -o exercise4_4 exercise4_4_tb.sv exercise4_3.sv ; vvp ./exercise4_4`:
```bash
iverilog -g2009 -o exercise4_4 exercise4_4_tb.sv exercise4_3.sv ; vvp ./exercise4_4
WARNING: exercise4_4_tb.sv:15: $readmemb: Standard inconsistency, following 1364-2005.
WARNING: exercise4_4_tb.sv:15: $readmemb(exercise4_4.tv): Not enough words in the file for the requested range [0:10000].
Error: input = 0000 output = 0 (1 expected)
Pass: input = 1000 output = 1
Pass: input = 0100 output = 1
Pass: input = 1100 output = 0
Pass: input = 0010 output = 1
Pass: input = 1010 output = 0
Pass: input = 0110 output = 0
Pass: input = 1110 output = 1
Pass: input = 0001 output = 1
Pass: input = 1001 output = 0
Pass: input = 0101 output = 0
Pass: input = 1101 output = 1
Pass: input = 0011 output = 0
Pass: input = 1011 output = 1
Pass: input = 0111 output = 1
Pass: input = 1111 output = 0
        16 tests completed with          1 errors
```

### 4.5 Write an HDL module called minority.  It receives three inputs, a, b, and c.  It produces one output, y, that is TRUE if at least two of the inputs are FALSE.
[exercise4.5](https://github.com/ngrabbs/dd_and_ca_fpga/blob/main/chapter4/exercise4_5.sv):
```systemverilog
module minority(input logic a, b, c,
                output logic y);
  always_comb begin
    if      ( ~a & ~b & c ) y = 1'b1;
    else if ( ~a & b & ~c ) y = 1'b1;
    else if ( a & ~b & ~c ) y = 1'b1;
    else if ( ~a & ~b & ~c ) y = 1'b1;
    else y = 1'b0;
  end

endmodule
```