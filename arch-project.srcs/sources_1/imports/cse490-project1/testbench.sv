`timescale 1ns/1ns
`define WRITE 1
`define READ 0
`define REGTEST

// testbench to run everything, make sure that things make sense
module tb;
    parameter N = 16;
    reg [N-1:0] op_1 = 'hBEEF; // stands for operand 1 and 2 repsectively
    reg [N-1:0] op_2 = 'h0000; // default to null

    logic [N-1:0] result; // result of the tested operation


    int idx = 3; // index value
    logic clock = 0; // clock
    int optype = `WRITE; // type of operation
    int addr = 'h5C;


    register ra
    (
        .index(idx),
        .accessType(optype),
        .clk(clock),
        .incomingData(op_1),
        .outgoingData(result)
    );

    // memory mem(
    //
    //   .clock(clock),
    //   .inWord(op_1),
    //   .outWord(result),
    //   .addr(addr),
    //   .optype(optype)
    // );
    //

    initial begin

        $dumpfile("tb.vcd");
        $dumpvars(); // dumpvars   
        #24 $finish();
    end   

    // register testbench
    always begin
        
        #1  clock = 1; // posedge - no delay so this posedge should occur on tick 0
        #1  clock = 0; // nededge
        // now during 0 tick, change index and operation type
        optype = `WRITE; // write to index 4
        op_1 = 'hDEAD; // change op 1 to be something different
        idx = 4; // change index to be not 3
        // tick clock
        #1  clock = 1; // posedge
        // result should be equal to 0xDEAD right now
        #1  clock = 0; // nededge
        // now see what is in index 3
        optype = `READ;
        idx = 3;
        // result should be 0xBEEF right now, since that's what was stored
        #1  clock = 1;
        #1  clock = 0;
        op_1 = 'hBEEF; // change back to 0xBEEF since its not 0xDEAD
        idx = 4;
        // now check index 4 to see if index 4 properly stored 0xDEAD
        #1  clock = 1; // posedge
        #1  clock = 0; // negedge
        idx = 3; // reset idx to index 3
    end



endmodule
