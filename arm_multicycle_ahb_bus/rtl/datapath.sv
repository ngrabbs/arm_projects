/* verilator lint_off UNUSED */ // TODO: Remove this
`timescale 1ns/1ps
module datapath(input  logic        clk, reset,
                output logic [31:0] Adr, WriteData,
                input  logic [31:0] ReadData,
                output logic [31:0] Instr,
                output logic [3:0]  ALUFlags,
                input  logic        PCWrite, RegWrite,
                input  logic        IRWrite,
                input  logic        AdrSrc,
                input  logic [1:0]  RegSrc,
                input  logic        ALUSrcA,
                input  logic [1:0]  ALUSrcB, ResultSrc,
                input  logic [1:0]  ImmSrc, ALUControl);

  logic [31:0] PCNext, PC;
  logic [31:0] ExtImm, SrcA, SrcB, Result;
  logic [31:0] Data, rd1, rd2, A, ALUResult, ALUOut;
  logic [3:0]  ra1, ra2;

    // next PC logic
  flopenr #(32) pcreg(clk, reset, PCWrite, Result, PC); // feeds pcmux
  mux2    #(32) pcmux(PC, Result, AdrSrc, Adr); // feeds mem
                                             // mem
  flopenr #(32) irreg(clk, reset, IRWrite, ReadData, Instr); // feeds Instr to regfile / ext
  flopr   #(32) datareg(clk, reset, ReadData, Data);          // feeds irreg

  // register file logic
  mux2     #(4) ra1mux(Instr[19:16], 4'b1111, RegSrc[0], ra1);
  mux2     #(4) ra2mux(Instr[3:0], Instr[15:12], RegSrc[1], ra2);
  regfile       rf(clk, RegWrite, ra1, ra2,
                   Instr[15:12], Result, Result,
                   rd1, rd2);
  flopr   #(32) areg(clk, reset, rd1, A); // reeds ALU from regfile
  flopr   #(32) wdreg(clk, reset, rd2, WriteData);
  extend        ext(Instr[23:0], ImmSrc, ExtImm);

  // alu
  mux2   #(32)  srcamux(A, PC, ALUSrcA, SrcA);
  mux3   #(32)  srcbmux(WriteData, ExtImm, 32'd4, ALUSrcB, SrcB);

  alu           alu(SrcA, SrcB, ALUControl, ALUResult, ALUFlags); // fed from reg file into aluout flop

  flopr  #(32)  aluout(clk, reset, ALUResult, ALUOut); //  feeds into resmux
  mux3   #(32)  resmux(ALUOut, Data, ALUResult, ResultSrc, Result);  // last step of loop

endmodule
