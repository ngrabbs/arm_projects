module condlogic(input logic clk, reset,
input  logic [3:0] Cond,
input  logic [3:0] ALUFlags,
input  logic [1:0] FlagW,
input  logic       PCS, RegW, MemW,
output logic       PCSrc, RegWrite, MemWrite,
output logic       carry,
input  logic       NoWrite);

  logic [1:0] FlagWrite;
  logic [3:0] Flags;
  logic       CondEx;

  flopenr #(2)flagreg1(clk, reset, FlagWrite[1],
                       ALUFlags[3:2], Flags[3:2]);
  flopenr #(2)flagreg0(clk, reset, FlagWrite[0],
                       ALUFlags[1:0], Flags[1:0]);
  
  // write controls are condititional
  condcheck cc(Cond, Flags, CondEx);
  assign FlagWrite = FlagW & {2{CondEx}};
  assign RegWrite  = RegW  & CondEx & ~NoWrite;
  assign MemWrite  = MemW  & CondEx;
  assign PCSrc     = PCS   & CondEx;

  assign carry     = Flags[1];
endmodule
