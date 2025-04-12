`include "defines.sv"
`timescale 1ns/1ns
// testbench to run everything, make sure that things make sense
module tb;
    reg [15:0] reg_write = 'h0000; // write to register
    reg [15:0] mem_write = 'h0000; // the thing to write to memory

    logic [15:0] reg_result = 'h0; // result of the tested operation
    logic [15:0] mem_result = 'h0;

    int idx = 3; // index value of the registers
    logic clock = 0; // clock
    int reg_operation_type = `WRITE; // type of operation for registers
    int mem_operation_type = `READ; // type of operation for memory
    int addr = 'h0;
    
    int current_address = 0;
    int next_address = 0;
    logic [15:0] instruction = 'h0;
    logic branch_flag = 0;
    logic branch_select_flag = 0;
    logic alu_zero_flag = 0;
    logic jump_flag = 0;
    
    

    ProgramCounter pc
    (
        .clock(clock),
        .pc_current(current_address),
        .flag_branch(branch_flag),
        .flag_branch_select(branch_select_flag),
        .aluZero(alu_zero_flag),
        .flag_jump(jump_flag),
        .pc_next(next_address),
        .fullInstr(instruction)
    );

    register ra
    (
        .index(idx),
        .accessType(reg_operation_type),
        .clk(clock),
        .incomingData(reg_write),
        .outgoingData(reg_result)
    );

     memory mem(
    
       .clock(clock),
       .inWord(mem_write),
       .outWord(mem_result),
       .addr(addr),
       .optype(mem_operation_type)
     );
    
    

    initial begin

        $dumpfile("tb.vcd");
        $dumpvars(1); // dumpvars  
//        $monitor("reg_write = %4h, mem_write = %4h, reg idx = %2d, current_address = %2d, next_address = %2d, addr = %2d, time = %2d", reg_write, mem_write, idx, current_address, next_address, addr, $time);
        #120 $finish();
    end   

    // pc testbench, integrated with register and memory
    always begin
        /*
         steps: grab address (current_address) 0 from memory and read it, giving it to pc
         this will be the first instruction read 
         then, starting at current_address 0 it should increment the address by 2
         and store it in the register file
        */
//        $stop(); // stop at the beginning of every cycle
        idx = `PCR; // PC register index
        reg_operation_type = `WRITE;
        instruction = mem_result;
        #1 clock = 1;
        #1 clock = 0;
        reg_write = next_address; // update program counter 
        // commmits the write to the pcr
        // now read it
        reg_operation_type = `READ;
        current_address = reg_result; // update program counter's address
        addr = current_address; // get next word
        instruction = mem_result;
    end



endmodule