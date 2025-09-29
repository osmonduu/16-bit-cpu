# 16-bit CPU
16-bit non-pipleined processor implemented in SystemVerilog. The processor has a word size of 16-bits, byte addressable, and has a 64 byte (32 instruction) memory size.

# Supported Instructions
The processor supports the following instructions:
- ADD
- SUB
- SLL
- AND
- LW
- SW
- ADDI
- BEQ
- BNE
- JMP

Included is a python script, `assmebler.py`, that takes an input file of assembly instructions supported by the processor and outputs a file translated into a hexadecimal byte addressable format that can be copy and pasted into `memory.sv` in the `instruction_memory` module.  

# About
This project was completed in collaboration with Herbert Acheampong, Nathan Fox, and Dhiraj Patil. 
