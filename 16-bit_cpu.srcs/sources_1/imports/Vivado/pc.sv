// IMPORTANT: read section 5.4.3 – Detailed Instruction Information
module ProgramCounter(
  input logic clock,				    // input clock - not really using anymore
  input int pc_current,	    // previous pc, needs to be incremented by 2
  input logic flag_branch,			    // branch flag from control unit
  input logic flag_branch_select,       // Extra control code to select between BNE or BEQ logic. If branch_select is 0, select BEQ logic. If 1, select BNE logic
  input logic aluZero,				    // zero output from ALU
  input logic flag_jump, 			    // jump flag from control unit
  input logic [15:0] fullInstr,		    // 16-bit decoded instruction from instruction memory Used for the branch offset and jump address calculations.
  output int pc_next		    // next address to send to the instruction memory on next clock cycle
);
  
  // Declare all variables outside of always block
  int nextAddr;
  int branchAddr;
  int signExtImm;
  logic beq_logic, bne_logic, branchMux;
  int pcSrc;
  int jumpAddr;
  
  // * A clocked pc will introduce a delay because it will want to run on posedge of the clock using the previous cycle fetched instruction.
  //   This would only be a problem when the previous instruction was a jump or taken branch instruction.
  //   That would invalidate this cycle's next address but still compute and write based on the instruction.
  //   THAT IS WHY THEY SAY TO PUT NOPs AFTER A BRANCH OR JUMP INSTRUCTION!!!!
  //   (we really only NEED a clocked pc if the datapath is pipelined where pc needs to run every posedge of the clock) 
    always_comb begin
    // Increment pc to get next instruction address.
    nextAddr = pc_current + 2;

    // Calculate the full branch address from the last 4-bits of instruction - 4-bit signed immediate. 
    signExtImm = {{12{fullInstr[3]}}, fullInstr[3:0]};	// sign extend 4-bit immediate
    branchAddr = nextAddr + (signExtImm << 1);	// (pc+2) + (sign-extended imm * 2) 
    
    // Branch instruction MUX logic.
    beq_logic = flag_branch & aluZero;
    bne_logic = flag_branch & ~aluZero;
    branchMux = (flag_branch_select) ? bne_logic : beq_logic;  // If flag_branch_select is 1, select BNE logic. If 0, select BEQ logic.
    pcSrc = (branchMux) ? branchAddr : nextAddr;  // If branchMUX is 1, select branchAddr. If 0, select pc + 2.
    
    // Calculate full jump address by adding pc+2 and (12-bit jump address * 2)
    // to make the 16-bit jump address
    jumpAddr = nextAddr + (fullInstr[11:0] << 1);

    // Jump instruction MUX logic. If 1, select jumpAddr. If 0, select result from branch MUX.
    // Update program counter ouput
    pc_next = (flag_jump) ? jumpAddr : pcSrc;

    
    // DEBUG - comment out if u dont want it
//    $display("[PC MODULE @ %0t] pc_current=%h, nextAddr=%h, fullInstr=%h, signExtImm=%h, branchAddr=%h, pcSrc = %h, jumpAddr=%h, flag_jump=%h, pc_next=%h",
//            $time, pc_current, nextAddr, fullInstr, signExtImm, branchAddr, pcSrc, jumpAddr, flag_jump, pc_next);
  end
  
endmodule