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
      if(MemWrite) begin
        if(DataAdr === 20 & WriteData === 2) begin
          $display("Simulation succeeded");
          $stop;
        end else begin
          $display("Simulation failed");
          $stop;
        end
      end
    end
endmodule
