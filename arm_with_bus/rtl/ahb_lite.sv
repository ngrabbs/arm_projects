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

  // Delay address and write signals to align in time with data
  flop #(32) adrreg(HCLK, HADDR, HADDRDEL);
  flop #(1)  writereg(HCLK, HWRITE, HWRITEDEL);

  // Memory map decoding
  ahb_decoder dec(HADDRDEL, HSEL);
  ahb_mux     mux(HSEL, HRDATA0, HRDATA1, HRDATA2, HRDATA3, HRDATA);

  // Memory and peripherals
  ahb_rom   ahb_rom  (HCLK, HSEL[0], HADDR[15:2], HRDATA0);
  ahb_ram   ahb_ram  (HCLK, HSEL[1], HADDRDEL[16:2], HWRITEDEL,
                     HWDATA, HRDATA1);
//  ahb_gpio  gpio (HCLK, HRESETn, HSEL[2], HADDRDEL[2],
//                  HWRITEDEL, HWDATA, HRDATA2, pins);
//  ahb_timer timer(HCLK, HRESETn, HSEL[3], HADDRDEL[4:2],
//                  HWRITEDEL, HWDATA, HRDATA3);
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

module ahb_timer(input  logic        HCLK,
                 input  logic        HRESETn,
                 input  logic        HSEL,
                 input  logic [4:2]  HADDR,
                 input  logic        HWRITE,
                 input  logic [31:0] HWDATA,
                 output logic [31:0] HRDATA);
  logic [31:0] timers[6:0]; // timer registers
  logic [31:0] chi, clo;    // next counter value
  logic [3:0]  match, clr;  // determine if counter matches compare reg

  // write selected register and update tiers and match
  always_ff @(posedge HCLK or negedge HRESETn)
    if (~HRESETn) begin
      timers[0] <= 32'b0; // TIMER_CS
      timers[1] <= 32'b0; // TIMER_CLO
      timers[2] <= 32'b0; // TIMER_CHI
      timers[3] <= 32'b0; // TIMER_CO
      timers[4] <= 32'b0; // TIMER_C1
      timers[5] <= 32'b0; // TIMER_C2
      timers[6] <= 32'b0; // TIMER_C3
    end else begin
      timers[0] <= {28'b0, match};
      timers[1] <= (HWRITE & HSEL & HADDR == 3'b000) ? HWDATA : clo;
      timers[2] <= (HWRITE & HSEL & HADDR == 3'b000) ? HWDATA : chi;
      if (HWRITE & HSEL & HADDR == 3'b011) timers[3] <= HWDATA;
      if (HWRITE & HSEL & HADDR == 3'b100) timers[4] <= HWDATA;
      if (HWRITE & HSEL & HADDR == 3'b101) timers[5] <= HWDATA;
      if (HWRITE & HSEL & HADDR == 3'b110) timers[6] <= HWDATA;
    end

    // read selected register
    assign HRDATA = timers[HADDR];

    // increment 64-bit counter as pair of TIMER_CHI, TIMER_CLO
    assign {chi, clo} = {timers[2], timers[1]} + 1;

    // generate matches: set match bit when counter matches compare register
    // clear bit when a 1 is written to that position of the match register
    assign clr = (HWRITE & HSEL & HADDR == 3'b000 & HWDATA[3:0]);
    assign match[0] = ~clr[0] & (timers[0][0] | (timers[1] == timers[3]));
    assign match[1] = ~clr[1] & (timers[0][1] | (timers[1] == timers[4]));
    assign match[2] = ~clr[2] & (timers[0][2] | (timers[1] == timers[5]));
    assign match[3] = ~clr[3] & (timers[0][3] | (timers[1] == timers[6]));
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
