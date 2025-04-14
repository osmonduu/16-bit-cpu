
module cpu (
    input logic clock,                  // input clock
    output logic [15:0] rd,             // rd contents after "write"
    output logic [15:0] current_pc,     // for debugging in testbench
    output logic [15:0] current_instr   // for debugging in testbench
);

// PC Register - stores the pc output and next instruction for use in the next cycle.
// When pc uses this value, that means pc is using the pc_next that was derived from last cycle.
logic [15:0] pc_reg = 'h0000;   // start at first instruction

// pc local variables
logic [15:0] current_instr_address;
//branch_flag    -> declared in con local variables
//branch_select_flag -> declared in con local variables
//alu_zero_flag  -> declared in alu local variables
//jump_flag  -> declared in con local variables
//fetched_instr -> declared in im local variables
logic [15:0] next_instr_address;

// Take this cycle's address (calculated in previous cycle) from the PC Register and pass into instruction memory and pc inputs.
assign current_instr_address = pc_reg;

// Instantiate program counter
ProgramCounter pc (
    .clock(clock),               //input
    .pc_current(current_instr_address),          //input
    .flag_branch(branch_flag),         //input
    .flag_branch_select(branch_select_flag),  //input
    .aluZero(alu_zero_flag),             //input
    .flag_jump(jump_flag),           //input
    .fullInstr(fetched_instr),           //input
    .pc_next(next_instr_address)              //output
);

// im local variables 
//addr -> use current_instr_address from pc register
logic [15:0] fetched_instr = 'h0000;    // assign NOP for first instruction
// Instantiate the instruction memory
instruction_memory im (
    .addr(current_instr_address),    //input
    .outWord(fetched_instr)  //output
);

// rf local variables
logic [15:0] data_to_write;         // result of memToReg mux which will be implemented in the main module
logic reg_write_flag;
//[3:0] reg1_idx  -> use fetched_instr[11:8]
//[3:0] reg2_idx -> use fetched_instr[7:4]
logic [15:0] reg1_contents;
logic [15:0] reg2_contents;
// Instantiate the register file
register rf (
    .clk(clock),             //input
    .incomingData(data_to_write),    //input
    .reg_write(reg_write_flag),       //input
    .reg1_idx(fetched_instr[11:8]),        //input
    .reg2_idx(fetched_instr[7:4]),        //input
    .reg1_contents(reg1_contents),   //output
    .reg2_contents(reg2_contents)    //output
);

// con local variables
//logic [3:0] opcode;   -> will use fethced_instr[15:12]
logic control_reset;
logic jump_flag;
logic branch_flag;
logic branch_select_flag;
logic mem_read_flag;
logic mem_to_reg_flag;
logic [1:0] alu_op;
logic mem_write_flag;
logic aluSrc;
logic reg_write_flag;
// Instantiate the control unit
control con (
    .opcode(fetched_instr[15:12]),          //input
    .control_reset(control_reset),   //input
    .jump(jump_flag),            //output
    .branch(branch_flag),          //output
    .branch_select(branch_select_flag),   //output       
    .mem_read(mem_read_flag),        //output
    .mem_to_reg(mem_to_reg_flag),      //output
    .alu_op(alu_op),          //output
    .mem_write(mem_write_flag),       //output
    .aluSrc(aluSrc),          //output
    .reg_write(reg_write_flag)        //output
);

// alu_con local variables
//alu_op -> declared in con local variables
//func -> will use fetched_instr[3:0]
logic [3:0] alu_control_out;
// Instantiate the ALU control unit
alu_control alu_con (
    .alu_op(alu_op),          //input
    .func(fetched_instr[3:0]),            //input
    .alu_control_var(alu_control_out)  //output
);

// alu local variables
// reg1_contents -> declared in rf local variables
// reg2_contents -> declared in rf local variables
// fetched_instr -> declared in pc local variabels
// aluSrc -> declared in con local variables
// alu_control_out -> declared in alu_con local variabels
logic [15:0] alu_result;    // result from alu operation
logic alu_zero_flag;
// Instantiate the alu
alu alu (
    .input1(reg1_contents),          //input
    .input2(reg2_contents),          //input
    .fullInstr(fetched_instr),       //input
    .flag_aluSrc(aluSrc),     //input
    .alu_control_out(alu_control_out), //input
    .result(alu_result),          //output
    .zero_flag(alu_zero_flag)        //output
);

// dm local variables
//reg1_contents (ONLY used for SW and always contents read from register 1 - rt/rd) 
//alu_result -> declared in alu local variables (address will always be calculated by alu)
// mem_read_flag -> declared in con local variables
// mem_write_flag -> declared in con local variabels
logic [15:0] data_memory_output;    // should only ever be meaningful from LW instruction
// Instantiate the data memory
data_memory dm(
    .clock(clock),              //input
    .inWord(reg1_contents),          //input
    .addr(alu_result),            //input
    .read_flag(mem_read_flag),       //input
    .write_flag(mem_write_flag),      //input
    .outWord(data_memory_output)          //output
);

// memToReg MUX - selects either the alu result (R-type, addi) or data memory unit output (lw)
assign data_to_write = (mem_to_reg_flag) ? data_memory_output : alu_result;

// Assign rd output to either:
//      - the output of the memToReg MUX since that is the data that will be written to reg1 on the next posedge.
//      OR
//      - 0 if we are writing to r0 for some unexplicable reason (reg module will not write anything to r0).
// 
// (We need this logic because in the case of writing to r0, rd output would be the alu_result. Although reg will
//  catch this and not write to r0, we are treating the rd output as the contents of rd even though we haven't technically
//  written to rd at this point.)
assign rd = (reg_write_flag && (fetched_instr[11:8] != 4'b0000)) ? data_to_write : 16'h0000;

// If we are not writing back to registers (such as SW, BEQ, BNE) set rd output to show the data stored in the destination register
// (need to show rd contents on the Basys board for every instruction except for jump)
assign rd = (~reg_write_flag) ? reg1_contents : rd;

// Assign current pc memory address to curent_pc output for debugging purposes
assign current_pc = current_instr_address;

// Assign fetched instruction to current_instr output for debugging purposes
assign current_instr = fetched_instr;

// Use non-blocking assignment to assign pc output to the pc_reg on the NEXT positive clock edge. Always "lagging" 1 cycle behind the clock.
// In the NEXT cycle, instruction memory combinational logic will run once pc_reg is updated with the NEXT cycle's instruction address.
// PC combinational logic will run the first time when pc_reg is updated, a second time when instruction memory fetches the current instruction,
// and finally a third and last time (in this cycle) when the control unit is able to get the fetched instruction's opcode and produces the flags
// the pc needs for all its inputs to be updated for this cycle and compute a meaningful "next instruction" for the next cycle.
always @(posedge clock) begin
    pc_reg <= next_instr_address;
end



endmodule
