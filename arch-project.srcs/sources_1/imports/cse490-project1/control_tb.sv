module Control_tb;

    reg [5:0] opcode;
    reg clock = 0;
    reg reset = 1;

    wire RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
    wire [1:0] ALUOp;

    control uut (
        .opcode(opcode),
        .reg_dest(RegDst),
        .jump(Jump),
        .control_reset(reset),
        .branch(Branch),
        .mem_read(MemRead),
        .mem_reg(MemtoReg),
        .alu_op(ALUOp),
        .mem_write(MemWrite),
        .alu_mux(ALUSrc),
        .reg_write(RegWrite)
    );

    initial begin
        opcode = 6'b000000;
        clock = 1; #10;
        assert (RegWrite);
        clock = 0; #10
        opcode = 6'b100011; #10;
        clock = 1; #10
        assert (RegWrite && MemRead);
        $display("Simple Control test done.");
        $finish;
    end
endmodule
