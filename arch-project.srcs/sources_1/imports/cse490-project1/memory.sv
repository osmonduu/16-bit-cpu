`include "defines.sv"


module data_memory(
    input reg [15:0] inWord, // word to write
    input reg clock,
    input int addr, // memory address to access
    logic read_flag,
    logic write_flag,
    output reg [15:0] outWord // read word
);

    reg [7:0] data_mem [64:127] = '{ default: 'h0 };
    
    always_comb begin // read block
    `ifdef dbg
        $display("[debug:dmem] BEEP!");
    `endif
//        $readmemh("memory.mem", memoryArray, 0, 127); // initialize memory into array
    if ((read_flag == 1) && (write_flag == 0))
        begin
    
          outWord[7:0]  = data_mem[addr+1]; // don't need to validate reading, read lower word
          outWord[15:8] = data_mem[addr];
          `ifdef dbg
            $display("[debug:dmem] outWord = %4h, address = %2h", outWord, addr);
          `endif
        end    
   end
      
    always@(negedge clock) begin  
        if (write_flag == 1 && read_flag == 0) begin


              data_mem[addr] = inWord[7:0];
              data_mem[addr+1] = inWord[15:8]; // write upper word

              $writememh("memory.mem", data_mem, 64, 127); // can only write entire contents of memory, not individual bytes
              // return input word as output
              outWord = inWord;
        end
      end
        
endmodule


module instruction_memory(
    input int addr,  // memory address to access
    output reg [15:0] outWord // read word
);

    reg [7:0] instruction_mem [0:63] =  '{ 'h00, 'h00, 'h01, 'h20, 'h30, 'h35, 'h60, 'h05, 'h31, 'h40, 'h00, 'h21, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00, 'h00 };

    `ifdef dbg
    reg [7:0] temp1 ='h0;
    reg [7:0] temp2 ='h0;
    `endif

    always_comb begin // read block, only execute on change in addr
//        $readmemh("memory.mem", memoryArray, 0, 127); // initialize memory into array
//        $stop();
        
          `ifdef dbg
            $display("[debug:imem] accessing address: $2h, time=%1d", addr, $time);
            temp1 = instruction_mem[addr];
            temp2 = instruction_mem[addr+1];
          `endif
          
          outWord[7:0]  = instruction_mem[addr+1]; // don't need to validate reading, read lower word
          outWord[15:8] = instruction_mem[addr];

    end


endmodule
