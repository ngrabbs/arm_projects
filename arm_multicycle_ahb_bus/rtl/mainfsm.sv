/* verilator lint_off UNUSED */
`timescale 1ns/1ps
module mainfsm(input  logic       clk,
               input  logic       reset,
               input  logic [1:0] Op,
               input  logic [5:0] Funct,
               output logic       IRWrite,
               output logic       AdrSrc, ALUSrcA,
               output logic [1:0] ALUSrcB, ResultSrc,
               output logic       NextPC, RegW, MemW, Branch, ALUOp);
  typedef enum logic [3:0] {FETCH, DECODE, MEMADR, MEMRD, MEMWB,
                            MEMWR, EXECUTER, EXECUTEI, ALUWB, BRANCH,
                            UNKNOWN} statetype;
  statetype state, nextstate;
  logic [11:0] controls;

  // state register
  always @(posedge clk or posedge reset)
    if (reset) state <= FETCH;
    else state <= nextstate;

  // next state logic
  always_comb
    case(state)
      FETCH:                     nextstate = DECODE;
      DECODE: case(Op)
                2'b00:
                  if (Funct[5])  nextstate = EXECUTEI;
                  else           nextstate = EXECUTER;
                2'b01:           nextstate = MEMADR;
                2'b10:           nextstate = BRANCH;
                default:         nextstate = UNKNOWN;
              endcase
      EXECUTER:                  nextstate = ALUWB;
      EXECUTEI:                  nextstate = ALUWB;
      MEMADR:
        if (Funct[0])            nextstate = MEMRD;
        else                     nextstate = MEMWR;
      MEMRD:                     nextstate = MEMWB;
      default:                   nextstate = FETCH;
    endcase

  // state-dependent output logic
  always_comb
    case(state)
      FETCH:     controls = 12'b10001_010_1100;
      DECODE:    controls = 12'b00000_010_1100;
      EXECUTER:  controls = 12'b00000_000_0001;
      EXECUTEI:  controls = 12'b00000_000_0011;
      ALUWB:     controls = 12'b00010_000_0000;
      MEMADR:    controls = 12'b00000_000_0010;
      MEMWR:     controls = 12'b00100_100_0000;
      MEMRD:     controls = 12'b00000_100_0000;
      MEMWB:     controls = 12'b00010_001_0000;
      BRANCH:    controls = 12'b01000_010_0010;
      default:   controls = 12'bxxxxx_xxx_xxxx;
    endcase

  assign {NextPC, Branch, MemW, RegW, IRWrite,
          AdrSrc, ResultSrc,
          ALUSrcA, ALUSrcB, ALUOp} = controls;

endmodule
