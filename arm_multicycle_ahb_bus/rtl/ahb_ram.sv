/* verilator lint_off WIDTH */
/* verilator lint_off UNUSED */
`timescale 1ns/1ps
module ahb_ram(input  logic        HCLK,
               input  logic        HSEL,
               input  logic [16:2] HADDR,
               input  logic        HWRITE,
               input  logic [31:0] HWDATA,
               output logic [31:0] HRDATA);

//  logic [31:0] ram[32767:0]; // 128KB RAM organized as 32K x 32 bits
  logic [31:0] ram[10:0];  // 128KB RAM organized as 32K x 32 bits
  assign HRDATA = ram[HADDR]; // *** check addressing is correct

  always_ff @(posedge HCLK)
    if (HWRITE & HSEL) ram[HADDR] <= HWDATA;

endmodule
