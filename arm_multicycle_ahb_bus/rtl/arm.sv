/* verilator lint_off UNUSED */
`timescale 1ns/1ps
module arm(input  logic        clk, reset,
           output logic        MemWrite,
           output logic [31:0] Adr, WriteData,
           input  logic [31:0] ReadData);

  logic [31:0] Instr;
  logic [3:0]  ALUFlags;
  logic        PCWrite, RegWrite, IRWrite;
  logic        AdrSrc, ALUSrcA;
  logic [1:0]  RegSrc, ALUSrcB, ImmSrc, ResultSrc;
  logic [2:0]  ALUControl;
  logic        carry;
  logic        Shift;

  controller c(clk, reset, Instr[31:12], ALUFlags,
               PCWrite, MemWrite, RegWrite, IRWrite,
               AdrSrc, RegSrc, ALUSrcA, ALUSrcB, ResultSrc,
               ImmSrc, ALUControl, carry, Shift);
  datapath  dp(clk, reset, Adr, WriteData, ReadData, Instr, ALUFlags,
               PCWrite, RegWrite, IRWrite,
               AdrSrc, RegSrc, ALUSrcA, ALUSrcB, ResultSrc,
               ImmSrc, ALUControl, carry, Shift);

endmodule
