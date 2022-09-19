/* verilator lint_off WIDTH */ // TODO: remove this
/* verilator lint_off UNUSED */ // TODO: remove this
module dmem#(
  parameter ADDR_W = 8,
  parameter DATA_W = 32
) (
  input  logic         clk, we,
  input  logic [ADDR_W-1:0] a,
  input  logic [DATA_W-1:0] wd,
  output logic [DATA_W-1:0] rd);

//  logic [31:0] RAM[63:0];
//  logic [7:0] RAM[0:3];
  logic [7:0] RAM[0:2**ADDR_W-1];
//  logic [7:0] RAM[0:2**
//logic [32:0] RAM[0:2**8-1];

  // TODO: verilator is complaining about this
  //assign rd = RAM[a[31:2]]; // word aligned
  always @(posedge clk)
  begin
    if (we)
      RAM[a[7:2]] <= wd;

    rd <= RAM[a[7:2]];
  end
endmodule

