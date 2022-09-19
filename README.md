# Arm Single Cycle processor from Digital Design and Computer Architecture ARM Edition

This is a SystemVerilog project heavily based off the single cycle arm processor in the [DD&CA ARM Edition](https://www.amazon.com/Digital-Design-Computer-Architecture-ARM/) book.
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