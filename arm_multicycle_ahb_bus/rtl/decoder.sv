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
               output logic [1:0] ALUSrcB, ImmSrc, RegSrc,
               output logic [2:0] ALUControl,
               output logic       NoWrite,
               output logic       Shift);

  logic        Branch, ALUOp;

  // Main FSM
  mainfsm fsm(clk, reset, Op, Funct,
              IRWrite, AdrSrc,
              ALUSrcA, ALUSrcB, ResultSrc,
              NextPC, RegW, MemW, Branch, ALUOp);
  always_comb
    if (ALUOp) begin // which Data-processing Instr?
      case (Funct[4:1])
            4'b0100: begin ALUControl = 3'b000; // ADD
                           Shift = 1'b0;
                           NoWrite = 1'b0;
                     end
            4'b0010: begin ALUControl = 3'b001; // SUB
                           Shift = 1'b0;
                           NoWrite = 1'b0;
                     end
            4'b0000: begin ALUControl = 3'b010; // AND
                           Shift = 1'b0;
                           NoWrite = 1'b0;
                     end
            4'b1100: begin ALUControl = 3'b011; // ORR
                           Shift = 1'b0;
                           NoWrite = 1'b0;
                     end
            4'b1101: begin ALUControl = 3'b000; // ASR, ROR
                           Shift = 1'b1;
                           NoWrite = 1'b0;
                     end
            4'b1000: begin ALUControl = 3'b010; // TST
                           Shift = 1'b0;
                           NoWrite = 1'b1;
                     end
            4'b0110: begin ALUControl = 3'b101; // SBC
                           Shift = 1'b0;
                           NoWrite = 1'b0;
                     end
            4'b1010: begin ALUControl = 3'b001; // CMP
                           Shift = 1'b0;
                           NoWrite = 1'b1;
                     end
            default: begin ALUControl = 3'bx;  // unimplemented
                           Shift = 1'bx;
                           NoWrite = 1'bx;
                     end
      endcase
      FlagW[1] = Funct[0]; // update N & Z flags if S bit is set
      FlagW[0] = Funct[0] & (ALUControl[1:0] == 2'b00 | ALUControl[1:0] == 2'b01);
    end else begin
      ALUControl = 3'b000; // add for non data-processing instructions
      FlagW      = 2'b00;  // don't update Flags
      Shift      = 1'b0;   // don't shift
      NoWrite    = 1'b0;   // write results
    end

  // PC Logic
  assign PCS = ((Rd == 4'b1111) & RegW) | Branch;

  // Instr Decoder
  assign ImmSrc    = Op;
  assign RegSrc[0] = (Op == 2'b10); // read PC on Branch
  assign RegSrc[1] = (Op == 2'b01); // read Rd on STR

endmodule
