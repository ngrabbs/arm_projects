`timescale 1ns/1ps
/* verilator lint_off UNUSED */
/* verilator lint_off UNDRIVEN */
module ahb_lite(input  logic        HCLK,
                input  logic        HRESETn,
                input  logic [31:0] HADDR,
                input  logic        HWRITE,
                input  logic [31:0] HWDATA,
                output logic [31:0] HRDATA,
                output logic [2:0] ledPins
//                inout  tri   [31:0] pins
);

  logic [3:0]  HSEL;
  logic [31:0] HRDATA0, HRDATA1, HRDATA2, HRDATA3;
//  logic [31:0] pins_dir, pins_out, pins_in;
  logic [31:0] HADDRDEL;
  logic        HWRITEDEL;

//  assign HRDATA2 = 32'bx; // tie these two down till we use them
  assign HRDATA3 = 32'bx;

  // Delay address and write signals to align in time with data
  flop #(32) adrreg(HCLK, HADDR, HADDRDEL);
  flop #(1)  writereg(HCLK, HWRITE, HWRITEDEL);

  // Memory map decoding
  ahb_decoder dec(HADDRDEL, HSEL);
  ahb_mux     mux(HSEL, HRDATA0, HRDATA1, HRDATA2, HRDATA3, HRDATA);

  // Memory and peripherals
  ahb_rom   ahb_rom  (HCLK, HSEL[0], HADDR[15:2], HRDATA0);
  ahb_ram   ahb_ram  (HCLK, HSEL[1], HADDRDEL[16:2], HWRITE,
                     HWDATA, HRDATA1);
  ahb_led   ahb_led (HCLK, HSEL[2], HWRITE, HWDATA, ledPins);
//  ahb_gpio  gpio (HCLK, HRESETn, HSEL[2], HADDRDEL[16:2],
//                  HWRITEDEL, HWDATA, HRDATA2, pin_dir, pins_out, pins_in);
//  ahb_timer timer(HCLK, HRESETn, HSEL[3], HADDRDEL[4:2],
//                  HWRITEDEL, HWDATA, HRDATA3);
//  ahb_spi ahb_spi (HCLK, HSEL[4], HADDR[31:0], HRDATA4);
endmodule
