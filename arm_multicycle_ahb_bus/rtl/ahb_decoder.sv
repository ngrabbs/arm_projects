`timescale 1ns/1ps
/* verilator lint_off UNUSED */
module ahb_decoder(input  logic [31:0] HADDR,
                   output logic [3:0] HSEL);
  // Decode based on most significant bits of the address
  assign HSEL[0]  = (HADDR[31:16] == 16'h0000);   // 64KB  ROM at 0x00000000 - 0x0000FFFF
  assign HSEL[1]  = (HADDR[31:17] == 15'h0001);   // 128KB RAM at 0x00020000 - 0x003FFFFF
  assign HSEL[2]  = (HADDR[31:4]  == 28'h2020000);     // GPIO at 0x20200000 - 0x20200007
  assign HSEL[3]  = (HADDR[31:8]  == 24'h200030);     // Timer at 0x20003000 - 0x2000301B
//  assign HSEL[4]  = (HADDR[31:1]  == 31'h2020400);
//  assign SPI0CS   = (HADDR[31:0] == 32'h20204000);   // SPI0CS at 0x20204000 - 0x20204000
//  assign SPI0FIFO = (HADDR[31:0] == 32'h20204004); // SPI0FIFI at 0x20204004 - 0x20204004
//  assign SPI0CLK  = (HADDR[31:0] == 32'h20204008);  // SPI0CLK at 0x20204008 - 0x20204008
endmodule
