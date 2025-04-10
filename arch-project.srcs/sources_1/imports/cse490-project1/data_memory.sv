
// There was a memory.sv but not sure if its for instruction or data so heres a new one (you can move this if you wanna)
// check the flow for data mem (lmk if seems good)
// should only work for lw/sw


module data_memory (
    input logic clock_cycle,
    input logic [15:0] mem_addr, 
    input logic [15:0] mem_write_data,
    output logic [15:0] mem_read_data, 
    input logic mem_write, 
    input logic mem_read
);

    logic [15:0] cache [0:255];
    logic [7:0] cache_addr;

    assign cache_addr = mem_addr[8:1];

    initial begin
        foreach (cache[i])
            cache[i] = 16'd0;
    end

    always_ff @(posedge clock_cycle) begin
        if (mem_write) begin
            cache[cache_addr] <= mem_write_data;
        end
    end

    always_comb begin
        if (mem_read)
            mem_read_data = cache[cache_addr];
        else
            mem_read_data = 16'd0;
    end

endmodule
