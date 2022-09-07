/* verilator lint_off UNUSED */
module cpu_main(input  logic        clk, reset,
           output logic [31:0] DataAdr);

  logic [31:0] PC, Instr, ReadData, WriteData;
  logic MemWrite;

  // instantiate processor and memories
  arm arm(clk, reset, PC, Instr, MemWrite, DataAdr,
          WriteData, ReadData);
  imem imem(PC, Instr);
  dmem dmem(clk, MemWrite, DataAdr, WriteData, ReadData);

endmodule
