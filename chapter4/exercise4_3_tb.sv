module exercise4_3_tb();
//  logic        a, b, c, y, yexpected;
  logic y;
  logic [3:0] a;
  logic [31:0] vectornum, errors;
  logic [3:0]  testvectors[10000:0];
  integer i;
  
  // instantiate device under test
  exercise4_3 dut(a, y);

  // at start of test, load vectors
  // and pulse reset
  initial
    begin
      $readmemb("exercise4_3.tv", testvectors);
      vectornum=0; errors=0;
      	for (i = 0; i < 16; i = i + 1) begin
          {a[0], a[1], a[2], a[3]} = testvectors[i];
          #10;
          $display("Current Vector %b Result: %b", a, y);
      end
    end


  
  // apply test vectors on rising edge of clk
//  always @(posedge clk)
//    begin
//      #1; {a, b, c, yexpected} = testvectors[vectornum];
//    end

  // check results on falling edge of clk
/*
  always @(negedge clk)
    if (~reset) begin // skip during reset
      if (y !== yexpected) begin // check result
        $display("Error: inputs = %b", {a, b, c});
        $display(" outputs = %b (%b expected)", y, yexpected);
        errors = errors + 1;
      end

      vectornum = vectornum + 1;
      if (testvectors[vectornum] === 4'bx) begin
        $display("%d tests completed with %d errors", 
          vectornum, errors);
        $finish;
      end
    end
*/
endmodule
