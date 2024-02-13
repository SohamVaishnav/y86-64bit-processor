module fetch(
    input [63:0] PC,
    input clk,
    output reg [3:0] icode,
    output reg [3:0] ifun,
    output reg [3:0] rA,
    output reg [3:0] rB,
    output reg [63:0] valC, 
    output reg [63:0] valP,
    output reg imem_error, 
    output reg func_error,
    output reg halt, nop
);
    reg [7:0] ROM [1023:0];
    reg [7:0] icode_ifun;
    reg [7:0] rA_rB;

    initial begin 
    //Instruction memory 
        //write the instructions that need to be performed
    end
    
    always @ (*) begin
        imem_error = 0;
        func_error = 0;
        halt = 0;
        nop = 0;
        if (PC >= 1024 || PC < 0) begin 
            imem_error = 1;
        end
        if (imem_error == 0) begin 
            icode = ROM[PC][7:4];
            ifun = ROM[PC][3:0];
            case (icode)
                4'b0000 : begin //halt
                    halt = 1;
                    valP = PC + 1;
                end 
                4'b0001 : begin //nop
                    nop = 1;
                    valP = PC + 1;
                end
                4'b0010 : begin //cmovxx and rrmovq
                    rA = ROM[PC+1][7:4];
                    rB = ROM[PC+1][3:0];
                    valP = PC+2;
                end
                (4'b0011), (4'b0100), (4'b0101) : begin //irmovq or rmmovq or mrmovq
                    rA = ROM[PC+1][7:4];
                    rB = ROM[PC+1][3:0];
                    valC[7:0] = ROM[PC+2];
                    valC[15:8] = ROM[PC+3];
                    valC[23:16] = ROM[PC+4];
                    valC[31:24] = ROM[PC+5];
                    valC[39:32] = ROM[PC+6];
                    valC[47:40] = ROM[PC+7];
                    valC[55:48] = ROM[PC+8];
                    valC[63:56] = ROM[PC+9];
                    valP = PC+10;                     
                end
                4'b0110 : begin //OPq
                    rA = ROM[PC+1][7:4];
                    rB = ROM[PC+1][3:0];
                    valP = PC+2;
                end
                (4'b0111), (4'b1000) : begin //jXX or call
                    valC[7:0] = ROM[PC+1];
                    valC[15:8] = ROM[PC+2];
                    valC[23:16] = ROM[PC+3];
                    valC[31:24] = ROM[PC+4];
                    valC[39:32] = ROM[PC+5];
                    valC[47:40] = ROM[PC+6];
                    valC[55:48] = ROM[PC+7];
                    valC[63:56] = ROM[PC+8];
                    valP = PC+9;
                end
                4'b1001 : begin //ret 
                    valP = PC+1;
                end
                (4'b1010), (4'b1011) : begin //pushq or popq
                    rA = ROM[PC+1][7:4];
                    rB = ROM[PC+1][3:0];
                    valP = PC+2; 
                end
                default: begin 
                    func_error = 1;
                end
            endcase
        end
    end

endmodule 