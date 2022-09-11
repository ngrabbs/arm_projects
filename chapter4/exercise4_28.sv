module latch(input  logic clk,
             input  logic d,
             output logic q
);

  logic n1, n2;

  assign n1 = d & clk;
  assign n2 = q & ~clk;
  assign q = n1 | n2;
endmodule