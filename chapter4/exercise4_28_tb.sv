module ex4_28();
  logic        d, q, q_expected, clk, reset;
  logic [31:0] vectornum, errors;
  logic [11:0] testvectors[10000:0];

  // dut
  latch dut(clk, d, q);

  // generate clock
  always
    begin
      clk = 1; #5; clk = 0; #5;
    end


  // at start of test, load vectors
  // and pulse reset
  initial
    begin
      $readmemb("exercise4_28.tv", testvectors);
      vectornum=0; errors=0;
      reset = 1; #27; reset = 0;
    end

  // apply test vectors on rising edge of clk
  always @(posedge clk)
    begin
      $display("Testvector %b", testvectors[vectornum]);
//      #1; {d, q, q_expected} = testvectors[vectornum];
     
    end

  // check results on falling edge of clk
  always @(negedge clk)
      if (~reset) begin // skip during reset
    if ( q !== q_expected) begin // check result
      $display("Error: input = %b output = %b (%b expected)", d, q, q_expected);
      errors = errors + 1;
    end else begin
      $display("Pass: input = %b output = %b", d, q);
    end

    vectornum = vectornum + 1;

    if (testvectors[vectornum] === 3'bx) begin
      $display("%d tests completed with %d errors", 
        vectornum, errors);
      $finish;
    end
  end

endmodule