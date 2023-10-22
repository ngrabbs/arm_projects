/* verilator lint_off WIDTH */
/* verilator lint_off UNUSED */
`timescale 1ns/1ps
module ahb_led(input  logic        HCLK,
               input  logic        HSEL,
               input  logic        HWRITE,
               input  logic [31:0] HWDATA,
               output logic [2:0] ledPins);

  always_ff @(posedge HCLK) begin
   // if (HWRITE & HSEL) begin
    if (HSEL) begin
      ledPins[0] <= HWDATA[0];
      ledPins[1] <= HWDATA[1];
      ledPins[2] <= HWDATA[2];
    end
  end

endmodule
