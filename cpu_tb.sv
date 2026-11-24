`timescale 1ns/1ps

module cpu_tb;

    // inputs
    logic clock;
    // outputs
    logic [15:0] rd_before_tb;
    logic [15:0] rd_after_tb;
    logic [15:0] current_pc_tb;
    logic [15:0] current_instr_tb;

    // global variables 
    localparam int NUM_CYCLES = 32; // number of cycles of the test including cycle 0 NOP
    localparam int SW_CHECK_CYLE = 27;  // cycle after the SW instruction
    localparam int DATA_MEMORY_BYTES = 64;  // number of bytes in the data memory

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

    // array of expected pc address for each cycle
    logic [15:0] expected_pc [0:NUM_CYCLES-1] = '{
        16'h0000,   // cycle 0: add r0, r0
        16'h0002,   // cycle 1: addi r1, r0, 1
        16'h0004,   // cycle 2: addi r2, r0, 2
        16'h0006,   // cycle 3: addi r3, r0, 3
        16'h0008,   // cycle 4: addi r4, r0, 4
        16'h000a,   // cycle 5: addi r5, r0, 5
        16'h000c,   // cycle 6: addi r6, r0, 6
        16'h000e,   // cycle 7: addi r7, r0, 7
        16'h0010,   // cycle 8: addi r8, r7, 1
        16'h0012,   // cycle 9: addi r9, r8, 1
        16'h0014,   // cycle 10: addi r10, r9, 1
        16'h0016,   // cycle 11: addi r11, r10, 1
        16'h0018,   // cycle 12: addi r12, r11, 1
        16'h001a,   // cycle 13: addi r13, r12, 1
        16'h001c,   // cycle 14: addi r14, r13, 1
        16'h001e,   // cycle 15: addi r15, r14, 1
        16'h0020,   // cycle 16: add r1, r2
        16'h0022,   // cycle 17: addi r4, r3, 5
        16'h0024,   // cycle 18: jmp 1
        16'h0028,   // cycle 19: add r1, r0
        16'h002a,   // cycle 20: sub r5, r6
        16'h002c,   // cycle 21: sll r1, r2
        16'h002e,   // cycle 22: addi r6, r4, 7
        16'h0030,   // cycle 23: and r5 ,r6
        16'h0032,   // cycle 24: addi r13, r13, 1
        16'h0034,   // cycle 25: beq r8, r12, 3
        16'h0036,   // cycle 26: sw r1, r0, 2
        16'h0038,   // cycle 27: lw r8, r0, 2
        16'h003a,   // cycle 28: bne r8, r4, -5
        16'h0032,   // cycle 29: addi r13, r13, 1
        16'h0034,   // cycle 30: beq r8, r12, 3
        16'h003c    // cycle 31: add r13, r0
    };

    // exepcted data memory after test has run
    logic [7:0] expected_mem [0:DATA_MEMORY_BYTES-1] = '{3: 8'h0c, default: 8'h00};

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
        // check rd_after output
        if (rd_after_tb !== expected_rd[cycle]) begin
            errCount++;
            $error("cycle %0d: rd output was %h, expected %h", cycle, rd_after_tb, expected_rd[cycle]);
        end
        // check pc
        if (current_pc_tb !== expected_pc[cycle]) begin
            errCount++;
            $error("cycle %0d: pc was %h, expected %h", cycle, current_pc_tb, expected_pc[cycle]);
        end
        // check the data memory from the SW instruction
        if (cycle == SW_CHECK_CYLE) begin
            if (test.dm.data_mem[2] !== 8'h00) begin
                errCount++;
                $error("cycle %0d: data at memory address 0x0002 was %h, expected %h", cycle, test.dm.data_mem[2], 8'h00);
            end 
            if (test.dm.data_mem[3] !== 8'h0c) begin
                errCount++;
                $error("cycle %0d: data at memory address 0x0003 was %h, expected %h", cycle, test.dm.data_mem[3], 8'h0c);
            end 
        end
        cycle++;
        if (cycle == NUM_CYCLES) begin
            // check against expected data memory after full test instruction execution
            foreach (expected_mem[i]) begin
                if (test.dm.data_mem[i] !== expected_mem[i]) begin
                    errCount++;
                    $error("data at memory address 0x%04h was %h, expected %h", i[15:0], test.dm.data_mem[i], expected_mem[i]);
                end
            end
            if (errCount == 0)
                $display("PASS");
            else
                $display("FAIL: %0d errors", errCount);
            $finish;   
        end
    end

    // initial begin
    //     $dumpfile("cpu.vcd");
    //     $dumpvars(0, cpu_tb);
    // end    
    
endmodule
