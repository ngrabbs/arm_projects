/* verilator lint_off INITIALDLY */
/* verilator lint_off COMBDLY */
// ARM multicycle processor
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
      $display("MemWrite: %b Adr: %h WriteData: %h ReadData: %h state: %b nextstate: %b", dut.MemWrite, dut.Adr, dut.WriteData, dut.ReadData, dut.arm.c.dec.fsm.state, dut.arm.c.dec.fsm.nextstate);
      if(MemWrite) begin
        if(DataAdr === 100 & WriteData === 7) begin
          $display("Simulation succeeded");
          $finish;
        end else if (DataAdr !== 96) begin
          $display("Simulation failed");
          //$finish;
        end
      end else if (MemWrite === 1'bx) begin
          $display("Simulation failed");
          $finish;
      end else if (dut.Adr === 32'bx) begin
          $display("Simulation failed");
          $finish;
      end
    end

endmodule
