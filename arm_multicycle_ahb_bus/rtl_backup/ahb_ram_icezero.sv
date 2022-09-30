`timescale 1ns/1ps
/* verilator lint_off PINMISSING */
module ahb_ram(input  logic        HCLK,
               input  logic        HSEL,
               input  logic [16:2] HADDR,
               input  logic        HWRITE,
               input  logic [31:0] HWDATA,
               output logic [31:0] HRDATA,
               output logic sram_ce, sram_lb, sram_ub, sram_oe, sram_we,
	             output logic sram_a0, sram_a1, sram_a2, sram_a3, sram_a4, sram_a5, sram_a6, sram_a7,
	             output logic sram_a8, sram_a9, sram_a10, sram_a11, sram_a12, sram_a13, sram_a14, sram_a15, sram_a16, sram_a17, sram_a18,
	             inout logic sram_d0, sram_d1, sram_d2, sram_d3, sram_d4, sram_d5, sram_d6, sram_d7,
	             inout logic sram_d8, sram_d9, sram_d10, sram_d11, sram_d12, sram_d13, sram_d14, sram_d15);

  	// Memory Interface

//	logic [18:0] sram_addr;
	logic [15:0] sram_dout;
	logic [15:0] sram_din;

	assign {sram_a18, sram_a17, sram_a16, sram_a15, sram_a14, sram_a13, sram_a12, sram_a11, sram_a10,
			sram_a9, sram_a8, sram_a7, sram_a6, sram_a5, sram_a4, sram_a3, sram_a2, sram_a1, sram_a0 } = {1'b0, 1'b0, HADDR, 1'b0, 1'b0};

//	assign {sram_a18, sram_a17, sram_a16, sram_a15, sram_a14, sram_a13, sram_a12, sram_a11, sram_a10,
//			sram_a9, sram_a8, sram_a7, sram_a6, sram_a5, sram_a4, sram_a3, sram_a2, sram_a1, sram_a0 } = sram_addr;

	SB_IO #(
		.PIN_TYPE(6'b 1010_01),
		.PULLUP(1'b 0)
	) sram_dio [15:0] (
		.PACKAGE_PIN({sram_d15, sram_d14, sram_d13, sram_d12, sram_d11, sram_d10, sram_d9, sram_d8,
				sram_d7, sram_d6, sram_d5, sram_d4, sram_d3, sram_d2, sram_d1, sram_d0}),
		.OUTPUT_ENABLE(sram_oe),
		.D_OUT_0(sram_dout),
		.D_IN_0(sram_din)
	);

	assign sram_ce = 0;
	assign sram_lb = 0;
	assign sram_ub = 0;
	assign sram_oe = HSEL;
	assign sram_we = HWRITE;
//  logic [31:0] ram[32767:0];  // 128KB RAM organized as 32K x 32 bits
  assign HRDATA = {16'b0, sram_dout}; // *** check addressing is correct

  always_ff @(posedge HCLK)
    if (HSEL & HWRITE) sram_din <= HWDATA[15:0];

endmodule
