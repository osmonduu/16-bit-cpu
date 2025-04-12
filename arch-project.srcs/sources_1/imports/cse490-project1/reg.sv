`include "defines.sv"

module register (
    input reg [15:0] incomingData,
    input int index, accessType,
    input logic clk,
    output logic [15:0] outgoingData
);

// outgoing data on write will just be the data given
reg [15:0] registers [17] = '{default: 'h0}; // 17 registers, r16 is pc

always_comb begin
    if (accessType == `WRITE) begin

        registers[index] = incomingData; // writes the new data to the indexed register
        outgoingData = registers[index];

    end  else if (accessType == `READ) 

        outgoingData = registers[index];

    else begin

        outgoingData = 'h0000; // null on invalid access type 
        $display("Invalid register access type");

    end
//    $writememh("regs.mem", registers, 0, 16);
end

endmodule
