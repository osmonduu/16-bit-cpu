
// go through this once lmk if everything looks good: dhirajjjj

module control (
    input[2:0] opcode,
    input reg clock,
    input reg control_reset,
    output logic [1:0] reg_dest, mem_reg, alu_op,
    output logic jump, branch, mem_read, mem_write, alu_mux, reg_write, sign_extd 
);
    always@(posedge clock) begin

         if (control_reset) begin
            reg_dest = 2'b00;
            mem_reg = 2'b00;
            alu_op = 2'b00;
            jump = 1'b0;
            branch = 1'b0;
            mem_read = 1'b0;
            mem_write = 1'b0;
            alu_mux = 1'b0;
            reg_write = 1'b0;
            sign_extd = 1'b1;
        end else begin
            reg_dest = 2'b00;
            mem_reg = 2'b00;
            alu_op = 2'b00;
            jump = 1'b0;
            branch = 1'b0;
            mem_read = 1'b0;
            mem_write = 1'b0;
            alu_mux = 1'b0;
            reg_write = 1'b0;
            sign_extd = 1'b1;
        end

        case (opcode)
            4'b0000: begin
                reg_dest = 2'b01;
                mem_reg = 2'b00;
                alu_op = 2'b00;
                alu_mux = 1'b0;
                reg_write = 1'b1;
            end
            4'b0001: begin
                reg_dest = 2'b01;
                mem_reg = 2'b00;
                alu_op = 2'b01;
                alu_mux = 1'b0;
                reg_write = 1'b1;
            end
            4'b0010: begin
                reg_dest = 2'b01;
                mem_reg   = 2'b00;
                alu_op = 2'b10;
                alu_mux = 1'b0;
                reg_write = 1'b1;
            end
            4'b0011: begin
                reg_dest = 2'b01;
                mem_reg = 2'b00;
                alu_op = 2'b11;
                alu_mux = 1'b0;
                reg_write = 1'b1;
            end
            4'b0100: begin
                reg_dest = 2'b00;
                mem_reg = 2'b01;
                alu_op = 2'b00;
                mem_read = 1'b1;
                alu_mux = 1'b1;
                reg_write = 1'b1;
            end
            4'b0101: begin
                alu_op = 2'b00;
                mem_write = 1'b1;
                alu_mux = 1'b1;
            end
            4'b0110: begin
                reg_dest = 2'b00;
                mem_reg = 2'b00;
                alu_op = 2'b00;
                alu_mux = 1'b1;
                reg_write = 1'b1;
            end
            4'b0111: begin
                alu_op = 2'b01;
                branch = 1'b1;
                alu_mux = 1'b0;
            end
            4'b1000: begin
                alu_op = 2'b01;
                branch = 1'b1;
                alu_mux = 1'b0;
            end
            4'b1001: begin
                jump = 1'b1;
            end
            default: begin

            end
        endcase
      end

endmodule
