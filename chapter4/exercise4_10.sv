module exercise4_10(input  logic a, b, c,
                    output logic y);

  mux4_1 #(1) mux4({b, c}, 1'b1, 1'b0, 1'b0, 1'b1, y);
endmodule

// 00 ~b~c
// 01
// 10
// 11