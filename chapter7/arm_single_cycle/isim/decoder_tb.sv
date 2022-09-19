module alu_tb();
  logic        clk, reset;
  logic [1:0]  Op;
  logic [5:0]  Funct;
  logic [3:0]  Rd;
  logic [1:0]  FlagW;
  logic        PCS, RegW, MemW;
  logic        MemtoReg, ALUSrc;
  logic        NoWrite;
  logic [1:0]  ImmSrc, RegSrc, ALUControl;
  logic [31:0] vectornum, errors, Instr;
  logic [98:0] testvectors[10000:0];

  // dut
  decoder dut(Op, Funct, Rd, FlagW, PCS, RegW, MemW, MemtoReg, ALUSrc, NoWrite, ImmSrc, RegSrc, ALUControl);

  // generate clock
  always
    begin
      clk = 1; #5; clk = 0; #5;
    end


  // at start of test, load vectors
  // and pulse reset
  initial
    begin
      $readmemb("decoder.tv", testvectors);
      vectornum=0; errors=0;
      reset = 1; #27; reset = 0;
    end

  // apply test vectors on rising edge of clk
  always @(posedge clk)
    begin
//      $display("Testvector %b", testvectors[vectornum]);
      #1; Instr = testvectors[vectornum];
      #1; Op = Instr[27:26];
     
    end

  // check results on falling edge of clk
  always @(negedge clk)
    if (~reset) begin // skip during reset
      $display("Testing Inputs:[Op:[%b] Funct:[%b] Rd:[%b]] Outputs:[FlagW:[%b] PCS:[%b] RegW:[%b] MemW:[%b] MemtoReg:[%b]]", Op, Funct, Rd, FlagW, PCS, RegW, MemW, MemtoReg);
//      if ( ALUResult !== ALUResult_expected) begin // check result
//        $display("Error: Cont = %b ALUFlags = %b SrcA = %b SrcB = %b ALUResult = %b (%b expected)", ALUControl, ALUFlags, SrcA, SrcB, ALUResult, ALUResult_expected);
//        errors = errors + 1;
//      end else begin
//        $display("Pass: Cont = %b ALUFlags = %b SrcA = %b SrcB = %b ALUResult = %b", ALUControl, ALUFlags, SrcA, SrcB, ALUResult);
//      end

      vectornum = vectornum + 1;

      if (testvectors[vectornum] === 99'bx) begin
        $display("%d tests completed with %d errors", 
          vectornum, errors);
        $finish;
      end
    end

endmodule