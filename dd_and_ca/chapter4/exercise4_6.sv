module sevenseg(input  logic [3:0] digit,
                output logic [7:0] y);
  // https://en.wikipedia.org/wiki/Seven-segment_display
  always_comb
    case(digit)
      // digit        pabcdefg
      4'b0000: y = 8'b01111110; // 0
      4'b0001: y = 8'b00110000; // 1
      4'b0010: y = 8'b01101101; // 2
      4'b0011: y = 8'b01111001; // 3
      4'b0100: y = 8'b00110011; // 4
      4'b0101: y = 8'b01011011; // 5
      4'b0110: y = 8'b01011111; // 6
      4'b0111: y = 8'b01110000; // 7
      4'b1000: y = 8'b01111111; // 8
      4'b1001: y = 8'b01111011; // 9
      4'b1010: y = 8'b01110111; // A
      4'b1011: y = 8'b00011111; // B
      4'b1100: y = 8'b01001110; // C
      4'b1101: y = 8'b00111101; // D
      4'b1110: y = 8'b01001111; // E
      4'b1111: y = 8'b01000111; // F
    endcase
endmodule