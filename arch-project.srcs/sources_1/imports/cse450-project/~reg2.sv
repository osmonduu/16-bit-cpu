`define WRITE 1
`define READ 0

module register
(   input reg [15:0] incomingData,
    input int index, accessType,
    input logic clk,
    output logic [15:0] outgoingData
    );

// outgoing data on write will just be the data given
reg [15:0] registers [15:0];

always@(posedge clk) begin
    
    if (accessType == `WRITE) begin
        outgoingData = incomingData;
        registers[index] = incomingData; // writes the new data to the indexed register
    end  else if (accessType == `READ) 
        outgoingData = registers[index];
    else begin
        outgoingData = 'h0x0; // null on invalid access type 
        $display("Invalid register access type");
    end

end


endmodule