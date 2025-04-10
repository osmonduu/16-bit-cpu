`include "defines.sv"

module memtest;


    parameter N = 16;

    reg [N-1:0] op_1 = 'hBEEF; // stands for operand 1 and 2 repsectively
    reg [N-1:0] op_2 = 'h0000; // default to null

    logic [N-1:0] result; // result of the tested operation


    int idx = 3; // index value
    logic clock = 0; // clock
    int optype = `WRITE; // type of operation
    int addr = 'h5C;

    memory mem(
      
      .clock(clock),
      .inWord(op_1),
      .outWord(result),
      .addr(addr),
      .optype(optype)
    );

    initial begin

        $dumpfile("memtest.vcd");
        $dumpvars(); // dumpvars          
        $display("var1 = %0h, var2 = %0h", 'h3F, 'h0x3F);

        #24 $finish();
    end   


    always begin
      optype = `WRITE;
      // initially writes  at address 0x5C 
      #1 clock = 1;
      #1 clock = 0;
      // change address to some other index that should be null, write DEAD
      // into it
      addr = 8'h50; // still in data memory
      op_1 = 16'hDEAD; // write DEAD
      // do posedge
      #1 clock = 1;
      #1 clock = 0;
      // memory has been written, go back to location 1 and read it
      addr = 8'h5C; 
      optype = `READ;
      // op_1 won't do anything
      #1 clock = 1;
      #1 clock = 0;
      // now read the other memory address
      addr = 8'h50;
      #1 clock = 1;
      #1 clock = 0;
      // test byte access
      optype = `WRITE;
      op_1 = 8'hAB;
      addr = 70;
      // write one byte to addr 70
      #1 clock = 1;
      #1 clock = 0;
      // test addr+1
      addr += 1;
      op_1 = 8'hCD;
      #1 clock = 1;
      #1 clock = 0;
      // now read what is in addr - should be an entire word like 0xCDAB
      addr = 70;
      optype = `READ;
      // check what result is
      #1 clock = 1;
      #1 clock = 0;
      // reset
      optype = `WRITE;
      op_1 = 16'hBEEF;
      addr = 8'h5C;

    end

  
endmodule
