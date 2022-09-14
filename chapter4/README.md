# Digital Design and Computer Architecture Exercises
Exercises and examples from Digital Design and Computer Architecture - Harris &amp; Harris

## Chapter 4 exercises
### Exercise 4.3
Write an HDL module that computes a four-input XOR function.  The input is a[3:0] and the output is y. 
[exercise4.3](https://github.com/ngrabbs/dd_and_ca_fpga/blob/main/chapter4/exercise4_3.sv):
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
  assign y = ~a & ~b | ~a & ~c | ~b & ~c;

endmodule
```

### Exercise 4.6
Write an HDL module for a hexadecimal seven-segment display decoder.  The decoder should handle the digits A, B, C, D, E and F as well as 0-9.
[exercise4.6](https://github.com/ngrabbs/dd_and_ca_fpga/blob/main/chapter4/exercise4_6.sv):
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
[exercise4.7](https://github.com/ngrabbs/dd_and_ca_fpga/blob/main/chapter4/exercise4_7_tb.sv):
```systemverilog
module exercise4_7();
  logic        clk, reset;
  logic [3:0]  data;
  logic [7:0]  s;
  logic [7:0]  s_expected;
  logic [31:0] vectornum, errors;
  logic [11:0] testvectors[10000:0];

  // dut
  sevenseg dut(data, s);

  // generate clock
  always
    begin
      clk = 1; #5; clk = 0; #5;
    end


  // at start of test, load vectors
  // and pulse reset
  initial
    begin
      $readmemb("exercise4_7.tv", testvectors);
      vectornum=0; errors=0;
      reset = 1; #27; reset = 0;
    end

  // apply test vectors on rising edge of clk
  always @(posedge clk)
    begin
      #1; {data, s_expected} = testvectors[vectornum];
    end

  // check results on falling edge of clk
  always @(negedge clk)
    if (~reset) begin // skip during reset
        if ( s !== s_expected) begin // check result
          $display("Error: input = %b output = %b (%b expected)", data, s, s_expected);
          errors = errors + 1;
        end else begin
          $display("Pass: input = %b output = %b", data, s);
        end

        vectornum = vectornum + 1;

        if (testvectors[vectornum] === 12'bx) begin
          $display("%d tests completed with %d errors", 
            vectornum, errors);
          $finish;
        end
      end

endmodule
```

test vectors
[exercise4.7.tv](https://github.com/ngrabbs/dd_and_ca_fpga/blob/main/chapter4/exercise4_7.tv):
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

### Exercise 4.8
Write an 8:1 multiplexer module called mux8 with inputs s[2:0], d0, d1, d2, d3, d4, d5, d6, d7, and output y.
[exercise4.8](https://github.com/ngrabbs/dd_and_ca_fpga/blob/main/chapter4/exercise4_8.sv):
```systemverilog
module mux8_1(input logic [2:0] a,
            input logic d0, d1, d2, d3, d4, d5, d6, d7,
            output logic y);
  assign y = (a ==? 3'b000) ? d0 :
             (a ==? 3'b001) ? d1 :
             (a ==? 3'b010) ? d2 :
             (a ==? 3'b011) ? d3 :
             (a ==? 3'b100) ? d4 :
             (a ==? 3'b101) ? d5 :
             (a ==? 3'b110) ? d6 :
             (a ==? 3'b111) ? d7 :
                    3'b000;
endmodule
```

### Exercise 4.9
Write a structural module to compute the logic function, y = a~b + ~b~c + ~abc,
using multiplexer logic.  Use the 8:1 multiplexer from Exercise 4.8.
```systemverilog
module ex4_9(input  logic a, b, c,
             output logic y);
  mux8 #(1) mux8_1({a,b,c}, 1'b1, 1'b0, 1'b0, 1'b1,
                            1'b1, 1'b1, 1'b0, 1'b0, y);
endmodule
```

### Exercise 4.10
Repeat Exercise 4.9 using a 4:1 multiplexer and as many NOT gates as you need.

### Exercise 4.11
Section 4.5.4 pointed out that a synchronizer could be correctly
describe with blocking assignments if the assignments were given in the proper
order.  Think of a simple sequential circuit that cannot be correctly described with
blocking assignments, regardless of order.

### Exercise 4.12
Write an HDL module for an eight-input priority circuit.
```systemverilog
module priorityckt(input  logic [8:0] a,
                   output logic [8:0] y);
  always_comb
    if      (a[7]) y = 8'b10000000;
    else if (a[6]) y = 8'b01000000;
    else if (a[5]) y = 8'b00100000;
    else if (a[4]) y = 8'b00010000;
    else if (a[3]) y = 8'b00001000;
    else if (a[2]) y = 8'b00000100;
    else if (a[1]) y = 8'b00000010;
    else if (a[0]) y = 8'b00000001;
    else           y = 8'b00000000;
endmodule
```

### Exercise 4.13
Write an HDL module for a 2:4 decoder.
```systemverilog
module decoder2_4(input  logic [1:0] a,
                  output logic [3:0] y);
  always_comb
    case (a)
    2'b00: y = 4'b0001;
    2'b01: y = 4'b0010;
    2'b10: y = 4'b0100;
    2'b11: y = 4'b1000;
endmodule
```

### Exercise 4.14
Write an HDL module for a 6:64 decoder using three instances of
the 2:4 decoders from Exercise 4.13 and a bunch of three-input AND gates.
```systemverilog

```

### Exercise 4.15
Write HDL modules that implement the Boolean equations from Exercise 2.13.
(a) y = ac + ~a~bc
```systemverilog
module ex4_15a(input  logic a, b,c,
               output logic y);
  y = (a & c) | (~a & ~b & c);
endmodule
```

(b) y = ~a~b + ~ab~c + ~(a+~c)
```systemverilog
module ex4_15b(input  logic a, b, c,
               output logic y);
  y = (~a & ~b) | (~a & b & ~c) | ~(a | ~c);
endmodule
```

(c) y = ~a~b~c~d + a~b~c + a~bc~d + abd + ~a~bc~d + b~cd + ~a
```systemverilog
module ex4_15c(input  logic a, b, c, d,
               output logic y);
  y = (~a & ~b & ~c & ~d) | (a & ~b & ~c) |
      (a & ~b & c & ~d) | ( a & b & d) |
      (~a & ~b & c & ~d) | (b & ~c & d) | ~a;
endmodule
```

### Exercise 4.16
Write an HDL module that implements the circuit from Exercise 2.26.
```systemverilog
module ex4_16(input  logic a, b, c, d, e,
              output logic y);
  y = ~(e & ~a & ~b & ~c & ~d);
endmodule
```

### Exercise 4.17
Write an HDL module that implements the circuit from Exercise 2.27.
```systemverilog
module ex_17(input  logic a, b, c, d, e, f, g,
             output logic y);
  n1 = ~(a & b & c);
  n2 = ~(n1 & d);
  n3 = (f & g);
  n4 = ~(e | n3);
  n5 = ~(n2 | n4);
  y = ~(n5 & n5);
endmodule
```

### Exercise 4.18
Write an HDL module that implements the logic function from
Exercise 2.28.  Pay careful attention to how you handle don't cares.
```systemverilog
module ex_18(input  logic a, b, c, d,
             output logic y);
  n1 = (b | c | ~d);
  y = (a & n1);
endmodule
```

### Exercise 4.19
Write an HDL module that implements the logic function from
Exercise 2.35.
```systemverilog
module ex4_19(input  logic [3:0] a,
              output logic p, d);
  always_comb
    case (a)
      4'b0000: {p, d} = 2'b00; // 0
      4'b0001: {p, d} = 2'b00; // 1
      4'b0010: {p, d} = 2'b01; // 2
      4'b0011: {p, d} = 2'b11; // 3
      4'b0100: {p, d} = 2'b00; // 4 
      4'b0101: {p, d} = 2'b01; // 5
      4'b0110: {p, d} = 2'b10; // 6
      4'b0111: {p, d} = 2'b01; // 7
      4'b1000: {p, d} = 2'b00; // 8
      4'b1001: {p, d} = 2'b10; // 9
      4'b1010: {p, d} = 2'b00; // 10
      4'b1011: {p, d} = 2'b01; // 11
      4'b1100: {p, d} = 2'b10; // 12
      4'b1101: {p, d} = 2'b01; // 13
      4'b1110: {p, d} = 2'b00; // 14
      4'b1111: {p, d} = 2'b10; // 15
    endcase
endmodule
```

### Exercise 4.20
Write an HDL module that implements the priority encoder from
Exercise 2.36.
```systemverilog
module ex4_20(input  logic [7:0] a,
              output logic [2:0] y,
              output logic none);
  assign y = (a ==? 8'b1???????) ? 3'b111 :
             (a ==? 8'b01??????) ? 3'b110 :
             (a ==? 8'b001?????) ? 3'b101 :
             (a ==? 8'b0001????) ? 3'b100 :
             (a ==? 8'b00001???) ? 3'b011 :
             (a ==? 8'b000001??) ? 3'b010 :
             (a ==? 8'b0000001?) ? 3'b001 :
             (a ==? 8'b00000001) ? 3'b000 :
                                   3'b000;
  assign none = (a ==? 8'b00000000) ? 1'b1 : 1'b0;
endmodule  
```

### Exercise 4.21
Write an HDL module that implements the modified priority encoder from
Exercise 2.37.
```systemverilog
module ex4_21(input  logic [7:0] a,
              output logic [2:0] y, z,
              output logic none);
  always_comb
  begin
    casez (a)
      8'b00000000: begin y = 3'd0; none = 1'b1; end
      8'b00000001: begin y = 3'd0; none = 1'b1; end
      8'b0000001?: begin y = 3'd1; none = 1'b1; end
      8'b000001??: begin y = 3'd2; none = 1'b1; end
      8'b00001???: begin y = 3'd3; none = 1'b1; end
      8'b0001????: begin y = 3'd4; none = 1'b1; end
      8'b001?????: begin y = 3'd5; none = 1'b1; end
      8'b01??????: begin y = 3'd6; none = 1'b1; end
      8'b1???????: begin y = 3'd7; none = 1'b1; end
    endcase

    casez (a)
      8'b00000011: z = 3'b000;
      8'b00000101: z = 3'b000;
      8'b00001001: z = 3'b000;
      8'b00010001: z = 3'b000;
      8'b00100001: z = 3'b000;
      8'b01000001: z = 3'b000;
      8'b10000001: z = 3'b000;
      8'b0000011?: z = 3'b001;
      8'b0000101?: z = 3'b001;
      8'b0001001?: z = 3'b001;
      8'b0010001?: z = 3'b001;
      8'b0100001?: z = 3'b001;
      8'b1000001?: z = 3'b001;
      8'b000011??: z = 3'b010;
      8'b000101??: z = 3'b010;
      8'b001001??: z = 3'b010;
      8'b010001??: z = 3'b010;
      8'b100001??: z = 3'b010;
      8'b00011???: z = 3'b011;
      8'b00101???: z = 3'b011;
      8'b01001???: z = 3'b011;
      8'b10001???: z = 3'b011;
      8'b0011????: z = 3'b100;
      8'b0101????: z = 3'b100;
      8'b1001????: z = 3'b100;
      8'b011?????: z = 3'b101;
      8'b101?????: z = 3'b101;
      8'b11??????: z = 3'b110;
      default:     z = 3'b000;
    endcase
  end
endmodule
```

### Exercise 4.22
Write an HDL module that implements the binary-to-thermometer
code converter from Exercise 2.38.
```systemverilog
module ex4_22(input  logic [2:0] a,
              output logic [7:0] y);
  always_comb
    case (a)
      3'b000: y = 8'b00000001;
      3'b001: y = 8'b00000011;
      3'b010: y = 8'b00000111;
      3'b011: y = 8'b00001111;
      3'b100: y = 8'b00011111;
      3'b101: y = 8'b00111111;
      3'b110: y = 8'b01111111;
      3'b111: y = 8'b11111111;
    endcase
endmodule
```

### Exercise 4.23
Write an HDL module implementing the days-in-month function
from Question 2.2.
```systemverilog
module ex4_32(input  logic [3:0] month,
              output logic       y);
  always_comb
    casez (month)
      1:       1'b1;
      2:       1'b0;
      3:       1'b1;
      4:       1'b0;
      5:       1'b1;
      6:       1'b0;
      7:       1'b1;
      8:       1'b1;
      9:       1'b0;
      10:      1'b1;
      11:      1'b0;
      12:      1'b1;
      default: 1'b0;
    endcase
endmodule
```

### Exercise 4.24
Sketch the state transition diagram for the FSM described by the
following HDL code.

### Exercise 4.25
Sketch the state transition diagram for the FSM described by the
following HDL code.  And FSM of this nature is used in a branch predictor on some
microprocessors.

### Exercise 4.26
Write an HDL module for an SR latch.
```systemverilog
module srlatch(input  logic clk,
               input  logic d,
               output logic q);
  

endmodule
```

### Exercise 4.27
Write an HDL module for a JK flip-flop.  The flip-flop has inputs,
clk, J and K, and output Q.  On the rising edge of the clock, Q keeps its old value
if J = K = 0.  It sets Q to 1 if J = 1, resets Q to 0 if K = 1, and inverts Q if J = K = 1;
```systemverilog
module jkflop(input  logic clk, j, j
            output logic q);
  always @(posedge clk)
    case ({j, k})
      2'b01: q <= 1'b0;
      2'b10: q <= 1'b1;
      2'b11: q <= ~q;
    endcase
endmodule          
)
```

### Exercise 4.28
Write an HDL module for the latch from Figure 3.18.  Use one
assignment statement for each gate.  Specify delays of 1 unit or 1 ns to each gate.
Simulate the latch and show that it operates correctly.  Then increase the inverter
delay.  How long doe sthe delay have to be before a race condition causes the latch
to malfunction?
```systemverilog
module latch(input  logic clk,
             input  logic d,
             output logic q);

  logic n1, n2;

  assign n1 = d & clk;
  assign n2 = q & ~clk;
  assign q = n1 | n2;
endmodule
```

### Exercise 4.29
Write an HDL module for the traffic light controller from Section 3.4.1
```systemverilog
module exercise4_29(input  logic clk, reset, ta, tb
                    output logic [1:0] la, lb);

  type enum logic [1:0] { S0, S1, S2, S3} statetype;
  statetype [1:0] state, nextstate;

  parameter green  = 2'b00;
  parameter yellow = 2'b01;
  parameter red    = 2'b10;

  // State Register
  always_ff @(posedge clk, posedge reset)
    if (reset) state <= S0;
    else       state <= nextstate;
  // Next State Logic
  always_comb
    case (state)
      S0: if (ta) nextstate = S0;
          else    nextstate = S1;
      S1:         nextstate = S2;
      S2: if (tb) nextstate = S2;
          else    nextstate = S3;
      S3:         nextstate = S0;
    endcase
  // Output Logic
  always_comb
    case (state)
      S0: {la, lb} = green,  red;
      S1: {la, lb} = yellow, red; 
      S2: {la, lb} = red,    green; 
      S3: {la, lb} = red,    yellow; 
    endcase
endmodule
```