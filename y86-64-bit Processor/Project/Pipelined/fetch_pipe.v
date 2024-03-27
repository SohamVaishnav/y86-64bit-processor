module fetch_pipe(
    input [63:0] predPC, 
    input M_Cnd, 
    input [3:0] M_icode, W_icode,
    input [63:0] W_valM, M_valA,
    output reg [3:0] f_icode, f_ifun, 
    output reg [3:0] f_rA, f_rB, 
    output reg [3:0] f_Stat, 
    output reg [63:0] f_valC, f_valP, 
    output reg [63:0] f_predPC
);

    reg [7:0] ROM [1023:0]; //instruction memory   
    reg imem_error, func_error;
    reg [63:0] f_pc;

    initial begin
    //fill the instruction memory with instructions
        $readmemb("1.txt", ROM);
    end

    always @ (*) begin //selectPC
        if (M_icode == 4'b0111) begin //if jXX
            if (M_Cnd == 0) begin //misprediction correction
                f_pc = M_valA;
            end
        end
        else if (W_icode == 4'b1001) begin //if ret
            f_pc = W_valM;
        end
        else f_pc = predPC;
    end

    always @ (*) begin 
        imem_error = 0;
        func_error = 0;
        if (f_pc >= 1024 || f_pc < 0) begin 
            imem_error = 1;
        end
        if (imem_error == 0) begin 
            f_icode = ROM[f_pc][7:4];
            f_ifun = ROM[f_pc][3:0];
            case (f_icode) 
            4'b0000 : begin //halt
                f_valP = f_pc + 1;
                f_valC = 64'bx;
                f_rA = 4'bx;
                f_rB = 4'bx;
            end
            4'b0001 : begin //nop
                f_valP = f_pc + 1;
                f_valC = 64'bx;
                f_rA = 4'bx;
                f_rB = 4'bx;
            end
            4'b0010 : begin //rromvq or cmovxx 
                f_rA = ROM[f_pc+1][7:4];
                f_rB = ROM[f_pc+1][3:0];
                f_valP = f_pc + 2;
                f_valC = 64'bx;
            end
            (4'b0011), (4'b0100), (4'b0101) : begin //irmovq or rmmovq or mrmovq
                f_rA = ROM[f_pc+1][7:4];
                f_rB = ROM[f_pc+1][3:0];
                f_valC[7:0] = ROM[f_pc+2];
                f_valC[15:8] = ROM[f_pc+3];
                f_valC[23:16] = ROM[f_pc+4];
                f_valC[31:24] = ROM[f_pc+5];
                f_valC[39:32] = ROM[f_pc+6];
                f_valC[47:40] = ROM[f_pc+7];
                f_valC[55:48] = ROM[f_pc+8];
                f_valC[63:56] = ROM[f_pc+9];
                f_valP = f_pc + 10;
            end
            4'b0110 : begin //OPq
                f_rA = ROM[f_pc+1][7:4];
                f_rB = ROM[f_pc+1][3:0];
                f_valP = f_pc + 2;
                f_valC = 64'bx;
            end
            (4'b0111), (4'b1000) : begin //jXX or call
                f_valC[7:0] = ROM[f_pc+1];
                f_valC[15:8] = ROM[f_pc+2];
                f_valC[23:16] = ROM[f_pc+3];
                f_valC[31:24] = ROM[f_pc+4];
                f_valC[39:32] = ROM[f_pc+5];
                f_valC[47:40] = ROM[f_pc+6];
                f_valC[55:48] = ROM[f_pc+7];
                f_valC[63:56] = ROM[f_pc+8];
                f_valP = f_pc + 9;
                f_rA = 4'bx;
                f_rB = 4'bx;
            end
            4'b1001 : begin //ret 
                f_valP = f_pc + 1;
                f_valC = 64'bx;
                f_rA = 4'bx;
                f_rB = 4'bx;
            end
            (4'b1010), (4'b1011) : begin //pushq or popq
                f_rA = ROM[f_pc+1][7:4];
                f_rB = ROM[f_pc+1][3:0];
                f_valP = f_pc + 2;
                f_valC = 64'bx;
            end
            default : begin
                if (f_icode != 4'bx && f_ifun != 4'bx) begin 
                    func_error = 1; 
                end
            end
            endcase
        end
    end

    always @ (*) begin //predictPC
        if (f_icode == 4'b0111 || f_icode == 4'b1000) begin
            f_predPC = f_valC; 
        end
        else f_predPC = f_valP;
    end

    always @ (*) begin //status codes
        f_Stat = 4'b1000; //AOK : ADR : INS : HLT
        if (f_icode == 4'b0000) begin 
            f_Stat = 4'b0001;
        end
        else if (imem_error == 1) begin 
            f_Stat = 4'b0100;
        end
        else if (func_error == 1) begin 
            f_Stat = 4'b0010;
        end
    end
endmodule