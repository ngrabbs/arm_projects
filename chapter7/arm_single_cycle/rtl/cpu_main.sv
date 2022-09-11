/* verilator lint_off UNUSED */
module cpu_main(input  logic        slow_clk, clk, reset,
                output logic [31:0] WriteData, DataAdr,
                output logic        MemWrite);

  logic [31:0] PC, Instr, ReadData;

  // instantiate processor and memories
  arm arm(slow_clk, reset, PC, Instr, MemWrite, DataAdr,
          WriteData, ReadData);
  imem imem(PC, Instr);
  dmem dmem(clk, MemWrite, DataAdr[7:0], WriteData, ReadData);

endmodule
