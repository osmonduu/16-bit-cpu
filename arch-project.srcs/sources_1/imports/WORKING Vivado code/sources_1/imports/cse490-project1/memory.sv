`include "defines.sv"


module data_memory(
    input logic clock,
    input reg [15:0] inWord, // word to write
    input int addr, // memory address to access
    input logic read_flag,
    input logic write_flag,
    output reg [15:0] outWord // read word
);

    reg [7:0] data_mem [0:63] = '{ default: 'h00 };
    always_comb begin
//        $readmemh("memory.mem", memoryArray, 0, 127); // initialize memory into array
//        $stop();

        if (read_flag == 1) begin
    
          outWord[7:0]  = data_mem[addr+1]; // don't need to validate reading, read lower word
          outWord[15:8] = data_mem[addr];
          `ifdef dbg
            $display("[debug:memory] outWord = %4h", outWord);
          `endif
        end   
        
    end 
    
    always @(posedge clock) begin
        if (write_flag == 1) begin
    
                   data_mem[addr] = inWord[15:8]; // write upper word on addr
                  data_mem[addr+1] = inWord[7:0]; // write lower word on addr+1
    
//                  $writememh("memory.mem", data_mem, 0, 63); // can only write entire contents of memory, not individual bytes
                  // return input word as output
                  outWord = inWord;
        end
        if ( (read_flag ^~ write_flag) == 1) begin
                outWord = 'hZZZZ; // return sometihng stupid
        end 
    end
        
        
        

endmodule


module instruction_memory(
    input int addr,  // memory address to access
    output wire [15:0] outWord // read word
);

    reg [7:0] instruction_mem [0:63] =  '{
        'h00, 'h00, 
        'h01, 'h20, 
        'h34, 'h35, 
        'h60, 'h01, 
        'h01, 'h20, 
        'h01, 'h00, 
        'h05, 'h61, 
        'h01, 'h22, 
        'h36, 'h47, 
        'h05, 'h63, 
        'h3d, 'hd1, 
        'h48, 'hc3, 
        'h21, 'h02, 
        'h18, 'h02, 
        'h58, 'h4b, 
        'h0d, 'h00, 
        'h00, 'h00, 
        'h00, 'h00, 
        'h00, 'h00, 
        'h00, 'h00, 
        'h00, 'h00, 
        'h00, 'h00, 
        'h00, 'h00, 
        'h00, 'h00, 
        'h00, 'h00, 
        'h00, 'h00, 
        'h00, 'h00, 
        'h00, 'h00, 
        'h00, 'h00, 
        'h00, 'h00, 
        'h00, 'h00, 
        'h00, 'h00
     };
          
    assign outWord[7:0]  = instruction_mem[addr+1]; // don't need to validate reading, read lower word
    assign outWord[15:8] = instruction_mem[addr];


endmodule
