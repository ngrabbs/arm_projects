`timescale 1ns/1ps
module decoder(input  logic       clk, reset,
               input  logic [1:0] Op,
               input  logic [5:0] Funct,
               input  logic [3:0] Rd,
               output logic [1:0] FlagW,
               output logic       PCS, NextPC, RegW, MemW,
               output logic       IRWrite, AdrSrc,
               output logic [1:0] ResultSrc,
               output logic       ALUSrcA,
               output logic [1:0] ALUSrcB, ImmSrc, RegSrc, ALUControl,
               output logic       NoWrite);

  logic        Branch, ALUOp;

  // Main FSM
  mainfsm fsm(clk, reset, Op, Funct,
              IRWrite, AdrSrc,
              ALUSrcA, ALUSrcB, ResultSrc,
              NextPC, RegW, MemW, Branch, ALUOp);
  always_comb
    if (ALUOp) begin // which Data-processing Instr?
      case (Funct[4:1])
            4'b0100: ALUControl = 2'b00; // ADD
            4'b0010: ALUControl = 2'b01; // SUB
            4'b0000: ALUControl = 2'b10; // AND
            4'b1100: ALUControl = 2'b11; // ORR
            4'b1010: ALUControl = 2'b01; // CMP
            default: ALUControl = 2'bx;  // unimplemented
      endcase
      FlagW[1] = Funct[0]; // update N & Z flags if S bit is set
      FlagW[0] = Funct[0] & (ALUControl == 2'b00 | ALUControl == 2'b01);
    end else begin
      ALUControl = 2'b00; // add for non data-processing instructions
      FlagW      = 2'b00; // don't update Flags
    end

  // assign no write
  assign NoWrite = (Funct[4:1] === 4'b1010) ? 1'b1 : 1'b0;

  // PC Logic
  assign PCS = ((Rd == 4'b1111) & RegW) | Branch;

  // Instr Decoder
  assign ImmSrc    = Op;
  assign RegSrc[0] = (Op == 2'b10); // read PC on Branch
  assign RegSrc[1] = (Op == 2'b01); // read Rd on STR

endmodule
