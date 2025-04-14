`include "defines.sv"

module register (
    input reg [15:0] incomingData,
    input int index,
    input reg clock, write_flag,
    output logic [15:0] outgoingData
);

// outgoing data on write will just be the data given
reg [15:0] registers [17] = '{default: 'h0}; // 17 registers, r16 is pc

always@(negedge clock) begin // write block
    if (write_flag == 1) begin

        outgoingData = incomingData;
        registers[index] = incomingData; // writes the new data to the indexed register
    end 
end

always@(index) begin // read block
    if (write_flag == 0) begin
        outgoingData = registers[index];
   end
//    $writememh("regs.mem", registers, 0, 16);
end

endmodule
