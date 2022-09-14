/* verilator lint_off WIDTH */ // TODO: remove this
/* verilator lint_off UNUSED */ // TODO: remove this
module dmem#(
  parameter ADDR_W = 8,
  parameter DATA_W = 32 
) (input  logic        clk, we,
            input  logic [ADDR_W-1:0] a,
            input  logic [DATA_W-1:0] wd,
            output logic [DATA_W-1:0] rd);

  /*
  Info: Device utilisation:
  //logic [31:0] RAM[1:0];
  Info:            ICESTORM_LC:   743/ 1280    58%
  Info:                  SB_IO:    20/  112    17%
  Info:                  SB_GB:     8/    8   100%
  */
  
  /* Info: Device utilisation: */
  logic [ADDR_W-1:0] RAM[0:2**ADDR_W-1];
  /*
  Info:            ICESTORM_LC:   563/ 1280    43%
  Info:           ICESTORM_RAM:     1/   16     6%
  Info:                  SB_IO:    20/  112    17%
  Info:                  SB_GB:     8/    8   100%
  */

  // TODO: verilator is complaining about this
  //assign rd = RAM[a[31:2]]; // word aligned
  always @(posedge clk)
  begin
    if (we)
      RAM[a[7:2]] <= wd;
    rd <= RAM[a[7:2]];
  end
endmodule