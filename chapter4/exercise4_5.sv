module minority(input logic a, b, c,
                output logic y);
  always_comb begin
    if      ( ~a & ~b & c ) y = 1'b1;
    else if ( ~a & b & ~c ) y = 1'b1;
    else if ( a & ~b & ~c ) y = 1'b1;
    else if ( ~a & ~b & ~c ) y = 1'b1;
    else y = 1'b0;
  end

endmodule