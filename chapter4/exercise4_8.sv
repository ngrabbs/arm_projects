module mux8(input logic [2:0] a,
            input logic d0, d1, d2, d3, d4, d5, d6, d7,
            output logic y);
  assign y = (a ==? 3'b000) ? d0 :
             (a ==? 3'b001) ? d1 :
             (a ==? 3'b010) ? d2 :
             (a ==? 3'b011) ? d3 :
             (a ==? 3'b100) ? d4 :
             (a ==? 3'b101) ? d5 :
             (a ==? 3'b110) ? d6 :
             (a ==? 3'b111) ? d7 :
                    3'b000;
endmodule