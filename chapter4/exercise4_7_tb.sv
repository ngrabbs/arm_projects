module exercise4_7();
  logic [3:0] digit;
  logic [7:0] y;
  logic [7:0] yexpected;
  logic [31:0] vectornum, errors;
  logic [11:0]  testvectors[10000:0];

  // dut
  sevenseg dut(digit, y);

  // at start of test, load vectors
  // and pulse reset
  initial
    begin
      $readmemb("exercise4_7.tv", testvectors);
      vectornum=0; errors=0;

      forever begin
        {digit, yexpected} = testvectors[vectornum]; #10;

        if ( y !== yexpected) begin // check result
          $display("Error: input = %b output = %b (%b expected)", digit, y, yexpected);
          errors = errors + 1;
        end else begin
          $display("Pass: input = %b output = %b", digit, y);
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