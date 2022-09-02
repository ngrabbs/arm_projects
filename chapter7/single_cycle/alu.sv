module alu(input  logic [31:0] SrcA, SrcB,
           input  logic [1:0]  ALUControl,
           output logic [31:0] ALUResult,
           output logic [3:0]  ALUFlags);
  logic [31:0] condinvb;
  logic [31:0] sum;
  logic V, C, N, Z;

  assign condinvb = ALUControl[0] ? ~SrcB : SrcB;
  assign {C, sum} = SrcA + condinvb + ALUControl[0];
  assign V = (~ALUControl[1] & (SrcA[31] ^ sum[31]) & ~(ALUControl[0] ^ SrcA[31] ^ SrcB[31]));
  //assign C = (~ALUControl[1] & sum[32]) ? 1'b1 : 1'b0;
  assign N = ALUResult[31];
  assign Z = (ALUResult ==? 0) ? 1'b1 : 1'b0;


  always_comb
    casez (ALUControl[1:0])
      2'b0?: ALUResult = sum;
      2'b10: ALUResult = SrcA & SrcB;
      2'b11: ALUResult = SrcA | SrcB;
    endcase

//  assign ALUFlags = 4'b0000;
//  assign ALUFlags = {V, C, N, Z};
  assign ALUFlags = {N, Z, C, Z};
endmodule