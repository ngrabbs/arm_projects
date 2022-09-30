`timescale 1ns/1ps
module spi_slave(input  logic       sck, // From master
                 input  logic       mosi, // From master
                 output logic       miso, // To master
                 input  logic       reset, // System reset
                 input  logic [7:0] d, // Data to send
                 output logic [7:0] q); // Data received
  logic [2:0] cnt;
  logic       qdelayed;

  // 3-bit counter tracks when full byte is transmitted
  always_ff @(negedge sck, posedge reset)
    if (reset) cnt <= 0;
    else       cnt <= cnt + 3'b1;

  // Loadable shift register
  // Loads d at the start, shifts mosi into bottom on each step
  always_ff @(posedge sck)
    q <= (cnt == 0) ? {d[6:0], mosi } : {q[6:0], mosi};

  // Align mosi to falling edge of sck
  // Load d at the start
  always_ff @(negedge sck)
    qdelayed <= q[7];
  assign miso = (cnt == 0) ? d[7] : qdelayed;
endmodule
