`include "defines.sv"
`timescale 1ns/1ns
// testbench to run everything, make sure that things make sense
module full_tb;
    // local variables to make program counter, memory, and register work
    reg [15:0] reg_write = 'h0000; // write to register
    reg [15:0] mem_write = 'h0000; // the thing to write to memory

    logic [15:0] reg_result = 'h0; // result of the tested operation
    logic [15:0] dmem_result = 'h0;

    int idx = 3; // index value of the registers
    logic clock = 1; // clock
    int reg_operation_type = `WRITE; // type of operation for registers
    int daddr = 'h40;
    int iaddr = 'h0;
    
    int current_address = 0;
    int next_address = 0;
    logic [15:0] instruction = 'h0; // directly driven by imem
//    logic [15:0] fetched_instruction = 'h0;
    logic branch_flag = 0;
    logic branch_select_flag = 0;
    logic alu_zero_flag = 0;
    logic jump_flag = 0;

     // added local variables to make control, alu_control, and alu work
     // Control
     logic [3:0] opcode;            // 4-bit opcode - will be assigned instruction[15:12]
     logic control_reset = 0;       // should always be 0 unless testing
     logic mem_to_reg_flag;         // mem_to_reg control output to pass to write memToReg MUX
     logic [1:0] alu_op;            // alu_op control output to pass to alu control unit
     reg mem_read_flag = 1;           // mem_read control output to pass to data memory
     reg mem_write_flag = 0;          // mem_write control output to pass to data memory 
     logic aluSrc_flag;             // aluSrc control output to pass to alu (chooses whether to use input1 or sign-extended immediate)
     reg reg_write_flag = 1;          // reg_write control output to write memToReg MUX output to reg1
     reg reg_read_flag = 0;

     // ALU Control 
     logic [3:0] func;              // 4-bit funct field - will be assigned instruction[3:0]
     logic [2:0] alu_control_out;   // 3-bit alu control unit output to pass to alu (picks which alu operation to perform)

     // ALU
     logic [15:0] reg1_contents;    // contents of register 1 from reg to pass into alu "input1" input
     logic [15:0] reg2_contents;    // contents of register 2 from reg to pass into alu "input2" input
     logic [15:0] alu_result;       // alu output result to pass into memToRegMUX

     // Data memory
     logic [15:0] data_memory_output = 'h0;   // Word loaded from memory address calculted by alu - alu_result (SHOULD ONLY HAVE OUTPUT ON LW INSTRUCTIONS)

     // memToReg MUX
     logic [15:0] memToReg_mux_output = 'h0;  // 16-bit information - either alu_result or data_memory_output



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
        .write_flag(reg_write_flag),
        .clock(clock),
        .incomingData(reg_write),
        .outgoingData(reg_result)
    );

    instruction_memory imem 
    (
        .addr(iaddr),
        .outWord(instruction)
    );

     data_memory dmem
     (
       .inWord(mem_write),
       .outWord(dmem_result),
       .addr(daddr),
       .clock(clock),
       .read_flag(mem_read_flag),
       .write_flag(mem_write_flag)
     );


     // added instantiation of control, alu_control, and alu
    control con 
    (
        .opcode(opcode),                    // input
        .control_reset(control_reset),      // input
        .jump(jump_flag),                   // output
        .branch(branch_flag),               // output
        .branch_select(branch_select_flag), // output
        .mem_read(mem_read_flag),           // output
        .mem_to_reg(mem_to_),               // output
        .alu_op(alu_op),                    // output
        .mem_write(mem_write_flag),         // output
        .aluSrc(aluSrc_flag),               // output
        .reg_write(reg_write_flag)          // output
    );

    alu_control alu_con
    (
        .alu_op(alu_op),                    // input
        .func(func),                        // input
        .alu_control_var(alu_control_out)   // output
    );

    alu alu
    (
        .input1(reg1_contents),             // input
        .input2(reg2_contents),             // input
        .fullInstr(instruction),            // input
        .flag_aluSrc(aluSrc_flag),          // input
        .alu_control_out(alu_control_out),  // input
        .result(alu_result),                // output
        .zero_flag(alu_zero_flag)          // output
    );

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

    instruction_memory imem 
    (
        .addr(iaddr),
        .outWord(instruction)
    );

     data_memory dmem
     (
       .inWord(mem_write),
       .outWord(mem_result),
       .addr(daddr),
       .read_flag(mem_read_flag),
       .write_flag(mem_write_flag)
     );


    initial begin
        #1 $stop();
        $dumpfile("tb.vcd");
        $dumpvars(); // dumpvars  
//        $monitor("reg_write = %4h, mem_write = %4h, reg idx = %2d, current_address = %2d, next_address = %2d, addr = %2d, time = %2d", reg_write, mem_write, idx, current_address, next_address, addr, $time);
        $stop();
        #120 $finish();
    end   

    // pc testbench, integrated with register and memory
    always begin
        // #1 clock = 1; // posedge
        /*
         steps: grab address (current_address) 0 from memory and read it, giving it to pc
         this will be the first instruction read 
         then, starting at current_address 0 it should increment the address by 2
         and store it in the register file
        */
//        $stop(); // stop at the beginning of every cycle
        `ifdef dbg
        $display("[debug:tb] BOOP! NEW CYCLE AT %t!", $time);
        `endif
        #1 
        // ------- IMPLICITLY READS MEMORY AND FETCHES THE INSTRUCTION (stored in mem_result) BASED ON WHATEVER THE CURRENT ADDRESS IS (should be set from previous iteration) 
//        #1
        // CONTROL CODE UNIT
        opcode = instruction[15:12];    // Set opcode to first 4 bits of fetched instruction - triggers the control module to produce new outputs.
                                        // jump_flag, branch_flag, branch_select_flag, mem_read_flag, mem_to_reg_flag, alu_op, mem_write_flag, aluSrc, reg_write_flag
                                        // updates and wait for other inputs in their respective modules to produce a meaningful output.
        #1
        // ALU CONTROL UNIT
        func = instruction[3:0];        // Set func to last 4 bits of fetched instruction (alu _control module produces meaningful output).
                                        // alu_control_out will output from alu_control. Wait for reg1_contents and reg2_contents to be updated 
                                        // in order for alu module to produce a meaningful output.
        #1
        // ALU
        reg_operation_type = `READ;     // set reg operation to READ from register and store contents in reg_result
        idx = instruction[11:8];        // Read register 1 (rt/rd)
        reg1_contents = reg_result;     // Store the read data from register 1 to reg1_contents. Updates "input1" input in alu module.
        #1 // index is changing, ra module should trigger
        idx = instruction[7:4];         // Read register 2 (rs)
        reg2_contents = reg_result;     // Store the read data from register 2 to reg2_contents. Updates "input2" input in alu module.
                                        // At this point, alu will produce a meaningful output since all the inputs are updated.

        // DATA MEMORY
        // TODO: 
                // - need to assign "addr" input of data memory module to the alu output (alu_result = R[rs] + imm)
                //     - For SW, write reg1_contents to alu_result (memory address). NO OUTPUT.
                //     - For LW, read from alu_result (memory address). OUTPUT = contents read from memory. Output is used in memToReg MUX. 
                // - need to modify nathan's data memory module to take mem_read and mem_write flags and set optype depending on which flag is 1.
                // - need to add a reg1_contents input to nathan's data memory module for SW purposes.


        // MEMTOREG MUX
        memToReg_mux_output = (mem_to_reg_flag) ? data_memory_output : alu_result;  // choose between alu result or data memory outputs

        // ------- SELECT PC REG AND WRITE CURRENT ADDRESS (calculated from last iteration) TO PC REG (1st iteration 0X0000)
        #1 
        idx = `PCR; // PC register index
        reg_operation_type = `WRITE;
        #1 clock = 0;

        // ------- READ THE ADDR ADDRESS (0x0000 in beginning) AND PASS THE FETCHED INSTRUCTION TO PC [DUPLICATE JUST FOR FIRST ITERATION]
//        instruction = dmem_result;

        // ------- WAIT FOR PC TO COMPUTE THE NEXT ADDRESS - PC IS THE ONLY CLOCKED MODULE
        #1 clock = 1;


        // WRITE BACK (to register 1)
        if (reg_write_flag) begin
            reg_operation_type = `WRITE;        // Set reg operation to WRITE to register.
            reg_write = memToReg_mux_output;    // Set data to write to the memToReg MUX output. Should either be alu_result or data_memory_output.
            // index change, reg should read
            idx = instruction[11:8];            // Write to register 1
        end 
        
            // do nothing since we do not need to write back to register

        #1 clock = 0;


        // ------- WRITE THE NEXT ADDRESS TO PC REG
        #1 reg_write = next_address; // update program counter 


        // ------- READ THE NEXT ADDRESS FROM PC REG
        // commmits the write to the pcr
        // now read it
        #1
        reg_operation_type = `READ;


        // ------- PASS THE NEXT ADDRESS TO THE PC TO SET UP NEXT ITERATION - DOESN'T EXECUTE THIS ITERATION (NEXT ITERATION WILL BEGIN WITH WRITING TO PC REG)
        #1
        current_address = reg_result; // update program counter's address


        // ------- GIVE THE NEXT_ADDRESS TO THE MEMORY UNIT TO FETCH THE INSTRUCTION OF THE NEXT ADDRESS
        iaddr = current_address; // get next word
       
        // ------- GET THE RESULT FROM THE MEMORY UNIT AND FEED THE FETCHED INSTRUCTION TO PC (fullInstr input) TO SET UP NEXT ITERATION
   
    end



endmodule