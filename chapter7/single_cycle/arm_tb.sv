module testbench();
  logic        clk;
  logic        reset;
  logic [31:0] WriteData, DataAdr, viewPC, viewInstr, viewReadData;
  logic        MemWrite;

  // instantiate device to be tested
  top dut(clk, reset, WriteData, DataAdr, MemWrite, viewPC, viewInstr, viewReadData);

  // generate clock to sequence tests
  always
    begin
      clk = 1; #5; clk = 0; #5;
    end

  // initialize test
  initial
  begin
    $dumpfile("cpu_tb.fst");
    $dumpvars(0, WriteData);
    reset = 1; #22; reset = 0;
  end



  // check that 7 gets written to address 0x64
  // at end of program
  always @(negedge clk)
  begin
    $display("cycle MemWrite=%b WriteData=%b ReadData=%b DataAdr=%b PC=%h Inst=%b ALUFlags=%b", MemWrite, WriteData, viewReadData, DataAdr, viewPC, viewInstr, dut.arm.ALUFlags);
    if(MemWrite | viewInstr === 32'bx ) begin
      if(DataAdr === 100 & WriteData === 7) begin
        $display("Simulation succeeded");
        $finish;
      end else if (DataAdr !== 96) begin
        $display("Simulation failed");
        $finish;
      end else if (viewInstr === 32'bx ) begin
        $display("Simulation ended");
        $finish;
      end
    end
  end
endmodule