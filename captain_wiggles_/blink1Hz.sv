/* captain wiggles blink at 1Hz, single clock */
/* 1Hz = 1 second cycle
 so if we're on for half of 25MHz and off for half we'll see it vs being on for one cycle
 out of 25MHz...
 */


module blink1Hz(
  input       logic   i_Clk,
  input       logic   i_Switch_1,     // UBUTTON for reset
  output      logic   o_LED_1,
  output      logic   o_LED_2,
  output      logic   o_LED_3,
  output      logic   o_LED_4);

// Go-Board, the on-board clock is a 25 MHz clock. A 25 MHz clock has a period of 40 nanoseconds (ns)
logic [32:0] slow_clk_counter; // what is the offset to make 1Hz?
logic        clk_en;

always_ff @(posedge i_Clk) begin
  if (i_Switch_1) begin
    clk_en           <= 1'b0;
    slow_clk_counter <= '0;
  end else begin
    if (slow_clk_counter == (25000000/2)) begin
      slow_clk_counter <= '0;
      clk_en <= 1'b1; 
    end else begin
      clk_en <= 1'b0; 
      slow_clk_counter <= slow_clk_counter + 1'd1;
    end
  end
end

always_ff @(posedge i_Clk) begin
  if (clk_en) begin
    o_LED_1           <= ~o_LED_1;
  end
end 

assign o_LED_2 = 1'b0;
assign o_LED_3 = 1'b0;
assign o_LED_4 = 1'b0;


endmodule
