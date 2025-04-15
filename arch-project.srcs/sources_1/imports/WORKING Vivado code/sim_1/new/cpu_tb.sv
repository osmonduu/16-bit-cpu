`timescale 1ns/1ps

module cpu_tb;

    // inputs
    logic clock;
    // outputs
    logic [15:0] rd_before_tb;
    logic [15:0] rd_after_tb;
    logic [15:0] current_pc_tb;
    logic [15:0] current_instr_tb;
    
    // instantiate cpu module
    cpu test (
        .clock(clock),
        .rd_before(rd_before_tb),
        .rd_after(rd_after_tb),
        .current_pc(current_pc_tb),
        .current_instr(current_instr_tb)
    );
    
    // generate flipping clock - CHANGE THIS LATER TO MAKE IT FOREVER AND THEN FINISH AFTER SOME TIME
    initial begin
        clock = 0;
        forever begin
            #1 clock = ~clock;  //set high (posedge)
            #1 clock = ~clock;  //set low (negedge)
        end
//        $finish;     // finish after 32 cycles
    end
    
    // monitor the outputs
    initial begin
        $display("Time\t\tPC\t\tInstr\t\trd_before\t\trd_after");
        $monitor("%0dns\t\t%h\t\t%h\t\t%h\t\t%h", $time, current_pc_tb, current_instr_tb, rd_before_tb, rd_after_tb);
    end
    
    // Adjust time to finish simulation. Finish after 64 time units (32 cycles)
    initial #64 $finish;
    
endmodule
