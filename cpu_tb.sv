`timescale 1ns/1ps

module cpu_tb;

    // inputs
    logic clock;
    // outputs
    logic [15:0] rd_before_tb;
    logic [15:0] rd_after_tb;
    logic [15:0] current_pc_tb;
    logic [15:0] current_instr_tb;

    // array of expected values of rd 
    localparam int NUM_CYCLES = 32;
    logic [15:0] expected_rd [0:NUM_CYCLES-1] = '{
        16'h0000,   // cycle 0: NOP
        16'h0001,   // cycle 1: addi r1, r0, 1 -> r1 = 1
        16'h0002,   // cycle 2: addi r2, r0, 2 -> r2 = 2
        16'h0003,   // cycle 3: addi r3, r0, 3 -> r3 = 3
        16'h0004,   // cycle 4: addi r4, r0, 4 -> r4 = 4
        16'h0005,   // cycle 5: addi r5, r0, 5 -> r5 = 5
        16'h0006,   // cycle 6: addi r6, r0, 6 -> r6 = 6
        16'h0007,   // cycle 7: addi r7, r0, 7 -> r7 = 7
        16'h0008,   // cycle 8: addi r8, r7, 1 -> r8 = 8
        16'h0009,   // cycle 9: addi r9, r8, 1 -> r9 = 9
        16'h000a,   // cycle 10: addi r10, r9, 1 -> r10 = 10
        16'h000b,   // cycle 11: addi r11, r10, 1 -> r11 = 11
        16'h000c,   // cycle 12: addi r12, r11, 1 -> r12 = 12
        16'h000d,   // cycle 13: addi r13, r12, 1 -> r13 = 13
        16'h000e,   // cycle 14: addi r14, r13, 1 -> r14 = 14
        16'h000f,   // cycle 15: addi r15, r14, 1 -> r15 = 15
        16'h0003,   // cycle 16: add r1, r2 -> r1 = 3
        16'h0008,   // cycle 17: addi r4, r3, 5 -> r4 = 8
        16'h0000,   // cycle 18: jmp 1 (0x6001) -> rd = 0 (only because our jump isn't large enough)
        16'h0003,   // cycle 19: add r1, r0 -> r1 = 3
        16'hffff,   // cycle 20: sub r5, r6 -> r5 = -1
        16'h000c,   // cycle 21: sll r1, r2 -> r1 = 12
        16'h000f,   // cycle 22: addi r6, r4, 7 -> r6 = 15
        16'h000f,   // cycle 23: and r5, r6 -> r5 = 15
        16'h000e,   // cycle 24: addi r13, r13, 1 -> r13 = 14
        16'h0008,   // cycle 25: beq r8, r12, 3 -> r8 = 8 (branch not taken 8 != 12)
        16'h000c,   // cycle 26: sw r1, r0, 2 -> r1 = 12
        16'h000c,   // cycle 27: lw r8, r0, 2 -> r8 = 12
        16'h000c,   // cycle 28: bne r8, r4, -5 -> r8 = 12 (branch taken 12 != 8)
        16'h000f,   // cycle 29: addi r13, r13, 1 -> r13 = 15
        16'h000c,   // cycle 30: beq r8, r12, 3 -> r8 = 12 (branch taken 12 == 12)
        16'h000f    // cycle 31: add r13, r0 -> r13 = 15
    };
    
    // instantiate cpu module
    cpu test (
        .clock(clock),
        .rd_before(rd_before_tb),
        .rd_after(rd_after_tb),
        .current_pc(current_pc_tb),
        .current_instr(current_instr_tb)
    );
    
    // generate flipping clock
    initial begin
        clock = 0;
        forever begin
            #1 clock = ~clock;  //set high (posedge)
            #1 clock = ~clock;  //set low (negedge)
        end
    end
    
    // monitor the outputs
    // initial begin
    //     $display("Time\t\tPC\t\tInstr\t\trd_before\t\trd_after");
    //     $monitor("%0dns\t\t%h\t\t%h\t\t%h\t\t%h", $time, current_pc_tb, current_instr_tb, rd_before_tb, rd_after_tb);
    // end

    // check the output against our expected results
    int cycle = 1;
    int errCount = 0;
    always @(negedge clock) begin
        if (rd_after_tb !== expected_rd[cycle]) begin
            errCount++;
            $error("cycle %0d: got %h, expected %h", cycle, rd_after_tb, expected_rd[cycle]);
        end
        cycle++;
        if (cycle == NUM_CYCLES) begin
            if (errCount == 0)
                $display("PASS");
            else
                $display("FAIL: %0d errors", errCount);
            $finish;   
        end
    end

    // $dumpfile("cpu.vcd");
    // $dumpvars(0, cpu_tb);
    
endmodule
