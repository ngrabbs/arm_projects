`timescale 1ns/1ps
/* verilator lint_off UNUSED */
module mux4 #(parameter WIDTH=8)
             (input  logic [WIDTH-1:0] d0, d1, d2, d3,
              input  logic [3:0]       s,
              output logic [WIDTH-1:0] y);
  /*
  assign y = s[1] ? (s[0] ? d3 : d2)
                  : (s[0] ? d1 : d0);
  */
  always_comb
    if      (s[3]) y = d3;
    else if (s[2]) y = d2;
    else if (s[1]) y = d1;
    else           y = d0;

endmodule
