module mux4_1(input logic [1:0] a,
            input logic d0, d1, d2, d3,
            output logic y);

	always_comb begin
		case (a)
			2'b00 : y = d0;
			2'b01 : y = d1;
			2'b10 : y = d2;
			2'b11 : y = d3;
		endcase
	end

endmodule