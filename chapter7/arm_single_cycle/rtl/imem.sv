/* verilator lint_off WIDTH */ // TODO: remove this when fixed
/* verilator lint_off UNUSED */ // TODO: remove this
module imem(input  logic [31:0] a, // TODO: verilator thinks a is unused, why?
            output logic [31:0] rd);

  logic [31:0] RAM[14:0];

  initial begin
//    $readmemh("memfile.dat", RAM);
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
/*
    RAM[0]  = 32'hE04F000F;
    RAM[1]  = 32'hE3A01001;
    RAM[2]  = 32'hE3A020FF;
    RAM[3]  = 32'hE28030EA;
    RAM[4]  = 32'hE2833004;
    RAM[5]  = 32'hE59F4020;
    RAM[6]  = 32'hE5843000;
    RAM[7]  = 32'hE0533002;
    RAM[8]  = 32'h0A000003;
    RAM[9]  = 32'hE2833001;
    RAM[10] = 32'hE5843000;
    RAM[11] = 32'hE0533002;
    RAM[12] = 32'h1AFFFFF9;
    RAM[13] = 32'hE5803000;
    RAM[14] = 32'hEAFFFFF7;
    */
  end

  // TODO: verilator is complaining about this
  assign rd = RAM[a[31:2]]; // word aligned
endmodule
