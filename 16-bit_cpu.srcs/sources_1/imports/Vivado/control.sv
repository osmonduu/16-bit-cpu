

module control (
  input  logic [3:0] opcode,
  input  logic       control_reset,	// Reset all outputs to 0 regardless of opcode
  output logic       jump,			// 1 when jump, 0 otherwise
  output logic       branch,		// 1 when branch, 0 otherwise
  output logic       branch_select, // New signal to differentiate BEQ vs. BNE. 1 to select BEQ logic, 0 to select BNE logic.
  output logic       mem_read,		// 1 when LW, 0 otherwise
  output logic 		 mem_to_reg,	// 1 when LW or SW, 0 otherwise
  output logic [1:0] alu_op,		// R-type -> 10, I-type (non-branch) -> 00, I-type (branch) -> 01. Sent to ALU Control Unit.
  output logic       mem_write,		// 1 when SW, 0 otherwise
  output logic       aluSrc,       	// 1 when ADD (uses input1), 0 when LW/SW/ADDI (uses immediate value)
  output logic       reg_write		// 1 when R-type/LW/ADDI
);
  

  always_comb begin
    if (control_reset) begin
      // Set control signals to default values
      mem_to_reg    = 1'b0;
      alu_op        = 2'b00;
      jump          = 1'b0;
      branch        = 1'b0;
      branch_select = 1'b0; 
      mem_read      = 1'b0;
      mem_write     = 1'b0;
      aluSrc		= 1'b0;
      reg_write     = 1'b0;
    end
    else begin
      // Default values assigned before opcode decoding
      mem_to_reg	= 1'b0;
      alu_op       	= 2'b00;
      jump         	= 1'b0;
      branch       	= 1'b0;
      branch_select	= 1'b0; 
      mem_read     	= 1'b0;
      mem_write    	= 1'b0;
      aluSrc       	= 1'b0;
      reg_write    	= 1'b0;

      case (opcode)
        // R-type (opcode = 0000: add, sub, sll, and, etc.)
        4'b0000: begin
          alu_op		= 2'b10;   // R-type => 10
          aluSrc		= 1'b0;    // ALU operand from register - use input1
          reg_write		= 1'b1;    // Enable write to register - write to rt/rd
        end

        // lw (opcode = 0001)
        4'b0001: begin
          alu_op		= 2'b00;	// I-type (non branch) => 00
          aluSrc		= 1'b1;		// Use immediate as second ALU operand
          mem_read		= 1'b1;		// Enable memory read
          reg_write		= 1'b1;		// Write loaded data to register
          mem_to_reg	= 1'b1;		// Choose memory unit output to write back
        end

        // sw (opcode = 0010)
        4'b0010: begin
          alu_op		= 2'b00;	// I-type (non branch) => 00
          aluSrc		= 1'b1;		// Use immediate as second ALU operand
          mem_write	= 1'b1;			// Enable memory write
        end

        // addi (opcode = 0011)
        4'b0011: begin
          alu_op	= 2'b00;   // I-type (non branch) => 00
          aluSrc	= 1'b1;    // Use immediate as second ALU operand
          reg_write	= 1'b1;    // Write result to register
        end

        // beq (opcode = 0100)
        4'b0100: begin
          alu_op		= 2'b01;	// I-type (branch) => 01
          branch		= 1'b1;		// Branch instruction
          branch_select	= 1'b0;		// 0 => BEQ path (branch if Zero == 1)
          aluSrc		= 1'b0;		// ALU operand from register - use input1
        end

        // bne (opcode = 0101)
        4'b0101: begin
          alu_op		= 2'b01;	// I-type (branch) => 01
          branch		= 1'b1;		// Branch instruction
          branch_select	= 1'b1; 	// 1 => BNE path (branch if Zero == 0)
          aluSrc		= 1'b0;		// ALU operand from register - use input1
        end

        // jump (opcode = 0110)
        4'b0110: begin
          jump = 1'b1;	// Jump instruction                   
        end
        default: begin
          // Do nothing
        end
      endcase

    end	// end of else statement
  end	// end of always_comb
endmodule

