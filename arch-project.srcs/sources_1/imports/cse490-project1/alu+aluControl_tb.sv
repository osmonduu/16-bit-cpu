// `timescale 1ns/1ps

module alu_and_aluControl_tb;

  // Inputs to both modules
  logic [1:0] alu_op;
  logic [3:0] func;
  logic [2:0] alu_control_var;

  logic [15:0] input1, input2, fullInstr;
  logic        flag_aluSrc;

  logic [15:0] result;
  logic        zero_flag;

  // Instantiate ALU Control
  alu_control alu_control_u (
    .alu_op(alu_op),
    .func(func),
    .alu_control_var(alu_control_var)
  );

  // Instantiate ALU
  alu alu_u (
    .input1(input1),
    .input2(input2),
    .fullInstr(fullInstr),
    .flag_aluSrc(flag_aluSrc),
    .alu_control_out(alu_control_var),
    .result(result),
    .zero_flag(zero_flag)
  );

  initial begin
    $dumpfile("alu_and_control_tb.vcd");
    $dumpvars(0, alu_and_control_tb);

    // ------------------------------------
    // TEST 1: I-Type ADD (ADDI / LW / SW)
    // alu_op = 00 -> ALU should do ADD
    // ------------------------------------
    alu_op       = 2'b00;
    func         = 4'hX;               // Don't care
    input1       = 16'h000A;
    input2       = 16'h0003;
    fullInstr    = 16'h0001;           // imm = 0x1 => signExtImm = 0x0001
    flag_aluSrc  = 1'b1;               // Use immediate
    #10;
    $display("\n[TEST 1] I-Type ADD:");
    $display("input2 = 0x%h, signExtImm = 0x%h => result = 0x%h, zero = %b",
              input2, {{12{fullInstr[3]}}, fullInstr[3:0]}, result, zero_flag);

    // ------------------------------------
    // TEST 2: BEQ-style (alu_op = 01) => SUB
    // ------------------------------------
    alu_op       = 2'b01;
    func         = 4'hX;
    input1       = 16'h0008;
    input2       = 16'h0008;
    fullInstr    = 16'h0000;
    flag_aluSrc  = 1'b0;
    #10;
    $display("\n[TEST 2] BEQ SUB (equal inputs):");
    $display("input1 = 0x%h, input2 = 0x%h => result = 0x%h, zero = %b",
              input1, input2, result, zero_flag);

    // ------------------------------------
    // TEST 3: R-Type ADD
    // alu_op = 10, func = 0000 => ADD
    // ------------------------------------
    alu_op       = 2'b10;
    func         = 4'b0000;
    input1       = 16'h000A;
    input2       = 16'h0007;
    fullInstr    = 16'h0000;
    flag_aluSrc  = 1'b0;
    #10;
    $display("\n[TEST 3] R-Type ADD:");
    $display("input1 = 0x%h, input2 = 0x%h => result = 0x%h, zero = %b",
              input1, input2, result, zero_flag);

    // ------------------------------------
    // TEST 4: R-Type SUB
    // alu_op = 10, func = 0001 => SUB
    // ------------------------------------
    alu_op       = 2'b10;
    func         = 4'b0001;
    input1       = 16'h000F;
    input2       = 16'h0014;
    flag_aluSrc  = 1'b0;
    #10;
    $display("\n[TEST 4] R-Type SUB:");
    $display("input1 = 0x%h, input2 = 0x%h => result = 0x%h, zero = %b",
              input1, input2, result, zero_flag);

    // ------------------------------------
    // TEST 5: R-Type SLL
    // alu_op = 10, func = 0010 => SLL
    // ------------------------------------
    alu_op       = 2'b10;
    func         = 4'b0010;
    input1       = 16'h0001;
    input2       = 16'h0003; // shift by 3
    flag_aluSrc  = 1'b0;
    #10;
    $display("\n[TEST 5] R-Type SLL:");
    $display("input1 = 0x%h << input2 = 0x%h => result = 0x%h",
              input1, input2, result);

    // ------------------------------------
    // TEST 6: R-Type AND
    // alu_op = 10, func = 0011 => AND
    // ------------------------------------
    alu_op       = 2'b10;
    func         = 4'b0011;
    input1       = 16'hF0F0;
    input2       = 16'h0FF0;
    flag_aluSrc  = 1'b0;
    #10;
    $display("\n[TEST 6] R-Type AND:");
    $display("input1 = 0x%h & input2 = 0x%h => result = 0x%h",
              input1, input2, result);

    // End of simulation
    #10;
    $display("\nAll tests complete.");
    $finish;
  end

endmodule
