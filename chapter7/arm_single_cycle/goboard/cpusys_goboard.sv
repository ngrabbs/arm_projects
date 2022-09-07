/* verilator lint_off UNUSED */
/* verilator lint_off UNUSED */
// cpu_goboard.sv -
//
// vim: set et ts=4 sw=4
//
// "Top" of the CPU example design for gobard FPGA (above this is the FPGA hardware)
//
// * setup clock
// * setup inputs
// * setup outputs
// * instantiate main module
//
// See top-level LICENSE file for license information. (Hint: MIT)
//

`default_nettype none             // mandatory for Verilog sanity
`timescale 1ns/1ps

module cpusys_goboard (
    // output gpio
    input wire  logic   CLK,            // 12M clock
    input wire  logic   i_Switch_1,     // UBUTTON for reset
    output      logic   o_LED_1,        // LED for halt
    output      logic   o_LED_2,        // LED for clock
    output      logic   o_LED_3,
    output      logic   o_LED_4,

    output      logic   o_Segment1_A,
    output      logic   o_Segment1_B,
    output      logic   o_Segment1_C,
    output      logic   o_Segment1_D,
    output      logic   o_Segment1_E,
    output      logic   o_Segment1_F,
    output      logic   o_Segment1_G,

    output      logic   o_Segment2_A,
    output      logic   o_Segment2_B,
    output      logic   o_Segment2_C,
    output      logic   o_Segment2_D,
    output      logic   o_Segment2_E,
    output      logic   o_Segment2_F,
    output      logic   o_Segment2_G
);

// assign output signals to FPGA pins
logic        clk;
//logic        halt;
/* verilator lint_off UNUSED */
logic [31:0] out_value;
//byte_t      out_value;   // output byte from OUT opcode

// reset
logic               reset_ff0, reset_ff1, reset;

// === clock setup
always_comb         clk = CLK;
logic               clk_en;
logic [18:0]        slow_clk;

// reset button synchronizer
always_ff @(posedge clk) begin
    reset       <= !reset_ff1;
    reset_ff1   <= reset_ff0;
    reset_ff0   <= ~i_Switch_1;
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

// NOTE: LEDs are inverse logic (so LED 0=on, 1=off)
//assign o_LED_1      = (slow_clk[7:0] == '0) ? !halt : 1'b0;     // red when halted
//assign o_LED_2      = (slow_clk[18:15] == '0) ? halt : 1'b0;    // green clock pulse

// === instantiate main module
/*
cpu_main main(
    .clk_en_i(clk_en),
    .reset_i(reset),
    .out_strobe_o(out_strobe),
    .out_value_o(out_value),
    .halt_o(halt),
    .clk(clk)
);
*/
cpu_main main(
    .clk(clk_en),
    .reset(reset),
    .DataAdr(out_value)
);

goboard_7seg hexout1(
    .clk(clk),
    .value_i(out_value[7:4]),
    .ledA_o(o_Segment1_A),
    .ledB_o(o_Segment1_B),
    .ledC_o(o_Segment1_C),
    .ledD_o(o_Segment1_D),
    .ledE_o(o_Segment1_E),
    .ledF_o(o_Segment1_F),
    .ledG_o(o_Segment1_G)
);

goboard_7seg hexout2(
    .clk(clk),
    .value_i(out_value[3:0]),
    .ledA_o(o_Segment2_A),
    .ledB_o(o_Segment2_B),
    .ledC_o(o_Segment2_C),
    .ledD_o(o_Segment2_D),
    .ledE_o(o_Segment2_E),
    .ledF_o(o_Segment2_F),
    .ledG_o(o_Segment2_G)
);

assign o_LED_1 = 1'b0;
assign o_LED_2 = 1'b0;
assign o_LED_3 = 1'b0;
assign o_LED_4 = 1'b0;

endmodule
`default_nettype wire               // restore default
