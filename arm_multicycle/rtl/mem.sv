/* verilator lint_off WIDTH */
/* verilator lint_off UNUSED */
`timescale 1ns/1ps
module mem(input  logic        clk, we,
           input  logic [31:0] a, wd,
           output logic [31:0] rd);

  logic [31:0] RAM[63:0];
  initial
    $readmemh("isim/memfile_test.dat", RAM);

  assign rd = RAM[a[31:2]];  // word aligned

  always_ff @(posedge clk)
    if (we) RAM[a[31:2]] <= wd;

endmodule
