#!/usr/bin/env python
# shebang for linux

'''
  - To use this script, you have to provide it an input and output file.
  - An example of how to run the script is "python assmebler.py [input].txt [output].txt"
  - The input file must include assembly instructions such as:
    add r1, r2
    sub r2, r0
    sll r1, r3
    and r2, r4
    lw  r3, r4
    sw  r2, r1, 8
    addi r2, r3, 2
    beq r0, r0, 12
    bne r0, r1, 3
    jmp 2025
  - The script ignores empty lines and lines starting with '#' (comments)
  - To provide an offset value for lw and sw, you must follow this format: lw r2, r3, 5.
    - You can omit the last 'parameter' if you don't want an offset
'''

INSTRUCTION_SET = {
  # R-type instructions
  "add":  {"opcode": "0000", "funct": "0000", "type": "R"},
  "sub":  {"opcode": "0000", "funct": "0001", "type": "R"},
  "sll":  {"opcode": "0000", "funct": "0010", "type": "R"},
  "and":  {"opcode": "0000", "funct": "0011", "type": "R"},
  # I-type instructions
  "lw":   {"opcode": "0001", "type": "I"},
  "sw":   {"opcode": "0010", "type": "I"},
  "addi": {"opcode": "0011", "type": "I"},
  "beq":  {"opcode": "0100", "type": "I"},
  "bne":  {"opcode": "0101", "type": "I"},
  # J-type instructions
  "jmp":  {"opcode": "0110", "type": "J"},
}

null_instruction = "'h00, 'h00" # 16 zeros

def parse_four_bits(reg_str: str) -> str:
  # do some safety measures to remove any unremoved commas or leading and ending spaces
  reg_str = reg_str.lower().replace(',', '').strip()
  # remove leading 'r' (if register), cast to int, and then cast to 4-bit binary string
  if reg_str.startswith('r'):
    reg_str = reg_str[1:]
    reg_num = int(reg_str)
    return format(reg_num, '04b')
  # check if negative (-) imm
  elif reg_str.startswith('-'):
    neg_num = int(reg_str)      # cast to int to get signed int
    return format(neg_num & 0b1111, '04b')  # mask last 4 bits and turn into 4-bit string
  # just turn into 4-bit string if passed a positive imm
  else: 
    pos_num = int(reg_str)
    return format(pos_num, '04b')




# parse_assembly will take in an assembly function and
# return a string of 16-bits representing the insturction in binary.
def parse_assembly_instr(line: str) -> str :
  # remove trailing and leading spaces
  line = line.strip()

  # return None if empty line or a comment (i just wanna use comments to check if this shit works)
  if not line or line.startswith('#'):
    return None

  # replace commas with white paces
  parts = line.replace(',', ' ').split()

  # get instr name
  instr = parts[0].lower()

  if instr not in INSTRUCTION_SET:
    raise ValueError(f"Unknown instruction: {instr}")

  # get rest of information about the instruction
  opcode = INSTRUCTION_SET[instr]["opcode"]
  instr_type = INSTRUCTION_SET[instr]["type"]

  if instr_type == "R":
      # parts should be length 3 - instr rt/rd, rs
      if not (len(parts) == 3):
          print(f"bad instruction: {line}")
          raise ValueError(f"R-type instruction should have 2 'parameters': rt/rd and rs")
      rt_rd = parse_four_bits(parts[1])
      rs = parse_four_bits(parts[2])
      funct = INSTRUCTION_SET[instr]["funct"]
      return opcode + rt_rd + rs + funct

  elif instr_type == "I":
    # parts can be length 3 or 4 - instr rt/rd, rs, (immediate)
    rt_rd = parse_four_bits(parts[1])
    rs = parse_four_bits(parts[2])
    imm = 0
    # if immediate value is not specified in the instruction, set it to 0.
    if len(parts) == 3:
      imm = format(imm, '04b')
    else: 
      if not (-8 <= int(parts[3]) <= 7):
        raise ValueError("Immediate value should be between -8 and 7 (inclusive)")
      imm = parse_four_bits(parts[3])
    return opcode + rt_rd + rs + imm

  elif instr_type == "J":
    # parts should be length 2 - jmp addr
    addr = parts[1]
    if not (-2048 <= int(addr) <= 2047):
      raise ValueError("Address value should be between -2048 and 2047 (inclusive)")
    addr = parse_twelve_bits(addr) 
    return opcode + addr

  else:
    # do nothing, maybe raise an error or smth
    raise ValueError("Yo how tf u get here. There shouldn't even be another type.")

def parse_twelve_bits(addr: str) -> str:
  # do some safety measures to remove any unremoved commas or leading and ending spaces
  addr = addr.replace(',', '').strip()
  # check if negative (-) imm
  if addr.startswith('-'):
    neg_num = int(addr)      # cast to int to get signed int
    return format(neg_num & 0b111111111111, '012b')  # mask last 12 bits and turn into 12-bit string
  # just turn into 12-bit string if passed a positive imm
  else: 
    pos_num = int(addr)
    return format(pos_num, '012b')


def parse_file(input_file: str, output_file: str):
  with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
    linenum = 0 # keep track of the number of instructions read
    for line in infile:
      sixteen_bit_instr = parse_assembly_instr(line)
      # skip line if empty
      if sixteen_bit_instr is not None:
        linenum += 1
        # print(sixteen_bit_instr)
        hex_instruction = f"{int(sixteen_bit_instr, 2):04x}"
        # print(hex_instruction)

        outfile.write("'h" + hex_instruction[0:2] + ", ")
        outfile.write("'h" + hex_instruction[2:] + ", \n")

    # pad all with NOPS until 64 bytes (32 lines)
    if linenum < 33:
      for i in range(linenum, 32):
        if (i == 31):
          outfile.write(null_instruction + "\n")
        else:
          outfile.write(null_instruction + ", \n")


    # for i in range(0, 64):
    #     # This is just to add on the data memory, which should all be 0
    #   outfile.write("0000000000000000\n") # all null bytes

if __name__ == "__main__":
  import sys
  if len(sys.argv) != 3:
    print("Format should be: python assembler.py [input].s [output].mem")
    sys.exit(1)

  input_file = sys.argv[1]
  output_file = sys.argv[2]
  parse_file(input_file, output_file)
  print(f"Avengers assembled. Written to {output_file}")