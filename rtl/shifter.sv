`timescale 1ns/1ps
module shifter(input  logic [31:0] a,
               input  logic [ 4:0] shamt,
               input  logic [ 1:0] shtype,
               output logic [31:0] y);
  always_comb
    case (shtype)
      2'b00:   y = a << shamt;
      2'b01:   y = a >> shamt;
      default: y = a;
    endcase
endmodule
