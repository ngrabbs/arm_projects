# ARM Single Cycle processor from Digital Design and Computer Architecture ARM Edition

This is a SystemVerilog project heavily based off the single cycle arm processor in the book: [DD&CA ARM Edition](https://www.amazon.com/Digital-Design-Computer-Architecture-ARM/dp/0128000562/)

## Goal
My goal is to have the three versions (single cycle / multi cycle / pipelined) of the ARM processor described in the DD&CA book working on a couple different fpga dev boards that I have.  

## FPGA Boards
The main board that I have been using is a go-board from [nandland.com](https://nandland.com/the-go-board/).  Nandland has a very affordable board to get started with fpga and a lot of great tutorials and hdl information.  The syth and implementation tools im using with the go-board are from [oss-cad-suite](https://github.com/YosysHQ/oss-cad-suite-build), they're open source, work with Makefiles and are very easy to learn.  I have generated a bit steam and programmed a de0nano board through quartus prime lite with the single cycle code as well but I dont like to use windows as much as mac / linux so the de0nano doesnt get used very much.  Recently i've picked up an [arty-a7](https://digilent.com/shop/arty-a7-artix-7-fpga-development-board/) from digilent as well as a [arty-z7](https://digilent.com/shop/arty-z7-zynq-7000-soc-development-board/) to practice learning Vivado & Vitus with.  I have the arm single cycle working on the arty-a7 as well and will put the build files here.

## About the ARM Single Cycle
The book says that a computer architecture is defined by its instruction set and architectural state.   The architectural state for the ARM processor consistes of 16 32-bit registers and a status register.  We're also using a 32 bit wide memory address as well as 32 bit wide memory data.

At the time of this writing we only have a few instructions and as I add more i'll try to remember to update this readme.
#### Data Processing:
* ADD
* SUB
* AND
* ORR
#### Memory Instructions:
* LDR
* STR
#### Branches:
* B

## MISC
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