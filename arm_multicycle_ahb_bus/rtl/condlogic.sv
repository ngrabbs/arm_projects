`timescale 1ns/1ps
module condlogic(input logic clk, reset,
                input  logic [3:0] Cond,
                input  logic [3:0] ALUFlags,
                input  logic [1:0] FlagW,
                input  logic       PCS, NextPC, RegW, MemW,
                output logic       PCWrite, RegWrite, MemWrite,
                input  logic       NoWrite);

  logic [1:0] FlagWrite;
  logic [3:0] Flags;
  logic       CondEx, CondExDelayed;

  flopenr #(2)flagreg1(clk, reset, FlagWrite[1],
                       ALUFlags[3:2], Flags[3:2]);
  flopenr #(2)flagreg0(clk, reset, FlagWrite[0],
                       ALUFlags[1:0], Flags[1:0]);

  // write controls are condititional
  condcheck cc(Cond, Flags, CondEx);
  flopr #(1) condreg(clk, reset, CondEx, CondExDelayed);
  assign FlagWrite = FlagW & {2{CondEx}};
  assign RegWrite  = RegW  & CondExDelayed & ~NoWrite;
  assign MemWrite  = MemW  & CondExDelayed;
  assign PCWrite   = (PCS  & CondExDelayed) | NextPC;

endmodule
