/* -- Code section */
.text
.balign 4
.global main
main:
  mov r0, #0x2
  lsl r0, r0, #8
  add r0, #0x2
  lsl r0, r0, #20
  mov r1, #1
loop:
  str r1, [r0]
  lsl r1, r1, #1
  str r1, [r0]
  lsl r1, r1, #1
  str r1, [r0]
  mov r1, #1
  b loop
/*
[nick@MacBook-Pro.local ~/Documents/main_backup/arm_projects/asm_progs]$ arm-none-eabi-as -o arm_test_write_to_address.o arm_test_write_to_address.s
[nick@MacBook-Pro.local ~/Documents/main_backup/arm_projects/asm_progs]$ arm-none-eabi-objdump -S arm_test_write_to_address.o

arm_test_write_to_address.o:     file format elf32-littlearm


Disassembly of section .text:

00000000 <main>:
   0:   e3a00001        mov     r0, #1
   4:   e3a01202        mov     r1, #536870912  ; 0x20000000
   8:   e3a03602        mov     r3, #2097152    ; 0x200000
   c:   e7810003        str     r0, [r1, r3]
[nick@MacBook-Pro.local ~/Documents/main_backup/arm_projects/asm_progs]$
 */