module fulladder_tb();
  logic        clk, reset, cin, cout, cout_expected;
  logic [7:0] a, b, s, s_expected;
  logic [31:0] vectornum, errors;
  logic [98:0] testvectors[10000:0];

  // dut
  adder dut(a, b, cin, s, cout);

  // generate clock
  always
    begin
      clk = 1; #5; clk = 0; #5;
    end


  // at start of test, load vectors
  // and pulse reset
  initial
    begin
      $readmemb("fulladder.tv", testvectors);
      vectornum=0; errors=0;
      reset = 1; #27; reset = 0;
    end

  // apply test vectors on rising edge of clk
  always @(posedge clk)
    begin
//      $display("Testvector %b", testvectors[vectornum]);
      #1; {a, b, cin, s_expected, cout_expected} = testvectors[vectornum];

    end

  // check results on falling edge of clk
  always @(negedge clk)
  if (~reset) begin // skip during reset
    if ( s !== s_expected) begin // check result
      $display("Error: a = %b b = %b cin = %b s = %b cout = %b (%b expected)", a, b, cin, s, cout, s_expected);
      errors = errors + 1;
    end else begin
      $display("Pass: a = %b b = %b cin = %b s = %b cout = %b", a, b, cin, s, cout);
    end

    vectornum = vectornum + 1;

    if (testvectors[vectornum] === 99'bx) begin
      $display("%d tests completed with %d errors",
        vectornum, errors);
      $finish;
    end
  end

endmodule
