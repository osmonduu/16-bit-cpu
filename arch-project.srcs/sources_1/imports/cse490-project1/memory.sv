`include "defines.sv"
// `define dbg

module memory(
    input reg clock, // read or write
    input reg [15:0] inWord, // word to write
    input int addr, optype, // memory address to access
    output reg [15:0] outWord // read word
);

    reg [7:0] memoryArray [127:0]; // array containing the ROM and data memory
    `ifdef dbg
    reg [7:0] temp1;
    reg [7:0] temp2;
    `endif

    always@(posedge clock) begin
        $readmemb("memory.mem", memoryArray, 0, 127); // initialize memory into array

        if (optype == `READ) begin
          `ifdef dbg
          $display("[debug:memory] operation is READ, time=%1d", $time);
          `endif
          outWord[7:0]  <= memoryArray[addr]; // don't need to validate reading, read lower word
          outWord[15:8] <= memoryArray[addr+1];
          `ifdef dbg
            $strobe("[debug:memory] outWord = %4h", outWord);
          `endif
        end 
        
        if (optype == `WRITE) begin
            // ASSUMING WRITE
            $display("[debug:memory] operation is WRITE");
            // it makes sense to nest here
            if (addr > 'h3F) begin // write operations are only valid from 0x40 to 0x7F, 0x0 to 0x3F are read-only
              memoryArray[addr] = inWord[7:0];
              memoryArray[addr+1] = inWord[15:8]; // write upper word
              `ifdef dbg

              temp1 = memoryArray[addr];
              temp2 = memoryArray[addr+1];
              $display("[debug:memory] addr=0x%2h, addr+1=0x%2h, temp1=0x%2h, temp2=0x%2h", addr, addr+1, temp1, temp2);
              `endif
              $writememb("memory.mem", memoryArray, 0, 127); // can only write entire contents of memory, not individual bytes
              // return input word as output
              outWord = inWord;
            end else begin
              // if addr is not more than 0x3F then we're trying to write to
              // read-only memory, return null vector
              outWord = 16'h0; 
            end

        end

    end



endmodule
