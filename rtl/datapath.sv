/* verilator lint_off UNUSED */ // TODO: Remove this
`timescale 1ns/1ps
module datapath(input  logic        clk, reset,
                input  logic [1:0]  RegSrc,
                input  logic        RegWrite,
                input  logic [1:0]  ImmSrc,
                input  logic        ALUSrc,
                input  logic [2:0]  ALUControl,
                input  logic        MemtoReg,
                input  logic        PCSrc,
                output logic [3:0]  ALUFlags,
                output logic [31:0] PC,
                input  logic [31:0] Instr, // TODO: verilator thinks this is unused
                output logic [31:0] ALUResultOut,
                output logic [31:0] WriteData,
                input  logic [31:0] ReadData,
                input  logic        carry,
                input  logic        Shift);

  logic [31:0] PCNext, PCPlus4, PCPlus8;
  logic [31:0] ExtImm, SrcA, SrcB, Result;
  logic [3:0]  RA1, RA2;
  logic [31:0] srcBshifted, ALUResult;

  // next PC logic
  mux2 #(32)  pcmux(PCPlus4, Result, PCSrc, PCNext);
  flopr #(32) pcreg(clk, reset, PCNext, PC);
  adder #(32) pcadd1(PC, 32'b100, PCPlus4);
  adder #(32) pcadd2(PCPlus4, 32'b100, PCPlus8);

  // register file logic
  mux2 #(4)  ra1mux(Instr[19:16], 4'b1111, RegSrc[0], RA1);
  mux2 #(4)  ra2mux(Instr[3:0], Instr[15:12], RegSrc[1], RA2);
  regfile    rf(clk, RegWrite, RA1, RA2,
                Instr[15:12], Result, PCPlus8,
                SrcA, WriteData);
  mux2 #(32) resmux(ALUResultOut, ReadData, MemtoReg, Result);
  extend     ext(Instr[23:0], ImmSrc, ExtImm);

  // ALU logic
  shifter    sh(WriteData, Instr[11:7], Instr[6:5], srcBshifted);
  mux2 #(32) srcbmux(srcBshifted, ExtImm, ALUSrc, SrcB);
  alu        alu(SrcA, SrcB, ALUControl,
                 ALUResult, ALUFlags,
                 carry);
  mux2 #(32) aluresultmux(ALUResult, SrcB, Shift, ALUResultOut);
endmodule
