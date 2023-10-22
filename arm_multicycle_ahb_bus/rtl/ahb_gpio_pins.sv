`timescale 1ns/1ps
module abh_gpio_pins(input  logic [31:0] pin_dir, // 1 = output, 0 = input
                 input  logic [31:0] pin_out, // value to drive on outputs
                 output logic [31:0] pin_in,  // value to read from pins
                 inout   tri  [31:0] pin);    // tristate pins
  // Individual tristate control of each pin
  // No graceful way to control tristates on a per-bit basis in SystemVerilog
  genvar i;
  generate
  for (i=0; i<32; i = i+1) begin: pinloop
    assign pin[i] = pin_dir[i] ? pin_out[i] : 1'bz;
  end
  endgenerate

  assign pin_in = pin;
endmodule
