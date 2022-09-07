`default_nettype none
`timescale 1ns/1ps

module cpu_tb();
  logic        clk;
  logic        reset;
  logic [31:0] WriteData, DataAdr;
  logic        MemWrite;

  // instantiate device to be tested
//  cpu_main dut(clk, reset, WriteData, DataAdr, MemWrite);
  cpu_main main(clk, reset, WriteData, DataAdr, MemWrite);

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
    if (main.arm.Instr !== 32'bx ) begin
    $display("PC=%h Instr=%h DataAdr=%h MemWrite=%b WriteData=%h", main.arm.PC, main.arm.Instr, DataAdr, MemWrite, WriteData);
    end
    /*
    if (main.arm.Instr === 32'bx ) begin
        $display("Simulation ended");
        $finish;
      end
      */
    end
endmodule
