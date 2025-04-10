module alu_control_tb();
    logic [1:0] alu_op;
    logic [3:0] func;
    logic [2:0] alu_control_var;
    
    alu_control alu_control_testbench (
        .alu_op(alu_op),
        .func(func),
        .alu_control_var(alu_control_var)
    );
    
    initial begin
        alu_op = 2'b00;
        func = 4'b0000;
        
        $display("alu control testbench");
        
        alu_op = 2'b00;
        func = 4'b0000;
        #10;
        $display("Add - Time=%0t, ALU_Op=%2b, Func=%4b, ALU_Control=%3b", $time, alu_op, func, alu_control_var);
        $display(" ");
        assert(alu_control_var == 3'b000) else $error("ADD control signal incorrect");
        
        alu_op = 2'b00;
        func = 4'b0001;
        #10;
        $display("Sub- Time=%0t, ALU_Op=%2b, Func=%4b, ALU_Control=%3b", $time, alu_op, func, alu_control_var);
        $display(" ");
        assert(alu_control_var == 3'b001) else $error("SUB control signal incorrect");
        
        alu_op = 2'b00;
        func = 4'b0010;
        #10;
        $display("Shift left - Time=%0t, ALU_Op=%2b, Func=%4b, ALU_Control=%3b", $time, alu_op, func, alu_control_var);
        $display(" ");
        assert(alu_control_var == 3'b010) else $error("SLL control signal incorrect");
        
        alu_op = 2'b00;
        func = 4'b0011;
        #10;
        $display("And - Time=%0t, ALU_Op=%2b, Func=%4b, ALU_Control=%3b", $time, alu_op, func, alu_control_var);
        $display(" ");
        assert(alu_control_var == 3'b011) else $error("AND control signal incorrect");
        
        alu_op = 2'b01;
        func = 4'b0000;
        #10;
        $display("Branch (moves to sub) - Time=%0t, ALU_Op=%2b, Func=%4b, ALU_Control=%3b", $time, alu_op, func, alu_control_var);
        $display(" ");
        assert(alu_control_var == 3'b001) else $error("Branch control signal incorrect");
        
        alu_op = 2'b10;
        func = 4'b0000;
        #10;
        $display("Load/Store (moves to add) - Time=%0t, ALU_Op=%2b, Func=%4b, ALU_Control=%3b", $time, alu_op, func, alu_control_var);
        $display(" ");
        assert(alu_control_var == 3'b000) else $error("Load/Store control signal incorrect");
        
        $finish;
    end
endmodule