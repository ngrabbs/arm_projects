/* verilator lint_off WIDTH */ // TODO: remove this
/* verilator lint_off UNUSED */ // TODO: remove this
module dmem(input  logic        clk, we,
            input  logic [31:0] a, wd, // TODO: verilator thinks a is unused why?
            output logic [31:0] rd);

  logic [31:0] RAM[63:0];

  // TODO: verilator is complaining about this
  assign rd = RAM[a[31:2]]; // word aligned

  always_ff @(posedge clk)
    if (we) RAM[a[31:2]] <= wd;
endmodule
