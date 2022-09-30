`timescale 1ns/1ps
/* verilator lint_off UNUSED */
/* verilator lint_off UNDRIVEN */
module ahb_lite(input  logic        HCLK,
                input  logic        HRESETn,
                input  logic [31:0] HADDR,
                input  logic        HWRITE,
                input  logic [31:0] HWDATA,
                output logic [31:0] HRDATA);
//                inout  tri   [31:0] pins);

  logic [3:0]  HSEL;
  logic [31:0] HRDATA0, HRDATA1, HRDATA2, HRDATA3;
//  logic [31:0] pins_dir, pins_out, pins_in;
  logic [31:0] HADDRDEL;
  logic        HWRITEDEL;

  assign HRDATA2 = 32'bx; // tie these two down till we use them
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
//  ahb_gpio  gpio (HCLK, HRESETn, HSEL[2], HADDRDEL[2],
//                  HWRITEDEL, HWDATA, HRDATA2, pins);
//  ahb_timer timer(HCLK, HRESETn, HSEL[3], HADDRDEL[4:2],
//                  HWRITEDEL, HWDATA, HRDATA3);
//  ahb_spi ahb_spi (HCLK, HSEL[4], HADDR[31:0], HRDATA4);
endmodule

/*
module ahb_gpio(input  logic        HCLK,
                input  logic        HRESETn,
                input  logic        HSEL,
                input  logic [16:2] HADDR, // book said [2] but verilator did not like
                input  logic        HWRITE,
                input  logic [31:0] HWDATA,
                output logic [31:0] HRDATA,
                output logic [31:0] pin_dir,
                output logic [31:0] pin_out,
                input  logic [31:0] pin_in);

  logic [31:0] gpio[1:0]; // GPIO registers

  // write selected register
  always_ff @(posedge HCLK or negedge HRESETn)
    if (~HRESETn) begin
      gpio[0] <= 32'b0; // GPIO_PORT
      gpio[1] <= 32'b0; // GPIO_DIR
    end else if (HWRITE & HSEL)
      gpio[HADDR] <= HWDATA;

  // read selected register
  assign HRDATA = HADDR ? gpio[1] : pin_in;

  // send value and direction to I/O drivers
  assign pin_out = gpio[0];
  assign pin_dir = gpio[1];
endmodule

module gpio_pins(input  logic [31:0] pin_dir, // 1 = output, 0 = input
                 input  logic [31:0] pin_out, // value to drive on outputs
                 output logic [31:0] pin_in,  // value to read from pins
                 inout   tri  [31:0] pin);    // tristate pins
  // Individual tristate control of each pin
  // No graceful way to control tristates on a per-bit basis in SystemVerilog
  genvar i;
  generate
  for (i=0; i<32; i = i+1) begin: pinloop
    assign pin[i] = pin_dir[i] ? pin_out[i] : 1'bz;
  end
  endgenerate

  assign pin_in = pin;
endmodule
*/
