`timescale 1ns/1ps
module top(input  logic        clk, reset,
            output logic [31:0] WriteData, Adr,
            output logic        MemWrite);

  logic [31:0] ReadData;

  // instantiate processor and shared memroy
  arm arm(clk, reset, MemWrite, Adr,
          WriteData, ReadData);
  mem mem(clk, MemWrite, Adr, WriteData, ReadData);

endmodule
