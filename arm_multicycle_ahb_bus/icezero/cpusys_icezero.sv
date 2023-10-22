/* verilator lint_off UNUSED */
/* verilator lint_off SYNCASYNCNET */
`timescale 1ns/1ps
module cpusys_icezero (
    input       logic   clk_100mhz,
    output      logic  [2:0] led,
    input       logic   button);

	// assign output signals to FPGA pins
	logic				clk;
	logic 			MemWrite;
	logic [31:0] out_value;
	logic [31:0] dataadr;
	logic [2:0] ledPins;

	// reset
	logic               reset_ff0, reset_ff1, reset;

	// === clock setup
	always_comb         clk = clk_100mhz;
	logic               clk_en;
	logic [19:0]        slow_clk;

	// reset button synchronizer
	always_ff @(posedge clk) begin
	    reset       <= !reset_ff1;
	    reset_ff1   <= reset_ff0;
	    reset_ff0   <= button;
	end

	always_ff @(posedge clk) begin
    if (reset) begin
        clk_en      <= 1'b0;
        slow_clk    <= '0;
    end else begin
        slow_clk    <= slow_clk + 1'b1;
        if (slow_clk == '0) begin
            clk_en      <= 1'b1;
        end else begin
            clk_en      <= 1'b0;
        end
    end
	end

  // === instantiate main module
  top top(
    .clk(clk_en),
    .reset(reset),
    .WriteData(out_value),
    .Adr(dataadr),
    .MemWrite(MemWrite),
		.ledPins(ledPins)
  );

	assign led[0] = ledPins[0];
	assign led[1] = ledPins[1];
	assign led[2] = ledPins[2];

endmodule
