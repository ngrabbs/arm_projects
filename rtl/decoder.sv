module decoder(input  logic [1:0] Op,
               input  logic [5:0] Funct,
               input  logic [3:0] Rd,
               output logic [1:0] FlagW,
               output logic       PCS, RegW, MemW,
               output logic       MemtoReg, ALUSrc,
               output logic [1:0] ImmSrc, RegSrc,
               output logic [2:0] ALUControl,
               output logic       NoWrite,
               output logic       Shift);
  logic [9:0] controls;
  logic       Branch, ALUOp;

  // Main Decoder
  always_comb
    case (Op)
                            // Data processing immediate
      2'b00: if (Funct[5])  controls = 10'b0000101001;
                            // Data processing register
             else           controls = 10'b0000001001;
                            // LDR
      2'b01: if (Funct[0])  controls = 10'b0001111000;
                            // STR
             else           controls = 10'b1001110100;
                            // B
      2'b10:                controls = 10'b0110100010;
                            // Unimplemented
      default:              controls = 10'bx;
    endcase

  assign {RegSrc, ImmSrc, ALUSrc, MemtoReg,
    RegW, MemW, Branch, ALUOp} = controls;

  // ALU Decoder
  always_comb
    if (ALUOp) begin                    // Which DP Instr?
      case (Funct[4:1])
        4'b0100: begin                  // add
                   ALUControl = 3'b000;
                   NoWrite = 1'b0;
                   Shift = 1'b0;
                 end
        4'b0010: begin                  // sub
                   ALUControl = 3'b001;
                   NoWrite = 1'b0;
                   Shift = 1'b0;
                 end
        4'b0000: begin                  // and
                   ALUControl = 3'b010;
                   NoWrite = 1'b0;
                   Shift = 1'b0;
                 end
        4'b1100: begin                  // or
                   ALUControl = 3'b011;
                   NoWrite = 1'b0;
                   Shift = 1'b0;
                 end
        4'b1000: begin                  // tst
                   ALUControl = 3'b010;
                   NoWrite = 1'b1;
                   Shift = 1'b0;
                 end
        4'b1101: begin                  // lsl
                   ALUControl = 3'b000;
                   NoWrite = 1'b0;
                   Shift = 1'b1;
                 end
        4'b1011: begin                  // cmn
                   ALUControl = 3'b000;
                   NoWrite = 1'b1;
                   Shift = 1'b0;
                 end
        4'b0101: begin                  // adc
                   ALUControl = 3'b100;
                   NoWrite = 1'b0;
                   Shift = 1'b0;
                 end
        default: begin                  // unimplemented
                   ALUControl = 3'bx;
                   NoWrite = 1'bx;
                   Shift = 1'bx;
                 end
      endcase
      // update flags if S bit is set
      // (C & V only updated for arith instructions)
      FlagW[1]      = Funct[0]; // FlagW[1] = S-bit
      // FlagW[0] = S-bit & (ADD | SUB)
      FlagW[0] = Funct[0] &
        (ALUControl[1:0] == 2'b00 | ALUControl[1:0] == 2'b01);


    end else begin
        ALUControl = 3'b000; // add for non-dp instructions
        FlagW      = 2'b00; // dont update flags
        NoWrite    = 1'b0;
        Shift      = 1'b0;
    end

  // PC Logic
  assign PCS = ((Rd == 4'b1111) & RegW) | Branch;
endmodule
