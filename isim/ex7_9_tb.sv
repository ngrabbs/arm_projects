`default_nettype none
`timescale 1ns/1ps
// ex7.9 solutions
//
// single-cycle ARM processor
// additional instructions: TST, LSL, CMN, ADC
module ex7_9_tb();
  logic        clk;
  logic        reset;
  logic [31:0] WriteData, DataAdr;
  logic        MemWrite;
// instantiate device to be tested
cpu_main dut(clk, clk, reset, WriteData, DataAdr, MemWrite);
  // initialize test
  initial
    begin
      /* verilator lint_off INITIALDLY */
      $dumpfile("logs/ex7_9_tb.fst");
      $dumpvars(0, dut);
      reset <= 1; # 22; reset <= 0;
    end
  // generate clock to sequence tests
  always
    begin
      /* verilator lint_off COMBDLY */
      clk <= 1; # 5; clk <= 0; # 5;
    end
  // check results
  always @(negedge clk)
    begin
      $display("PC: %x Instr: %h ALUFlags: %b R3: %h R4: %h DataAdr: %h WriteData: %h", dut.PC, dut.Instr, dut.arm.ALUFlags, dut.arm.dp.rf.rf[3], dut.arm.dp.rf.rf[4], DataAdr, WriteData);
      if(MemWrite) begin
        if(DataAdr === 20 & WriteData === 2) begin
          $display("Simulation succeeded");
          $finish;
        end else begin
          $display("Simulation failed");
          $finish;
        end
      end
    end
endmodule
