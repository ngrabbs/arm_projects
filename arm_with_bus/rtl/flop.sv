`timescale 1ns/1ps
module flop #(parameter WIDTH=8)
              (input  logic             clk,
               input  logic [WIDTH-1:0] d,
               output logic [WIDTH-1:0] q);
  always_ff @(posedge clk)
    q <= d;
endmodule
