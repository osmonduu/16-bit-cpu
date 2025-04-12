`include "defines.sv"


module data_memory(
    input reg [15:0] inWord, // word to write
    input int addr, // memory address to access
    logic read_flag,
    logic write_flag,
    output reg [15:0] outWord // read word
);

    reg [7:0] data_mem [64:127] = '{ default: 'h0 };
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
        
        if (write_flag == 1) begin


              data_mem[addr] = inWord[7:0];
              data_mem[addr+1] = inWord[15:8]; // write upper word

              $writememh("memory.mem", data_mem, 64, 127); // can only write entire contents of memory, not individual bytes
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

    reg [7:0] instruction_mem [0:63] =  '{ 'h01, 'h20, 'h30, 'h35, 'h60, 'h05, 'h31, 'h40, 'h00, 'h21, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00 };
          
    assign outWord[7:0]  = instruction_mem[addr+1]; // don't need to validate reading, read lower word
    assign outWord[15:8] = instruction_mem[addr];


endmodule
