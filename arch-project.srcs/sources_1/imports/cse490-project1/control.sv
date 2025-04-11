//`timescale 1ns/1ps


module control (
   input  logic [3:0] opcode,
   input  logic       clock,
   input  logic       control_reset,
   output logic [1:0] reg_dest,
   output logic [1:0] mem_reg,
   output logic [1:0] alu_op,
   output logic       jump,
   output logic       branch,
   output logic       branch_select, // New signal to differentiate BEQ vs. BNE
   output logic       mem_read,
   output logic       mem_write,
   output logic       alu_mux,       // ALUSrc
   output logic       reg_write,
   output logic       sign_extd
);


   always_ff @(posedge clock) begin
       if (control_reset) begin
           // Set control signals to default values
           reg_dest      <= 2'b00;
           mem_reg       <= 2'b00;
           alu_op        <= 2'b00;
           jump          <= 1'b0;
           branch        <= 1'b0;
           branch_select <= 1'b0; 
           mem_read      <= 1'b0;
           mem_write     <= 1'b0;
           alu_mux       <= 1'b0;
           reg_write     <= 1'b0;
           sign_extd     <= 1'b1;
       end
       else begin
           // Default values assigned before opcode decoding
           reg_dest      <= 2'b00;
           mem_reg       <= 2'b00;
           alu_op        <= 2'b00;
           jump          <= 1'b0;
           branch        <= 1'b0;
           branch_select <= 1'b0; 
           mem_read      <= 1'b0;
           mem_write     <= 1'b0;
           alu_mux       <= 1'b0;
           reg_write     <= 1'b0;
           sign_extd     <= 1'b1;
          
           case (opcode)
               // R-type (opcode = 0000: add, sub, sll, and, etc.)
               4'b0000: begin
                   reg_dest  <= 2'b01;   // Destination is Rd
                   alu_op    <= 2'b10;   // R-type => 10
                   alu_mux   <= 1'b0;    // ALU operand from register
                   reg_write <= 1'b1;    // Enable write to register
               end

               // lw (opcode = 0001)
               4'b0001: begin
                   reg_dest  <= 2'b00;   // Destination is Rt
                   alu_op    <= 2'b00;   // Add for address calc
                   alu_mux   <= 1'b1;    // Use immediate as second operand
                   mem_read  <= 1'b1;    // Enable memory read
                   reg_write <= 1'b1;    // Write loaded data to register
               end

               // sw (opcode = 0010)
               4'b0010: begin
                   alu_op    <= 2'b00;   // Add for address calc
                   alu_mux   <= 1'b1;    // Use immediate as second operand
                   mem_write <= 1'b1;    // Enable memory write
               end

               // addi (opcode = 0011)
               4'b0011: begin
                   reg_dest  <= 2'b00;   // Destination is Rt
                   alu_op    <= 2'b00;   // Add immediate
                   alu_mux   <= 1'b1;    // Use immediate
                   reg_write <= 1'b1;    // Write result to register
               end

               // beq (opcode = 0100)
               4'b0100: begin
                   alu_op    <= 2'b01;   // Sub for comparison
                   branch    <= 1'b1;    // We are branching
                   branch_select <= 1'b0; // 0 => BEQ path (branch if Zero == 1)
                   alu_mux   <= 1'b0;    // Second operand from register
               end

               // bne (opcode = 0101)
               4'b0101: begin
                   alu_op    <= 2'b01;   // Sub for comparison
                   branch    <= 1'b1;    // We are branching
                   branch_select <= 1'b1; // 1 => BNE path (branch if Zero == 0)
                   alu_mux   <= 1'b0;    // Second operand from register
               end

               // jump (opcode = 0110)
               4'b0110: begin
                   jump <= 1'b1;        
                  
               end
               default: begin
               end
           endcase
          
       end
   end
endmodule

