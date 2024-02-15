module decode_reg_block(
    input clk,
    input [3:0] icode, ifun, 
    input [3:0] rA, rB, 
    input write_enable, 
    input [63:0] valE, valM, 
    output reg [63:0] valA, valB, 
    output reg reg_error
);

reg [63:0] storage [15:0];

initial
begin
    storage[0] = 64'b1010; //%rax
    storage[1] = 64'b1110; //%rcx
    storage[2] = 64'b1011; //%rdx
    storage[3] = 64'b1111; //%rbx
    storage[4] = 64'd1023; //%rsp -> points at the top of the stack which is at memory location 1023
    storage[5] = 64'b1010; //%rbp
    storage[6] = 64'b0001; //%rsi
    storage[7] = 64'b0010; //%rdi
    storage[8] = 64'b1000; //%r8 
    storage[9] = 64'b1110; //%r9
    storage[10] = 64'b1010; //%r10
    storage[11] = 64'b1001; //%r11
    storage[12] = 64'b1110; //%r12
    storage[13] = 64'b0111; //%r13 
    storage[14] = 64'b0101; //%r14
    storage[15] = 64'bx; //no register -> F
end

always@(*)
begin
    if (write_enable != 1)
    begin
        reg_error = 1;
        if((icode == 0) || (icode == 1) || (icode == 7) || (icode == 8) || (icode == 9))
        begin
            valA = storage[15];
            valB = storage[15];
            reg_error = 0;
        end
        else if((icode == 3))
        begin
            if((rB >= 0)&&(rB < 15))
            begin
                valA = storage[15];
                valB = storage[rB];
                reg_error = 0;
            end
        end
        else if((icode == 10) || (icode == 11))
        begin
            if((rA >= 0)&&(rA < 4'b1111))
            begin
                valA = storage[rA];
                valB = storage[4];
                reg_error = 0;
            end
        end
        else
        begin
            if ((rA >= 0)&&(rA < 15)&&(rB >=0)&&(rB < 15))
            begin
                valA = storage[rA];
                valB = storage[rB];
                reg_error = 0;
            end
        end
    end
end

always @ (negedge clk) begin //write_back stage operations 
    reg_error = 1;
    if(write_enable == 1) begin
    case (icode)
    (4'b0010), (4'b0011), (4'b0110) : begin //rrmovq, cmovxx, irmovq, OPq
        if (rB < 15 && rB >= 0) begin 
            storage[rB] = valE;
            reg_error = 0;
        end
    end
    4'b0101 : begin //mrmovq 
        if (rB < 15 && rB >= 0) begin 
            storage[rB] = valM;
            reg_error = 0;
        end
    end
    (4'b1000), (4'b1010) : begin //call or pushq 
        storage[4] = valE;
        reg_error = 0;
    end 
    (4'b1001), (4'b1011) : begin //ret or popq
        if (rA < 15 && rA >= 0) begin  
            storage[4'b0100] = valE;
            storage[rA] = valM;
            reg_error = 0;
        end
    end
    default : begin 
        reg_error = 0;
    end
    endcase 
    end
end

endmodule