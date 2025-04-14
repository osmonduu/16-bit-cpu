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
    16'h0001,   // r1
    16'h0002,   // r2
    16'h0003,   // r3
    16'h0004,   // r4
    16'h0005,   // r5
    16'h0006,   // r6
    16'h0007,   // r7
    16'h0008,   // r8
    16'h0009,   // r9
    16'h000A,   // r10
    16'h000B,   // r11
    16'h000C,   // r12
    16'h000D,   // r13
    16'h000E,   // r14
    16'h000F,   // r15
    16'h0000    // r16 = PC (can default to 0)
};

always_comb begin
    reg1_contents = registers[reg1_idx];
    reg2_contents = registers[reg2_idx];
end 

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
