module alu_tb();
  logic        clk, reset;
  logic [31:0] SrcA, SrcB, ALUResult, ALUResult_expected;
  logic [1:0]  ALUControl;
  logic [3:0]  ALUFlags;
  logic [31:0] vectornum, errors;
  logic [98:0] testvectors[10000:0];

  // dut
  alu dut(SrcA, SrcB, ALUControl, ALUResult, ALUFlags);

  // generate clock
  always
    begin
      clk = 1; #5; clk = 0; #5;
    end


  // at start of test, load vectors
  // and pulse reset
  initial
    begin
      $readmemb("alu.tv", testvectors);
      vectornum=0; errors=0;
      reset = 1; #27; reset = 0;
    end

  // apply test vectors on rising edge of clk
  always @(posedge clk)
    begin
      $display("Testvector %b", testvectors[vectornum]);
      #1; {SrcA, SrcB, ALUControl, ALUResult_expected} = testvectors[vectornum];
     
    end

  // check results on falling edge of clk
  always @(negedge clk)
      if (~reset) begin // skip during reset
    if ( ALUResult !== ALUResult_expected) begin // check result
      $display("Error: Cont = %b ALUFlags = %b SrcA = %b SrcB = %b ALUResult = %b (%b expected)", ALUControl, ALUFlags, SrcA, SrcB, ALUResult, ALUResult_expected);
      errors = errors + 1;
    end else begin
      $display("Pass: Cont = %b ALUFlags = %b SrcA = %b SrcB = %b ALUResult = %b", ALUControl, ALUFlags, SrcA, SrcB, ALUResult);
    end

    vectornum = vectornum + 1;

    if (testvectors[vectornum] === 99'bx) begin
      $display("%d tests completed with %d errors", 
        vectornum, errors);
      $finish;
    end
  end

endmodule