// IMPORTANT: read section 5.4.3 – Detailed Instruction Information
// ALU LOGIC - does not use any of the modules above and works as a standalone ALU implementation
module alu (
  input  logic [15:0] input1,			// 16-bit contents read from register 1
  input  logic [15:0] input2,			// 16-bit contents read from register 2 
  input  logic [15:0] fullInstr,		// 16-bit decoded instruction from instruction memory instruction
  input  logic        flag_aluSrc,		// aluSrc flag from control unit
  input  logic [2:0]  alu_control_out,	// ALU Control Unit output to specify which ALU operation to perform
  output logic [15:0] result,			// result of the alu operation on the two inputs
  output logic        zero_flag			// zero_flag is 1 whenever the result is equal to 0 Otherise, zero_flag is 0.
);
  
  // adderFirstOperand can either be input1 or signExtImm
  logic signed [15:0] adderFirstOperand;
  logic signed [15:0] signExtImm;

  // Sign extend 4-bit immediate
  assign signExtImm = {{12{fullInstr[3]}}, fullInstr[3:0]};

  // If flag_aluSrc is 1, use sign extended immediate in adder. If 0, use input1 in adder. 
  // Input 2 will be the second operand in both cases.
  // input1 is used in the adder with ADD instructions 
  // signExtImm is used in the adder with ADDI, LW, SW instructions
  assign adderFirstOperand = (flag_aluSrc) ? signExtImm : input1;
  
  // Update result as soon as the inputs change
  always_comb begin
    case (alu_control_out)
      3'b010: result = adderFirstOperand + input2;				// ADD
      3'b110: result = $signed(input1) - $signed(input2); 		// SUB
      3'b011: result = $unsigned(input1) << $unsigned(input2);	// SLL
      3'b000: result = input1 & input2; 						// AND
      default: result = 16'h0000;
    endcase
  end
  
  // Zero flag logic
  assign zero_flag = (result == 16'h0000);
      
endmodule


/*

module and
#(parameter N)
(input logic [N-1:0] a, b, input logic clk, output logic [N-1:0] c);
    always@(posedge clk) begin
        c = a & b;
    end
endmodule

// generate a ton of full-adders to make a N bit ripple-carry
module adder 
#(parameter N)
(input logic [N-1:0] num_1, num_2, output logic [N-1:0] sum );

    logic init_carry, discarded_carry; // discarded carry is intentionally not an output, that value will get discarded
    assign init_carry = 0;
    logic [N-1:1] carries;

    genvar i;
    generate // i'll validate that this generate works later
        for (i = 0; i < N; i++0) begin
            if (i == 0) begin
                fadder f0 (.a(num_1[i]), .b(num_2[i]), .c_in(init_carry), .sum(sum[i]), .c_out(carries[i]) );
            end
            else if (i == N-1) begin
                fadder fN (.a(num_1[i]), .b(num_2[i]), .c_in(carries[i-1]), .sum(sum[i]), .c_out(discarded_carry) );
            end 
            else begin
                fadder fi (.a(num_1[i]), .b(num_2[i]), .c_in(carries[i-1]), .sum(sum[i]), .c_out(carries[i]));
            end
        end
    endgenerate

endmodule

module fadder(input logic a, b, c_in, clk, output logic sum, carry_out);

    always@(posedge clk) begin
    // simple fulladder implementation
        c_out = (a & b) | c_in & (a ^ b);
        sum = a ^ b ^ c_in;
    end
endmodule

// Not really needed anymore - does it inside pc.sv and alu.sv instead.
module sign_extension (
  input logic [3:0] immediate,	// bits 3:0 of I-type instruction representing the 4-bit immediate
  output logic [15:0] extended	// 16-bit sign-extended immediate value
  );
  
  // Sign-extend based on the the MSB of immediate (4th bit)
  assign extended = {{12{immediate[3]}}, immediate};
  
endmodule

*/

