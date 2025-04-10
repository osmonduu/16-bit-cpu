`timescale 1ns/1ps

/*
* ALU CONTROL UNIT OUTPUT TO ALU *
----------------------------------
add: 010
sub: 110
sll: 011
and: 000


* ALUOP FROM CONTROL UNIT TO ALU CONTROL UNIT *
----------------------------------------------
add  (R): 10
sub  (R): 10
sll  (R): 10
and  (R): 10
lw   (I): 00
sw   (I): 00
addi (I): 00
beq  (I): 01
bne  (I): 01
jmp  (J): X


* ALU CONTROL UNIT {ALUOP + FUNCT} -> ALU CONTROL UNIT OUTPUT *
---------------------------------------------------------------
(add)   10 0000 -> 010 -> alu_ADD
(sub)   10 0001 -> 110 -> alu_SUB
(sll)   10 0010 -> 011 -> alu_SLL
(and)   10 0011 -> 000 -> alu_AND
(lw)    00 xxxx -> 010 -> alu_ADD
(sw)    00 xxxx -> 010 -> alu_ADD
(addi)  00 xxxx -> 010 -> alu_ADD
(beq)   01 xxxx -> 110 -> alu_SUB
(bne)   01 xxxx -> 110 -> alu_SUB
(jmp)   xx xxxx -> xxx -> xxxxxxx
*/

// ALU Control Module
module alu_control(
    input  logic [1:0] alu_op,
    input  logic [3:0] func,
    output logic [2:0] alu_control_var
);
    logic [5:0] alu_control_inp;
    assign alu_control_inp = {alu_op, func};
    always_comb begin
        casez (alu_control_inp)
          	
            //ALU CONTROL UNIT OUTPUT TO ALU
            6'b100000: alu_control_var = 3'b010; //add
            6'b100001: alu_control_var = 3'b110; //sub
            6'b100010: alu_control_var = 3'b011; //sll
            6'b100011: alu_control_var = 3'b000; //and
          
            //Not used 
          
          	// I-type instructions (lw, sw, addi) with alu_op = 00:
            6'b00????: alu_control_var = 3'b010; // ADD

            // I-type branch instructions (beq, bne) with alu_op = 01:
            6'b01????: alu_control_var = 3'b110; // SUB
			
            // Jump
            default:   alu_control_var = 3'b000;
        endcase
    end
endmodule
