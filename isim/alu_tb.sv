/* verilator lint_off WIDTH */
/* verilator lint_off BLKSEQ */
`timescale 1ns/1ps
module alu_tb();
  logic        clk, reset;
  logic [31:0] SrcA, SrcB, ALUResult, ALUResult_expected;
  logic [3:0]  ALUControl;
  logic [3:0]  ALUFlags;
  logic        carry;
  logic [31:0] vectornum, errors;
  logic [100:0] testvectors[10000:0];

  // dut
  alu dut(SrcA, SrcB, ALUControl, ALUResult, ALUFlags, carry);

  // generate clock
  always
    begin
      clk = 1; #5; clk = 0; #5;
    end


  // at start of test, load vectors
  // and pulse reset
  initial
    begin
      $readmemb("isim/alu.tv", testvectors);
      vectornum=0; errors=0;
      reset = 1; #27; reset = 0;
    end

  // apply test vectors on rising edge of clk
  always @(posedge clk)
    begin
//      $display("Testvector %b", testvectors[vectornum]);
      #1; {ALUControl, carry, SrcA, SrcB, ALUResult_expected} = testvectors[vectornum];

    end

  // check results on falling edge of clk
  always @(negedge clk)
      if (~reset) begin // skip during reset
    if ( ALUResult !== ALUResult_expected) begin // check result
      $display("Error: Cont = %b carryin = %b condinvb = %h sum = %h SrcA = %h SrcB = %h ALUResult = %h ALUFlags = %b (%h expected)", ALUControl, dut.carryin, dut.condinvb, dut.sum, SrcA, SrcB, ALUResult, ALUFlags, ALUResult_expected);
      errors = errors + 1;
    end else begin
      $display("Pass:  Cont = %b carryin = %b condinvb = %h sum = %h SrcA = %h SrcB = %h ALUResult = %h ALUFlags = %b", ALUControl, dut.carryin, dut.condinvb, dut.sum, SrcA, SrcB, ALUResult, ALUFlags);
    end

    vectornum = vectornum + 1;

    if (testvectors[vectornum] === 101'bx) begin
      $display("%d tests completed with %d errors",
        vectornum, errors);
      $finish;
    end
  end

endmodule
