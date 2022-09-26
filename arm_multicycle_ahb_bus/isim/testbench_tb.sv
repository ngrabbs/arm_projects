/* verilator lint_off INITIALDLY */
/* verilator lint_off COMBDLY */
// ARM multicycle processor
// Added instructions:
//    ASR, TST, SBC, ROR, CMP
`timescale 1ns/1ps
module testbench_tb();

  logic        clk;
  logic        reset;

  logic [31:0] WriteData, DataAdr;
  logic        MemWrite;

  // instantiate device to be tested
  top dut(clk, reset, WriteData, DataAdr, MemWrite);

  // initialize test
  initial
    begin
      $dumpfile("logs/testbench_tb.fst");
      $dumpvars(0, dut);
      reset <= 1; # 22; reset <= 0;
    end

  // generate clock to sequence tests
  always
    begin
      clk <= 1; # 5; clk <= 0; # 5;
    end

  // check results
  always @(negedge clk)
    begin
      $display("MemWrite: %b Adr: %h WriteData: %h ReadData: %h state: %b nextstate: %b R0:%h R3: %h R9: %h R1: %h", dut.MemWrite, dut.Adr, dut.WriteData, dut.ReadData, dut.arm.c.dec.fsm.state, dut.arm.c.dec.fsm.nextstate, dut.arm.dp.rf.rf[0], dut.arm.dp.rf.rf[3], dut.arm.dp.rf.rf[9], dut.arm.dp.rf.rf[1]);
      if(MemWrite) begin
//        if(DataAdr === 131156 & WriteData === 7) begin
        if(DataAdr === 88 & WriteData === 32'h2ffffffe) begin
          $display("Simulation succeeded");
          $finish;
        end else if (DataAdr !== 96) begin
          $display("Simulation failed");
          $finish;
        end
      end else if (dut.Adr === 32'bx) begin
        $display("Simulation failed");
        $finish;
      end
    end

endmodule
