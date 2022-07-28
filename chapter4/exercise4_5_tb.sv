module minority_tb();
  logic a, b, c, y;

  minority dut(a, b, c, y);

  initial begin
    a = 0; b = 0; c = 0; #10
    $display("a: %b b: %b c: %b y: %b", a, b, c, y);
    a = 1; b = 0; c = 0; #10
    $display("a: %b b: %b c: %b y: %b", a, b, c, y);
    a = 1; b = 1; c = 0; #10
    $display("a: %b b: %b c: %b y: %b", a, b, c, y);
    a = 1; b = 1; c = 1; #10
    $display("a: %b b: %b c: %b y: %b", a, b, c, y);
    a = 0; b = 1; c = 1; #10
    $display("a: %b b: %b c: %b y: %b", a, b, c, y);
    a = 0; b = 0; c = 1; #10
    $display("a: %b b: %b c: %b y: %b", a, b, c, y);
  end

endmodule