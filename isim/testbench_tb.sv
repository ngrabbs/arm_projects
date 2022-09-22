`default_nettype none
`timescale 1ns/1ps
module testbench_tb();
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
      $dumpfile("logs/testbench_tb.fst");
      $dumpvars(0, dut);
      reset <= 1; # 22; reset <= 0;
    end
  // generate clock to sequence tests
  always
    begin
      /* verilator lint_off COMBDLY */
      clk <= 1; # 10; clk <= 0; # 10;
    end
  // check results
  always @(negedge clk)
  begin
    $display("PC: %h Instr: %h MemWrite: %b DataAdr: %h r0: %h r2: %h r7: %h ALUResult: %h ALUResultOut: %h Result: %h WriteData: %h ReadData: %h MemtoReg %b", dut.arm.PC, dut.arm.Instr, dut.arm.MemWrite, DataAdr, dut.arm.dp.rf.rf[0], dut.arm.dp.rf.rf[2], dut.arm.dp.rf.rf[7], dut.arm.dp.ALUResult, dut.arm.dp.ALUResultOut, dut.arm.dp.Result, WriteData, dut.arm.ReadData, dut.arm.MemtoReg);
    if(MemWrite) begin

      if (DataAdr === 100 & WriteData === 7) begin
        $display("Simulation succeeded");
        $finish;
      end else if (DataAdr !== 96) begin
        $display("Simulation failed");
        $finish;
      end
    end
  end
endmodule
