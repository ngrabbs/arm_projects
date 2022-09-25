`timescale 1ns/1ps
/* verilator lint_off UNUSED */
module ahb_rom(input  logic        HCLK, HSEL,
               input  logic [15:2] HADDR,
               output logic [31:0] HRDATA);

  logic [31:0] rom[16383:0]; // 64KB ROM organized as 32K x 32 bits;

  initial begin
    $readmemh("isim/memfile.dat", rom);
    /* Count -> works on goboard */
    /*
    rom[0]  = 32'he04f000f;
    rom[1]  = 32'he04f100f;
    rom[2]  = 32'he04f200f;
    rom[3]  = 32'he04f300f;
    rom[4]  = 32'he2833001;
    rom[5]  = 32'he0531002;
    rom[6]  = 32'h0a000003;
    rom[7]  = 32'he2833001;
    rom[8]  = 32'he5803014;
    rom[9]  = 32'he0531002;
    rom[10] = 32'h1afffff9;
    rom[11] = 32'he5803000;
    rom[12] = 32'heafffff7;

    rom[13] = 32'heafffff7;
    rom[14] = 32'heafffff7;
    rom[15] = 32'heafffff7;
    rom[16] = 32'heafffff7;
    rom[17] = 32'heafffff7;
    rom[18] = 32'heafffff7;
    rom[18] = 32'heafffff7;
    rom[20] = 32'heafffff7;
    rom[21] = 32'heafffff7;
    rom[22] = 32'heafffff7;
    rom[23] = 32'heafffff7;
    */
  end

  assign HRDATA = rom[HADDR];
//  always_ff @(posedge HCLK)
//    HRDATA <= rom[HADDR];
endmodule
