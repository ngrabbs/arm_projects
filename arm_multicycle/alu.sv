`timescale 1ns/1ps
/* verilator lint_off CASEINCOMPLETE */
module alu(input  logic [31:0] SrcA, SrcB,
           input  logic [2:0]  ALUControl,
           output logic [31:0] ALUResult);


  logic [31:0] sum;

  assign sum = SrcA + SrcB;

  always_comb
    casez (ALUControl[2:0])
      3'b00?: ALUResult = sum;
    endcase

endmodule
