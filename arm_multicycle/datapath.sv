/* verilator lint_off UNUSED */ // TODO: Remove this
`timescale 1ns/1ps
module datapath(input  logic        clk, reset);

  logic [31:0] PC;
  logic [31:0] PCNext;

  logic        AdrSrc;
  logic [31:0] Adr;

  logic [31:0] A;
  logic        IRWrite;
  logic [31:0] rd1;
  logic [31:0] Instr;
  logic [31:0] ALUResult, ALUOut;
  logic [31:0] ReadData;
  logic [31:0] Data;
  logic        RegWrite;
  logic        ResultSrc;
  logic [31:0] Result;

  // next PC logic
  flopr #(32) pcreg(clk, reset, PCNext, PC);
  mux2 #(32) pcmux(PC, ALUOut, AdrSrc, Adr);
  flopenr #(32) irreg(clk, reset, IRWrite, ReadData, Instr);
  flopr #(32) datareg(clk, reset, ReadData, Data);

  // register file logic
  regfile     rf(clk, RegWrite, ra1, ra2,
                 wa3, Result, r15,
                 rd1, rd2);
  flopr #(32) areg(clk, reset, rd1, A);
  mux2  #(32) resmux(ALUOut, Data, ResultSrc, Result);
  extend      ext(Instr[23:0], ImmSrc, ExtImm);

  // alu
  alu        alu(SrcA, SrcB, ALUControl, ALUResult);
  flopr #(32) aluout(clk, reset, ALUResult, ALUOut);

/* Note: We're stopping on page 410, need to implement
   the ALUSrcA/ALUSrcB muxes and update the Result mux */

endmodule
