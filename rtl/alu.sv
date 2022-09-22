`timescale 1ns/1ps
/* verilator lint_off CASEINCOMPLETE */
module alu(input  logic [31:0] SrcA, SrcB,
           input  logic [3:0]  ALUControl,
           output logic [31:0] ALUResult,
           output logic [3:0]  ALUFlags,
           input  logic        carry);

  logic        neg, zero, carryout, overflow;
  logic [31:0] condinva, condinvb;
  logic [32:0] sum;
  logic        carryin;

  assign carryin = ALUControl[3] ? carry : ALUControl[0];

  assign condinvb = ALUControl[0] ? ~SrcB : SrcB; // invert for subtract
  assign condinva = ALUControl[0] ? ~SrcA : SrcA; // invert for subtract

  /* verilator lint_off WIDTH */
  assign sum = (ALUControl[2:0] == 3'b101) ? SrcB + condinva + carryin : SrcA + condinvb + carryin;

  always_comb
    casez (ALUControl[2:0])
      3'b00?: ALUResult = sum;
      3'b010: ALUResult = SrcA & SrcB;
      3'b011: ALUResult = SrcA | SrcB;
      3'b100: ALUResult = SrcA ^ SrcB;
    endcase

  assign neg = ALUResult[31];
  assign zero = (ALUResult == 32'b0);
  assign carryout = (ALUControl[1] == 1'b0) & sum[32];
  assign overflow = (ALUControl[1] == 1'b0) &
                    ~(SrcA[31] ^ SrcB[31] ^ ALUControl[0]) &
                    (SrcA[31] ^ sum[31]);

  assign ALUFlags = {neg, zero, carryout, overflow};
endmodule
