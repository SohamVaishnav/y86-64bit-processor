module fetch(
    input [63:0] PC,
    input clk,
    output reg [3:0] icode,
    output reg [3:0] ifun,
    output reg [3:0] rA,
    output reg [3:0] rB,
    output reg [63:0] valC, 
    output reg [63:0] valP,
    output reg mem_error, 
    output reg func_error,
    output reg halt, nop, 
    output reg just
);
    reg [7:0] ROM [1023:0];
    reg [7:0] icode_ifun;
    reg [7:0] rA_rB;

    initial begin 
    //Instruction memory 
        //halt (0:0)
        // ROM[0] = 8'b00000000;

        //nop (1:0)
        // ROM[0] = 8'b00010000;

        //rrmovq (2:0) (1->4)
        // ROM[0] = 8'b00100000;
        // ROM[1] = 8'b00010100;

        //irmovq (3:0) (10->3)
        // ROM[0] = 8'b00110000;
        // ROM[1] = 8'b11110011;
        // ROM[2] = 8'b01111011;
        // ROM[3] = 8'b00110011;
        // ROM[4] = 8'b00000000;
        // ROM[5] = 8'b11000100;
        // ROM[6] = 8'b10101010;
        // ROM[7] = 8'b00000000;
        // ROM[8] = 8'b00100000;
        // ROM[9] = 8'b10000110; 

        //rmmovq (4:0) (2->11)
        // ROM[0] = 8'b01000000;
        // ROM[1] = 8'b00101011;

        //mrmovq (5:0) (4->6)
        // ROM[0] = 8'b01010000;
        // ROM[1] = 8'b01000110;

        //Opq (6:x) (5 and 9)
            //addq
            // ROM[0] = 8'b01100000;

            //subq
            // ROM[0] = 8'b01100001;

            //andq 
            // ROM[0] = 8'b01100010;

            //xorq
            // ROM[0] = 8'b01100011;

        // ROM[1] = 8'b01011001;

        //jXX (7:0) (dest. = 985)
        // ROM[0] = 8'b01110000;
        // ROM[1] = 8'b11011001;
        // ROM[2] = 8'b00000011;
        // ROM[3] = 8'b00000000;
        // ROM[4] = 8'b00000000;
        // ROM[5] = 8'b00000000;
        // ROM[6] = 8'b00000000;
        // ROM[7] = 8'b00000000;
        // ROM[8] = 8'b00000000;

        //call (8:0) (dest. = 100)
        // ROM[0] = 8'b10000000;
        // ROM[1] = 8'b01100100;
        // ROM[2] = 8'b00000000;
        // ROM[3] = 8'b00000000;
        // ROM[4] = 8'b00000000;
        // ROM[5] = 8'b00000000;
        // ROM[6] = 8'b00000000;
        // ROM[7] = 8'b00000000;
        // ROM[8] = 8'b00000000;

        //ret (9:0) 
        // ROM[0] = 8'b10010000;

        //pushq (10:0) (8 & F)
        // ROM[0] = 8'b10100000;
        // ROM[1] = 8'b10001111;

        //popq (11:0) (3 & F)
        // ROM[0] = 8'b10110000;
        // ROM[1] = 8'b00111111;
    end
    
    always @ (posedge clk) begin
        mem_error = 0;
        func_error = 0;
        halt = 0;
        nop = 0;
        if (PC >= 1024 || PC < 0) begin 
            mem_error = 1;
        end
        if (mem_error == 0) begin 
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