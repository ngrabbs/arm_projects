module fsm1(input  logic clk, reset,
            input  logic taken, back,
            output logic predicttaken);
  logic [4:0] state, nextstate;

  parameter S0 = 5'b00001;
  parameter S1 = 5'b00010;
  parameter S2 = 5'b00100;
  parameter S3 = 5'b01000;
  parameter S4 = 5'b10000;

  always_ff @(posedge clk, posedge reset)
    if (reset) state <= S2;
    else       state <= nextstate;
  
  always_comb
    case (state)
      S0: if (taken) nextstate = S1;
          else       nextstate = S0;
      S1: if (taken) nextstate = S2;
          else       nextstate = S0;
      S2: if (taken) nextstate = S3;
          else       nextstate = S1;
      S3: if (taken) nextstate = S4;
          else       nextstate = S2;
      S4: if (taken) nextstate = S4;
          else       nextstate = S3;
      default:       nextstate = S2;
    endcase

  assign predicttaken = (state == S4) |
                        (state == S3) | 
                        (state == S2 && back);
endmodule