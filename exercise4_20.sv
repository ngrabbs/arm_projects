module ex4_20(input  logic [7:0] a,
              output logic [2:0] y,
              output logic NONE);
  assign y = (a ==? 8'b1xxxxxxx) ? 3'b111 :
             (a ==? 8'bx1xxxxxx) ? 3'b110 :
             (a ==? 8'bxx1xxxxx) ? 3'b101 :
             (a ==? 8'bxxx1xxxx) ? 3'b100 :
             (a ==? 8'bxxxx1xxx) ? 3'b011 :
             (a ==? 8'bxxxxx1xx) ? 3'b010 :
             (a ==? 8'bxxxxxx1x) ? 3'b001 :
             (a ==? 8'bxxxxxxx1) ? 3'b000 :
                                   3'b000;
  assign NONE = (a ==? 8'b00000000) ? 1'b1 : 1'b0;
endmodule  