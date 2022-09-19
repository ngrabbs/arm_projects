# Arm Single Cycle processor from Digital Design and Computer Architecture ARM Edition

This is a SystemVerilog project heavily based off the single cycle arm processor in the book: [DD&CA ARM Edition](https://www.amazon.com/Digital-Design-Computer-Architecture-ARM/dp/0128000562/)

My goal is to have the three versions (single cycle / multi cycle / pipelined) of the ARM processor described in the DD&CA book working on a couple different fpga dev boards that I have.  

The main board that I have been using is a go-board from [nandland.com](https://nandland.com/the-go-board/).  Nandland has a very affordable board to get started with fpga and a lot of great tutorials and hdl information.

build and test the processor:
iverilog -g2009 -o arm_tb.o arm_tb.sv arm.sv controller.sv datapath.sv adder.sv condlogic.sv decoder.sv extend.sv flopr.sv mux2.sv regfile.sv flopenr.sv top.sv dmem.sv imem.sv alu.sv; vvp arm_tb.o
iverilog -g2005-sv -o arm_tb.o arm_tb.sv arm.sv controller.sv datapath.sv adder.sv condlogic.sv decoder.sv extend.sv flopr.sv mux2.sv regfile.sv flopenr.sv top.sv dmem.sv imem.sv alu.sv; vvp arm_tb.o

if you want to just test the assembler on the pi:
pi@raspberrypi:~ $ as -o arm_test_example_os.o arm_test_example_os.s
pi@raspberrypi:~ $ objdump -S arm_test_example_os.o
pi@raspberrypi:~ $ gcc -o arm_test_example_os arm_test_example_os.o
pi@raspberrypi:~ $ gdb -tui ./arm_test_example_os
  -> in gdb:
    -> b main
    -> run
    -> layout asm
    -> layout reg

gdb:
https://jacobmossberg.se/posts/2017/01/17/use-gdb-on-arm-assembly-program.html

arm assembler:
https://thinkingeek.com/2013/01/20/arm-assembler-raspberry-pi-chapter-6/