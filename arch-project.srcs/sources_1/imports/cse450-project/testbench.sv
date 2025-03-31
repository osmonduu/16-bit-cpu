// testbench to run everything, make sure that things make sense
`timescale 1ns/100ps
`define WRITE 1
`define READ 0

module tb;
    parameter N = 16;
    reg [N-1:0] op_1 = 'h0x00B3; // stands for operand 1 and 2 repsectively
    reg [N-1:0] op_2 = 'hx0000; // default to null

    logic [N-1:0] result; // result of the tested operation


    int idx = 3; // index value
    logic clock = 0; // clock
    int optype = `WRITE; // type of operation

    register ra
    (
        .index(idx), 
        .accessType(optype),
        .clk(clock),
        .incomingData(op_1),
        .outgoingData(result)
    );

    initial 
       begin

        $dumpfile("regs.vcd");
        $dumpvars(); // dumpvars
        // don't need op_2
        clock = ~clock; // invert clock signal, posedge trigger
        #1 // one time step elapses
        // change all the needed values between clock posedges
        clock = ~clock; // negedge
        // now change operation type to read and see the contents of register 3
        optype = `READ;
        $display("we wrote to reg 3, now read from it.  result should be 0xB3, result is: 0x%h", result);
        #1
        // try a different index read/write
        op_1 = 'h0x43; // different value writing to reg 4
        idx = 4;
        #1 clock = ~clock; // posedge
        // change operation type to be invalid, clearing outgoingData
        optype = 3; // not a real operation
        #1 clock = ~clock; // nedegde
        #1 clock = ~clock; // posedge
        optype = `READ;
        #1 clock = ~clock; // nededge
        // now lets read what is in idx 4
        #1 clock = ~clock; // posedge
        $display("lets see what outgoing data");
        #10; // 10 ticks for sim to wrap up
        end


endmodule
