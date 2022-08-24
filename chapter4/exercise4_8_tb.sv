module exercise4_8();
  logic        clk, reset;
  logic [2:0]  a;
  logic        d0, d1, d2, d3, d4, d5, d6, d7, y, yexpected;
  logic [31:0] vectornum, errors;
  logic [11:0] testvectors[10000:0];

  // dut
  mux8 dut(a, d0, d1, d2, d3, d4, d5, d6, d7, y);

  // generate clock
  always 
    begin
      clk = 1; #5; clk = 0; #5;
    end

  // at start of test, load vectors
  // and pulse reset
  initial
    begin
      $readmemb("exercise4_8.tv", testvectors);
      vectornum=0; errors=0;
      reset = 1; #27; reset = 0;
    end

    always @(posedge clk)
     begin
        #1; {a, d0, d1, d2, d3, d4, d5, d6, d7, yexpected } = testvectors[vectornum];
     end

    always @(negedge clk)
      begin
      if (~reset) begin // skip during reset
        if ( y !== yexpected) begin // check result
          $display("Error: input = %b output = %b (%b expected)", a, y, yexpected);
          errors = errors + 1;
        end else begin
          $display("Pass: input = %b output = %b", a, y);
        end

        vectornum = vectornum + 1;

        if (testvectors[vectornum] === 12'bx) begin
          $display("%d tests completed with %d errors", 
            vectornum, errors);
          $finish;
        end
      end
    end

endmodule