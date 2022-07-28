module exercise4_3_tb();
  logic y, yexpected;
  logic [3:0] a;
  logic [31:0] vectornum, errors;
  logic [4:0]  testvectors[10000:0];
  integer i;
  
  // instantiate device under test
  exercise4_3 dut(a, y);

  // at start of test, load vectors
  // and pulse reset
  initial
    begin
      $readmemb("exercise4_4.tv", testvectors);
      vectornum=0; errors=0;

      forever begin
        {a[0], a[1], a[2], a[3], yexpected} = testvectors[vectornum]; #10;

        if ( y !== yexpected) begin // check result
          $display("Error: input = %b output = %b (%b expected)", a, y, yexpected);
          errors = errors + 1;
        end else begin
          $display("Pass: input = %b output = %b", a, y);
        end

        vectornum = vectornum + 1;

        if (testvectors[vectornum] === 5'bx) begin
          $display("%d tests completed with %d errors", 
            vectornum, errors);
          $finish;
        end
      end
    end
endmodule
