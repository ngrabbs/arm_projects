module exercise4_10_tb();
  logic        a, b, c, y, y_expected, clk, reset;
  logic [31:0] vectornum, errors;
  logic [11:0] testvectors[10000:0];

  // dut
  exercise4_10 dut(a, b, c, y);

  // generate clock
  always
    begin
      clk = 1; #5; clk = 0; #5;
    end


  // at start of test, load vectors
  // and pulse reset
  initial
    begin
      $readmemb("exercise4_10.tv", testvectors);
      vectornum=0; errors=0;
      reset = 1; #27; reset = 0;
    end

  // apply test vectors on rising edge of clk
  always @(posedge clk)
    begin
      #1; {a, b, c, y_expected} = testvectors[vectornum];
    end

  // check results on falling edge of clk
  always @(negedge clk)
    if (~reset) begin // skip during reset
        if ( y !== y_expected) begin // check result
          $display("Error: input = %b output = %b (%b expected)", {a, b, c}, y, y_expected);
          errors = errors + 1;
        end else begin
          $display("Pass: input = %b output = %b", {a, b, c}, y_expected);
        end

        vectornum = vectornum + 1;

        if (testvectors[vectornum] === 12'bx) begin
          $display("%d tests completed with %d errors", 
            vectornum, errors);
          $finish;
        end
      end

endmodule