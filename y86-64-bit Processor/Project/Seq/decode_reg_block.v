module decode_reg_block(
    input clk, halt, nop, 
    input [3:0] icode, ifun, 
    input [3:0] rA, rB, 
    input write_enable, 
    input [63:0] valE, valM, 
    output reg [63:0] valA, valB, 
    output reg reg_error, 
    output reg func_error
);

reg [63:0] storage [15:0];
reg [3:0] address;
reg [63:0] data_in;

initial
begin
    storage[0] = 4'b1010; //%rax
    storage[1] = 4'b1110; //%rcx
    storage[2] = 4'b1011; //%rdx
    storage[3] = 4'b1111; //%rbx
    storage[4] = 64'd1023; //%rsp -> points at the top of the stack which is at memory location 1023
    storage[5] = 4'b1010; //%rbp
    storage[6] = 4'b0001; //%rsi
    storage[7] = 4'b0010; //%rdi
    storage[8] = 4'b1000; //%r8 
    storage[9] = 4'b1110; //%r9
    storage[10] = 4'b1010; //%r10
    storage[11] = 4'b1001; //%r11
    storage[12] = 4'b1110; //%r12
    storage[13] = 4'b0111; //%r13
    storage[14] = 4'b0101; //%r14
    storage[15] = 4'bx; //no register -> F
end

always@(*)
begin
    if (write != 1)
    begin
        if ((ra >= 0)&&(ra < 4'b1111)&&(rb >=0)&&(rb < 4'b1111))
        begin
            vala = storage[ra];
            valb = storage[rb];
            err =0;
        end
        else
        begin
            err <=1;
        end
    end
    else 
    begin
    if(write == 1 && (rb >=0)&&(rb < 4'b1111))
    begin
        storage[rb] <= data_in;
        err <= 0;
    end
    else
    begin
        err <= 1;
    end
    end
end

always @ (negedge clk) begin //write_back stage operations 
    reg_error = 1;
    func_error = 0;
    case (icode)
    (4'b0010), (4'b0011), (4'b0110) : begin //rrmovq, cmovxx, irmovq, OPq
    //here rB is the address and valE is input data 
        address = rB;
        data_in = valE;
        if (address < 1024 && address >= 0) begin 
            reg_error = 0;
            if (write_enable == 1) begin 
                storage[address] = data_in;
            end
        end
    end
    4'b0101 : begin //mrmovq 
    //here rB is the address and valM is input data 
        address = rB;
        data_in = valM;
        if (address < 1024 && address >= 0) begin 
            reg_error = 0;
            if (write_enable == 1) begin 
                storage[address] = data_in;
            end
        end
    end
    (4'b1000), (4'b1010) : begin //call or pushq
    //here %rsp is the address and valE is input data 
        address = 4'b0100; 
        data_in = valE;
        if (address < 1024 && address >= 0) begin 
            reg_error = 0;
            if (write_enable == 1) begin 
                storage[address] = data_in;
            end
        end
    end 
    (4'b1001), (4'b1011) : begin //ret or popq
    //here rA, %rsp are the addresses and valM, valE are the input datas
        if (rA < 1024 && rA >= 0) begin 
            reg_error = 0;
            if (write_back == 1) begin 
                storage[4'b0100] = valE;
                storage[rA] = valM;
            end
        end
    end
    endcase 
end

endmodule