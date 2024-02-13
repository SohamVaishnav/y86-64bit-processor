`include "fetch.v"
`include "memory.v"
`include "PC_update.v"
`include "execute_block.v"
`include "decode_reg_block.v"

module processor(
    input clk, 
    input [63:0] PC,
    output [63:0] PC_updated
);
    reg [3:0] icode, ifun, rA, rB;
    reg [63:0] valC, valP;
    reg func_error, reg_error;
    reg imem_error, dmem_error;
    reg halt, nop;
    reg [63:0] valA, valB, valE, valM;
    reg cnd, SF, ZF, OF;

    always @ (posedge clk) begin 
        fetch S1(PC, clk, icode, ifun, rA, rB, valC, valP, imem_error, func_error, halt, nop); //fetch stage

        if (imem_error == 0) begin
            case (icode)
            4'b0000 : begin //halt
                PC_updated = valP;
            end 
            4'b0001 : begin //nop
                PC_updated = valP;
            end
            4'b0010 : begin //cmovxx and rrmovq
                case (ifun) 
                4'b0000 : begin //rrmovq
                    decode_reg_block S2(rA, rB, valA, valB, 0, reg_error, 64'bx); //decode stage
                    valE = 0 + valA; //execute stage
                    decode_reg_block S3(rA, rB, valA, valB, 1, reg_error, valE); //write_back stage
                    PC_updated = valP;
                end
                default : begin //cmovxx
                    decode_reg_block S2(rA, rB, valA, valB, 0, reg_error, 64'bx); //decode stage
                    execute_block S3(valA, valb, valC, icode, ifun, valE, cnd, SF, ZF, OF); //execute stage
                    valE = 0 + valA;
                    if (cnd == 1) begin 
                        decode_reg_block S4(rA, rB, valA, valB, 1, reg_error, valE); //write_back stage
                    end
                    PC_updated = valP;
                end
                endcase
            end
            4'b0011 : begin //irmovq
                execute_block S2(valA, 64'd0, valC, icode, ifun, valE, cnd, SF, ZF, OF); //execute stage
                decode_reg_block S3(rA, rB, valA, valB, 1, reg_error, valE); //write_back stage
                PC_updated = valP;
            end
            4'b0100 : begin //rmmovq
                decode_reg_block S2(rA, rB, valA, valB, 0, reg_error, 64'bx); //decode stage
                execute_block S3(valA, valB, valC, icode, ifun, valE, cnd, SF, ZF, OF); //execute stage
                memory S4(valE, 1, valA, clk, valM, dmem_error); //memory stage 
                PC_updated = valP;  
            end
            4'b0101 : begin //mrmovq
                decode_reg_block S2(rA, rB, valA, valB, 0, reg_error, 64'bx); //decode stage
                execute_block S3(valA, valB, valC, icode, ifun, valE, cnd, SF, ZF, OF); //execute stage
                memory S4(valE, 0, valA, clk, valM, dmem_error); //memory stage
                decode_reg_block S5(rA, rB, valA, valB, 1, reg_error, valM); //write_back stage 
                PC_updated = valP;
            end
            4'b0110 : begin //OPq
                decode_reg_block S2(rA, rB, valA, valB, 0, reg_error, 64'bx); //decode stage 
                execute_block S3(valA, valB, valC, icode, ifun, valE, cnd, SF, ZF, OF); //execute
                decode_reg_block S4(rA, rB, valA, valB, 1, reg_error, valE); //write_back stage
                PC_updated = valP;
            end
            4'b0111 : begin //jXX
                case (ifun) 
                4'b0000 : begin //jmp 
                    PC_updated = valC;
                end
                default : begin //jXX 
                    PC_updated = valP;
                    execute_block S2(valA, valB, valC, icode, ifun, valE, cnd, SF, ZF, OF); //execute stage
                    if (cnd == 1) begin
                        PC_updated = valC;
                    end
                end
                endcase
            end
            4'b1000 : begin //call
///left to fill !!
            end
            4'b1001 : begin //ret 
// left to fill !!
            end
            4'b1010 : begin //pushq 
                decode_reg_block S2(rA, 4'b0100, valA, valB, 0, reg_error, 64'bx); //decode stage
                execute_block S3(valA, valB, valC, icode, ifun, valE, cnd, SF, ZF, OF); //execute stage
                memory S4(valE, 1, valA, clk, valM, dmem_error); //memory stage
                decode_reg_block S5(rA, 4'b0100, valA, valB, 1, reg_error, valE); //write_back stage
                PC_updated = valP;
            end
            4'b1011 : begin //popq
                decode_reg_block S2(rA, 4'b0100, valA, valB, 0, reg_error, 64'bx); //decode stage
                execute_block S3(valA, valB, valC, icode, ifun, valE, cnd, SF, ZF, OF); //execute stage
                memory S4(valE, 0, valA, clk, valM, dmem_error); //memory stage
                decode_reg_block S5(rA, 4'b0100, valA, valB, 1, reg_error, valE); //write_back stage
                decode_reg_block S6(rA, rA, valA, valB, 1, reg_error, valM); //write_back stage
                PC_updated = valP;
            end
            default: begin 
                func_error = 1;
            end
            endcase
        end
    end
endmodule