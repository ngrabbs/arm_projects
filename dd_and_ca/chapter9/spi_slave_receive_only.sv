`timescale 1ns/1ps
module spi_slave_receive_only(input  logic       sck,  // From Master
                              input  logic       mosi, // From Master
                              output logic [7:0] q);   // Data received
  always_ff @(posedge sck)
    q <= {q[6:0], mosi}; // shift register
endmodule
