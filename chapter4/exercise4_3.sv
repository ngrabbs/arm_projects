module exercise4_3(input  logic [3:0] a,
                   output logic y);
//  assign y = ((a[0] ^ a[1]) ^ (a[2] ^ a[3]));
  assign y = ^a;
endmodule