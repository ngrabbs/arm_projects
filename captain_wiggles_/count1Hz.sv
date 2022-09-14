/* captain wiggles count at 1Hz, single clock */

module count1Hz(
  input       logic   i_Clk,
  input       logic   i_Switch_1,     // UBUTTON for reset
  output      logic   o_LED_1,
  output      logic   o_LED_2,
  output      logic   o_LED_3,
  output      logic   o_LED_4,
  output      logic   o_Segment1_A,
  output      logic   o_Segment1_B,
  output      logic   o_Segment1_C,
  output      logic   o_Segment1_D,
  output      logic   o_Segment1_E,
  output      logic   o_Segment1_F,
  output      logic   o_Segment1_G,
  //
  output      logic   o_Segment2_A,
  output      logic   o_Segment2_B,
  output      logic   o_Segment2_C,
  output      logic   o_Segment2_D,
  output      logic   o_Segment2_E,
  output      logic   o_Segment2_F,
  output      logic   o_Segment2_G);

logic [24:0] slow_clk_counter;
logic        clk_en;
logic [7:0]  seg_count;

logic w_Segment1_A;
logic w_Segment1_B;
logic w_Segment1_C;
logic w_Segment1_D;
logic w_Segment1_E;
logic w_Segment1_F;
logic w_Segment1_G;

logic w_Segment2_A;
logic w_Segment2_B;
logic w_Segment2_C;
logic w_Segment2_D;
logic w_Segment2_E;
logic w_Segment2_F;
logic w_Segment2_G;

always_ff @(posedge i_Clk) begin
  if (i_Switch_1) begin
    clk_en           <= 1'b0;
    slow_clk_counter <= '0;
  end else begin
    if (slow_clk_counter == 25000000) begin
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
    seg_count         <= seg_count + 1'b1;
  end
end 

// Instantiate Binary to 7-Segment COnverter
Binary_To_7Segment Inst
(
  .i_Clk(i_Clk),
  .i_Binary_Num(seg_count[7:4]),
  .o_Segment_A(w_Segment1_A),
  .o_Segment_B(w_Segment1_B),
  .o_Segment_C(w_Segment1_C),
  .o_Segment_D(w_Segment1_D),
  .o_Segment_E(w_Segment1_E),
  .o_Segment_F(w_Segment1_F),
  .o_Segment_G(w_Segment1_G)
);

// Instantiate Binary to 7-Segment COnverter
Binary_To_7Segment Inst1
(
  .i_Clk(i_Clk),
  .i_Binary_Num(seg_count[3:0]),
  .o_Segment_A(w_Segment2_A),
  .o_Segment_B(w_Segment2_B),
  .o_Segment_C(w_Segment2_C),
  .o_Segment_D(w_Segment2_D),
  .o_Segment_E(w_Segment2_E),
  .o_Segment_F(w_Segment2_F),
  .o_Segment_G(w_Segment2_G)
);

assign o_Segment1_A = ~w_Segment1_A;
assign o_Segment1_B = ~w_Segment1_B;
assign o_Segment1_C = ~w_Segment1_C;
assign o_Segment1_D = ~w_Segment1_D;
assign o_Segment1_E = ~w_Segment1_E;
assign o_Segment1_F = ~w_Segment1_F;
assign o_Segment1_G = ~w_Segment1_G;


assign o_Segment2_A = ~w_Segment2_A;
assign o_Segment2_B = ~w_Segment2_B;
assign o_Segment2_C = ~w_Segment2_C;
assign o_Segment2_D = ~w_Segment2_D;
assign o_Segment2_E = ~w_Segment2_E;
assign o_Segment2_F = ~w_Segment2_F;
assign o_Segment2_G = ~w_Segment2_G;

assign o_LED_1 = 1'b0;
assign o_LED_2 = 1'b0;
assign o_LED_3 = 1'b0;
assign o_LED_4 = 1'b0;


endmodule
