`timescale 1ns/1ps
/* verilator lint_off WIDTH */
/*
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
*/
