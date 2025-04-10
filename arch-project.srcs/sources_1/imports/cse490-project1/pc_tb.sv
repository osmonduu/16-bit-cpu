//`timescale 1ns/1ps

module ProgramCounter_tb;

  // Inputs
  logic clock;
  logic [15:0] pc_current;
  logic flag_branch;
  logic flag_branch_select;
  logic aluZero;
  logic flag_jump;
  logic [15:0] fullInstr;

  // Output
  logic [15:0] pc_next;

  // Instantiate DUT
  ProgramCounter uut (
    .clock(clock),
    .pc_current(pc_current),
    .flag_branch(flag_branch),
    .flag_branch_select(flag_branch_select),
    .aluZero(aluZero),
    .flag_jump(flag_jump),
    .fullInstr(fullInstr),
    .pc_next(pc_next)
  );

  // Clock generation
  initial begin
    clock = 0;
    forever #5 clock = ~clock;
  end
  
/*
  // VCD dump for waveform viewing
  initial begin
    $dumpfile("ProgramCounter_tb.vcd");
    $dumpvars(0, ProgramCounter_tb);
  end
*/

  // Simulation logic
  initial begin
    // Initial values
    pc_current = 16'h0000;
    flag_branch = 0;
    flag_branch_select = 0;
    aluZero = 0;
    flag_jump = 0;
    fullInstr = 16'h0100;

    @(posedge clock); #1;
    $display("[Time %0t] Normal PC increment", $time);
    $display("pc_current = %h, pc_next = %h\n", pc_current, pc_next);
    pc_current = pc_next;

    // BEQ test
    flag_branch = 1;
    flag_branch_select = 0; // BEQ
    aluZero = 1;
    fullInstr = 16'h0002; // 4-bit imm = 2 => shifted = 4
    @(posedge clock); #1;
    $display("[Time %0t] BEQ taken (offset +2)", $time);
    $display("pc_current = %h, fullInstr = %h, pc_next = %h\n", pc_current, fullInstr, pc_next);
    pc_current = pc_next;

    // BNE test
    flag_branch = 1;
    flag_branch_select = 1; // BNE
    aluZero = 0;
    fullInstr = 16'h000E; // 4-bit imm = -2
    @(posedge clock); #1;
    $display("[Time %0t] BNE taken (offset -2)", $time);
    $display("pc_current = %h, fullInstr = %h, pc_next = %h\n", pc_current, fullInstr, pc_next);
    pc_current = pc_next;

    // JUMP test
    flag_branch = 0;
    flag_jump = 1;
    fullInstr = 16'h00F0;
    @(posedge clock); #1;
    $display("[Time %0t] JUMP", $time);
    $display("pc_current = %h, fullInstr = %h, pc_next = %h\n", pc_current, fullInstr, pc_next);
    pc_current = pc_next;

    // Normal increment again
    flag_jump = 0;
    flag_branch = 0;
    aluZero = 0;
    fullInstr = 16'h0000;
    @(posedge clock); #1;
    $display("[Time %0t] Normal PC increment again", $time);
    $display("pc_current = %h, pc_next = %h\n", pc_current, pc_next);

    #10;
    $finish;
  end
endmodule
