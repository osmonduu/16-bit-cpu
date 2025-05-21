`include "defines.sv"

module register (
    input logic clk,                        // clock
    input logic [15:0] incomingData,          // data to write back to register (only used when reg_write is 1 and on negedge)
    input logic reg_write,                  // control flag that tells the register file to write back to rt/rd
    input logic [3:0] reg1_idx, reg2_idx,   // indices for register 1 (rt/rd) and register 2 (rs)
//    input int accessType,
    output logic [15:0] reg1_contents, reg2_contents    // data that was read from the registers
);

// outgoing data on write will just be the data given
// initialize 16-bit registers, 17 of them
logic [15:0] registers [0:16] = '{
    16'h0000,   // r0
    16'h0000,   // r1
    16'h0000,   // r2
    16'h0000,   // r3
    16'h0000,   // r4
    16'h0000,   // r5
    16'h0000,   // r6
    16'h0000,   // r7
    16'h0000,   // r8
    16'h0000,   // r9
    16'h0000,   // r10
    16'h0000,   // r11
    16'h0000,   // r12
    16'h0000,   // r13
    16'h0000,   // r14
    16'h0000,   // r15
    16'h0000    // r16 = PC (can default to 0)
};

always_comb begin
    reg1_contents = registers[reg1_idx];
    reg2_contents = registers[reg2_idx];
end 

// Don't use negedge because then we will run the alu again. It won't write anything but the value in reg1 will update, causing the
// local variable in cpu module (reg1_contents) to update, causing a chain reaction of combinational logic which causes another 
// instance of the instruction to run but with the written reg1 contents. The memToReg MUX result will then be different from the 
// negedge to the next cycle posedge. 
// It won't write it though because then a new instruction will be ran and that new instruction's write will occur,
// essentially overwriting the false data_write. 
// Because of the way we are extracing rd_after in cpu module, we need this to be posedge so that the data will be written to the
// register on the posedge of the next cycle. 
always @(posedge clk) begin
    if (reg_write) begin
        if (reg1_idx == 0) begin
            // keep register 0 always 0
            // so don't write anything
        end
        else begin
            registers[reg1_idx] = incomingData;
        end
    end
end

endmodule

//always_comb begin
//    if (accessType == `WRITE) begin

//        registers[index] = incomingData; // writes the new data to the indexed register
//        outgoingData = registers[index];

//    end  else if (accessType == `READ) 

//        outgoingData = registers[index];

//    else begin

//        outgoingData = 'h0000; // null on invalid access type 
//    end
//end
