`timescale 1ns/1ps
/* verilator lint_off CASEINCOMPLETE */
/* verilator lint_off COMBDLY */
module ahb_mux(input  logic [3:0]  HSEL,
               input  logic [31:0] HRDATA0, HRDATA1, HRDATA2, HRDATA3,
               output logic [31:0] HRDATA);
  always_comb
    casez(HSEL)
      4'b???1: HRDATA <= HRDATA0;
      4'b??10: HRDATA <= HRDATA1;
      4'b?100: HRDATA <= HRDATA2;
      4'b1000: HRDATA <= HRDATA3;
    endcase
endmodule
