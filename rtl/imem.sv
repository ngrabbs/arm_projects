/* verilator lint_off WIDTH */ // TODO: remove this when fixed
/* verilator lint_off UNUSED */ // TODO: remove this
/*
module imem#(
    parameter ADDR_W = 8,
    parameter DATA_W = 32
) (
  */
  module imem(
    input  logic [31:0] a,
    output logic [31:0] rd
);

  logic [31:0] RAM[64:0];

  initial begin
    $readmemh("rtl/mems/ex7_9memfile.dat", RAM);
    /* CMP */
    /*
    RAM[0]   = 32'he05f000f;
    RAM[1]   = 32'he04f100f;
    RAM[2]   = 32'he1500001;
    RAM[3]   = 32'he2800001;
    RAM[4]   = 32'he1500001;
    RAM[5]   = 32'he2800002;
    RAM[6]   = 32'he2811002;
    RAM[7]   = 32'he2400001;
    RAM[8]   = 32'he1500000;
    RAM[9]   = 32'he1500001;
    RAM[10]  = 32'he2811001;
    */
    /*
    Info: Device utilisation:
    Info:            ICESTORM_LC:   563/ 1280    43%
    Info:           ICESTORM_RAM:     1/   16     6%
    Info:                  SB_IO:    20/  112    17%
    Info:                  SB_GB:     8/    8   100%
    */

    /* Count -> works on goboard */
    /*
    RAM[0]  = 32'he04f000f;
    RAM[1]  = 32'he04f100f;
    RAM[2]  = 32'he04f200f;
    RAM[3]  = 32'he04f300f;
    RAM[4]  = 32'he2833001;
    RAM[5]  = 32'he0531002;
    RAM[6]  = 32'h0a000003;
    RAM[7]  = 32'he2833001;
    RAM[8]  = 32'he5803014;
    RAM[9]  = 32'he0531002;
    RAM[10] = 32'h1afffff9;
    RAM[11] = 32'he5803000;
    RAM[12] = 32'heafffff7;

    RAM[13] = 32'heafffff7;
    RAM[14] = 32'heafffff7;
    RAM[15] = 32'heafffff7;
    RAM[16] = 32'heafffff7;
    RAM[17] = 32'heafffff7;
    RAM[18] = 32'heafffff7;
    RAM[18] = 32'heafffff7;
    RAM[20] = 32'heafffff7;
    RAM[21] = 32'heafffff7;
    RAM[22] = 32'heafffff7;
    RAM[23] = 32'heafffff7;
    */
  end

  // TODO: verilator is complaining about this
  /*
  always @(posedge clk)
    rd <= RAM[a[7:2]];
    */
  assign rd = RAM[a[31:2]]; // word aligned
endmodule
