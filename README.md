# Digital Design and Computer Architecture Exercises
Exercises and examples from Digital Design and Computer Architecture - Harris &amp; Harris

## Exercises
### Exercise 4.3
Write an HDL module that computes a four-input XOR function.  The input is a3:0, and the output is y. 

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

simulate output: `iverilog -g2009 -o exercise4_4 exercise4_4_tb.sv exercise4_3.sv ; vvp ./exercise4_4`:
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

### Exercise 4.5
Write an HDL module called minority.  It receives three inputs, a, b, and c.  It produces one output, y, that is TRUE if at least two of the inputs are FALSE.
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

### Exercise 4.6
Write an HDL module for a hexadecimal seven-segment display decoder.  The decoder should handle the digits A, B, C, D, E and F as well as 0-9.
```systemverilog
module sevenseg(input  logic [3:0] digit,
                output logic [7:0] y);
  // https://en.wikipedia.org/wiki/Seven-segment_display
  always_comb
    case(digit)
      // digit        pabcdefg
      4'b0000: y = 8'b01111110; // 0
      4'b0001: y = 8'b00110000; // 1
      4'b0010: y = 8'b01101101; // 2
      4'b0011: y = 8'b01111001; // 3
      4'b0100: y = 8'b00110011; // 4
      4'b0101: y = 8'b01011011; // 5
      4'b0110: y = 8'b01011111; // 6
      4'b0111: y = 8'b01110000; // 7
      4'b1000: y = 8'b01111111; // 8
      4'b1001: y = 8'b01111011; // 9
      4'b1010: y = 8'b01110111; // A
      4'b1011: y = 8'b00011111; // B
      4'b1100: y = 8'b01001110; // C
      4'b1101: y = 8'b00111101; // D
      4'b1110: y = 8'b01001111; // E
      4'b1111: y = 8'b01000111; // F
    endcase
endmodule
```

### Exercise 4.7
Write a self-checking testbench for Exercise 4.6.  Create a test vector file containing all 16 test cases.  Simulate the circuit and show that it works.  Introduce an error in the test vector file and show that the testbench reports a mismatch.
```systemverilog
module exercise4_7();
  logic [3:0] digit;
  logic [7:0] y;
  logic [7:0] yexpected;
  logic [31:0] vectornum, errors;
  logic [11:0]  testvectors[10000:0];

  // dut
  sevenseg dut(digit, y);

  // at start of test, load vectors
  // and pulse reset
  initial
    begin
      $readmemb("exercise4_7.tv", testvectors);
      vectornum=0; errors=0;

      forever begin
        {digit, yexpected} = testvectors[vectornum]; #10;

        if ( y !== yexpected) begin // check result
          $display("Error: input = %b output = %b (%b expected)", digit, y, yexpected);
          errors = errors + 1;
        end else begin
          $display("Pass: input = %b output = %b", digit, y);
        end

        vectornum = vectornum + 1;

        if (testvectors[vectornum] === 12'bx) begin
          $display("%d tests completed with %d errors", 
            vectornum, errors);
          $finish;
        end
      end
    end

endmodule
```

test vectors: exercise4_7.tv:
```
0000_01111111
0001_00110000
0010_01101101
0011_01111001
0100_00110011
0101_01011011
0110_01011111
0111_01110000
1000_01111111
1001_01111011
1010_01110111
1011_00011111
1100_01001110
1101_00111101
1110_01001111
1111_01000111
```

simulate output: `iverilog -g2009 -o exercise4_7_tb.o exercise4_7_tb.sv exercise4_6.sv ; vvp exercise4_7_tb.o`:
```bash
% iverilog -g2009 -o exercise4_7_tb.o exercise4_7_tb.sv exercise4_6.sv ; vvp exercise4_7_tb.o
WARNING: exercise4_7_tb.sv:15: $readmemb: Standard inconsistency, following 1364-2005.
WARNING: exercise4_7_tb.sv:15: $readmemb(exercise4_7.tv): Not enough words in the file for the requested range [0:10000].
Error: input = 0000 output = 01111110 (01111111 expected)
Pass: input = 0001 output = 00110000
Pass: input = 0010 output = 01101101
Pass: input = 0011 output = 01111001
Pass: input = 0100 output = 00110011
Pass: input = 0101 output = 01011011
Pass: input = 0110 output = 01011111
Pass: input = 0111 output = 01110000
Pass: input = 1000 output = 01111111
Pass: input = 1001 output = 01111011
Pass: input = 1010 output = 01110111
Pass: input = 1011 output = 00011111
Pass: input = 1100 output = 01001110
Pass: input = 1101 output = 00111101
Pass: input = 1110 output = 01001111
Pass: input = 1111 output = 01000111
        16 tests completed with          1 errors
```