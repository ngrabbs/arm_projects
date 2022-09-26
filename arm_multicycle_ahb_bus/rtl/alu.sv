`timescale 1ns/1ps
/* verilator lint_off WIDTH */
/* verilator lint_off CASEINCOMPLETE */
module alu(input  logic [31:0] SrcA, SrcB,
           input  logic [2:0]  ALUControl,
           output logic [31:0] Result,
           output logic [3:0]  ALUFlags,
           input  logic        carry);

  logic        neg, zero, carryout, overflow;
  logic [31:0] condinvb;
  logic [32:0] sum;
  logic        carryin;

  assign carryin = ALUControl[2] ? carry : ALUControl[0];

  assign condinvb = ALUControl[0] ? ~SrcB : SrcB;
  assign sum = SrcA + condinvb + carryin;


  always_comb
    casez (ALUControl[1:0])
      2'b0?: Result = sum;
      2'b10: Result = SrcA & SrcB;
      2'b11: Result = SrcA | SrcB;
    endcase

assign neg = Result[31];
assign zero = (Result == 32'b0);
assign carryout = (ALUControl[1] == 1'b0) & sum[32];
assign overflow = (ALUControl[1] == 1'b0) & ~(SrcA[31] ^ SrcB[31] ^
                       ALUControl[0]) & (SrcA[31] ^ sum[31]);
assign ALUFlags = {neg, zero, carryout, overflow};

endmodule
