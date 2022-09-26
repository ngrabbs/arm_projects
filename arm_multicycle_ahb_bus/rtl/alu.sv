`timescale 1ns/1ps
/* verilator lint_off WIDTH */
/* verilator lint_off CASEINCOMPLETE */
module alu(input  logic [31:0] SrcA, SrcB,
           input  logic [1:0]  ALUControl,
           output logic [31:0] Result,
           output logic [3:0]  ALUFlags);

  logic        neg, zero, carry, overflow;
  logic [31:0] condinvb;
  logic [32:0] sum;

  assign condinvb = ALUControl[0] ? ~SrcB : SrcB;
  assign sum = SrcA + condinvb + ALUControl[0];


  always_comb
    casez (ALUControl[1:0])
      2'b0?: Result = sum;
      2'b10: Result = SrcA & SrcB;
      2'b11: Result = SrcA | SrcB;
    endcase

assign neg = Result[31];
assign zero = (Result == 32'b0);
assign carry = (ALUControl[1] == 1'b0) & sum[32];
assign overflow = (ALUControl[1] == 1'b0) & ~(SrcA[31] ^ SrcB[31] ^
                       ALUControl[0]) & (SrcA[31] ^ sum[31]);
assign ALUFlags = {neg, zero, carry, overflow};

endmodule
