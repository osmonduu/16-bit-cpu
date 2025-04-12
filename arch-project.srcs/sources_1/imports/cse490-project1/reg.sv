`include "defines.sv"

module register (
    input reg [15:0] incomingData,
    input int index, accessType,
    input logic clk,
    output wire [15:0] outgoingData
);

// outgoing data on write will just be the data given
wire [15:0] registers [17] = '{default: 'h0}; // 17 registers, r16 is pc


    if (accessType == `WRITE) begin

        assign registers[index] = incomingData; // writes the new data to the indexed register
        assign outgoingData = registers[index];

    end  else if (accessType == `READ) 

        assign outgoingData = registers[index];

    else begin

        assign outgoingData = 'h0000; // null on invalid access type 
    end


endmodule
