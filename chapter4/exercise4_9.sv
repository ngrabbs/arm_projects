module ex4_9(input  logic a, b, c,
             output logic y);
  mux8 #(1) mux8_1({a,b,c}, 1'b1, 1'b0, 1'b0, 1'b1,
                            1'b1, 1'b1, 1'b0, 1'b0, y);
// 000 d0 1'b1 ~b~c
// 001 d1 1'b0
// 010 d2 1'b0
// 011 d3 1'b1 ~abc
// 100 d4 1'b1 a~b + ~b~c
// 101 d5 1'b1 a~b
// 110 d6 1'b0
// 111 d7 1'b0

endmodule