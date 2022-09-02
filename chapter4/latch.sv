module latch(input  logic clk,
             input  logic d,
             output logic q);
  logic n1, n2;
//  always @(posedge clk)
//    if ( d & clk )  n1 <= 1'b1;
//    if ( q & ~clk ) n2 <= 1'b1;
//    if ( n1 | n2 )  q <= 1'b1;
  assign n1 = ( d & clk );
  assign n2 = ( q & ~clk );
  assign q = ( n1 | n2 );
endmodule