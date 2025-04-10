
module ProgramCounter(
  input logic clock,				            // input clock 
  input logic [15:0] pc_current,	      // previous pc, needs to be incremented by 2
  input logic [15:0] branchOff,  // sign-extended and left shifted 1 bit branch offset
  input logic flag_branch,			        // branch flag from control unit
  input logic flag_branch_select,       // Extra control code to select between BNE or BEQ logic. If branch_select is 0, select BEQ logic. If 1, select BNE logic
  input logic aluZero,				          // zero output from ALU
  input logic [15:0] jumpInstr,		      // decoded instruction from instruction memory
  input logic flag_jump, 			          // jump flag from control unit
  output logic [15:0] pc_next		        // next address to send to the instruction memory on next clock cycle
);
  
  always @(posedge clock) begin
    // Increment pc to get next instruction address.
    logic [15:0] nextAddr;
    nextAddr = pc_current + 2;
    
    // Calculate the full branch address from the offset.
    reg [15:0] branchAddr = 0;
    branchAddr = nextAddr + branchOff;
    
    // Branch instruction MUX logic.
    logic beq_logic, bne_logic, branchMux, pcSrc; 
    beq_logic = flag_branch & aluZero;
    bne_logic = flag_branch & ~aluZero;
    branchMux = (flag_branch_select) ? bne_logic: beq_logic;  // If flag_branch_select is 1, select BNE logic. If 1, select BEQ logic.
    pcSrc = (branchMux) ? branchAddr : nextAddr;  // If branchMUX is 1, select branchAddr. If 0, select pc + 2.
    
    // Calculate full jump address
    logic [15:0] jumpAddr;
    jumpAddr = {nextAddr[15:12], (jumpInstr[11:0] << 1)};

    // Jump instruction MUX logic. If 1, select jumpAddr. If 0, select result from branch MUX.
    nextAddr = (flag_jump) ? jumpAddr : pcSrc;
    
    // Update the program counter output
    pc_next  = nextAddr;
  end
  
endmodule
