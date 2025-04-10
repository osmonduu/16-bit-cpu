// ALU LOGIC - does not use any of the modules above and works as a standalone ALU implementation
module alu (
  input  logic [15:0] input1,			// 16-bit content read from register 1
  input  logic [15:0] input2,			// 16-bit content read from register 2 
  input  logic [15:0] shift,			// 16-bit sign-extended immediate 
  input  logic [2:0]  alu_control_out,	// ALU Control Unit output to specify which ALU operation to perform
  output logic [15:0] result,			// result of the alu operation on the two inputs
  output logic        zero_flag			// zero_flag is 1 whenever the result is equal to 0. Otherise, zero_flag is 0.
);
  
  always_comb begin
    case (alu_control_out)
      3'b010: result = input1 + input2;	// ADD
      3'b110: result = input1 - input2; // SUB
      3'b011: result = input2 << shift;	// SLL
      3'b000: result = input1 & input2; // AND
      default: result = 16'h0000;
    endcase
  end
  
  // Zero flag logic
  assign zero_flag = (result == 16'h0000);
      
endmodule