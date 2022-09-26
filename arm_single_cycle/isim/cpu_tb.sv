`default_nettype none
`timescale 1ns/1ps

module cpu_tb();
  logic        clk;
  logic        reset;
  logic [31:0] WriteData;
  logic [31:0] DataAdr;
  logic        MemWrite;

  // instantiate device to be tested
  cpu_main main(clk, clk, reset, WriteData, DataAdr, MemWrite);

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
    $display("PC=%h Instr=%h DataAdr=%h MemWrite=%b WriteData=%h RegWrite=%h", main.arm.PC, main.arm.Instr, DataAdr, MemWrite, WriteData, main.arm.RegWrite);
    if (MemWrite) begin
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
