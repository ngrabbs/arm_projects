`timescale 1ns/1ps
/* verilator lint_off WIDTH */
/* verilator lint_off UNUSED */
/* verilator lint_off PINMISSING */
/* verilator lint_off UNDRIVEN */

module cpusys_icezero (
    input       logic   clk_100mhz,
    output      logic  [2:0] led,
		input       logic   rpi_spi_mosi,
		output      logic   rpi_spi_miso,
		input       logic   rpi_spi_sck,
    input       logic   button);

  logic [7:0] spi_out;
  logic [7:0] spi_in;
	logic       reset;

//  assign led[0] = (rpi_spi_sck) ? 1'b1 : 1'b0;
//  assign led[0] = (MemWrite) ? 1'b1 : 1'b0;
//  assign led[1] = (rpi_spi_mosi) ? 1'b1 : 1'b0;
//  assign led[2] = (rpi_spi_miso) ? 1'b1 : 1'b0;
//  assign led[0] = spi_in[0];
//  assign led[1] = spi_in[1];
//  assign led[2] = spi_in[2];
	assign reset = (button) ? 1'b1 : 1'b0;
//	assign led[2] = 1'b0;

  spi_slave spi(.sck(rpi_spi_sck), // From Master
                .mosi(rpi_spi_mosi),
                .miso(rpi_spi_miso),
                .reset(reset), // reset
                .d(spi_out), // -> going to other device
                .q(spi_in));

  always_ff @(posedge clk)

	assign spi_out = 1;

	assign led[0] = spi_in[0];
	assign led[1] = spi_in[1];
	assign led[2] = spi_in[2];



  // Clock Generator
  logic clk, pll_locked;

	logic clk_16mhz;
	logic clk_8mhz = 0, clk_4mhz = 0, clk_2mhz = 0;

	SB_PLL40_PAD #(
		.FEEDBACK_PATH("SIMPLE"),
		.DELAY_ADJUSTMENT_MODE_FEEDBACK("FIXED"),
		.DELAY_ADJUSTMENT_MODE_RELATIVE("FIXED"),
		.PLLOUT_SELECT("GENCLK"),
		.FDA_FEEDBACK(4'b1111),
		.FDA_RELATIVE(4'b1111),
		.DIVR(4'b0011),		// DIVR =  3
		.DIVF(7'b0101000),	// DIVF = 40
		.DIVQ(3'b110),		// DIVQ =  6
		.FILTER_RANGE(3'b010)	// FILTER_RANGE = 2
	) pll (
		.PACKAGEPIN   (clk_100mhz),
		.PLLOUTGLOBAL (clk_16mhz ),
		.LOCK         (pll_locked),
		.BYPASS       (1'b0      ),
		.RESETB       (1'b1      )
	);
  always @(posedge clk_16mhz) clk_8mhz <= !clk_8mhz;
	always @(posedge clk_8mhz) clk_4mhz <= !clk_4mhz;
	always @(posedge clk_4mhz) clk_2mhz <= !clk_2mhz;
	assign clk = clk_16mhz;


	// Reset Generator
	logic [7:0] resetstate = 0;
	logic resetn = 0;

	always @(posedge clk) begin
		resetstate <= pll_locked ? resetstate + !(&resetstate) : 0;
		resetn <= &resetstate;
	end

	logic [31:0] out_value;
	logic [31:0] dataadr;
	logic        MemWrite;
  // === instantiate main module
  top top(
    .clk(clk_2mhz),
    .reset(resetn),
    .WriteData(out_value),
    .Adr(dataadr),
    .MemWrite(MemWrite)
  );

endmodule
