module decode_reg_block(ra,rb,vala,valb,write,err,data_in);

input [3:0] ra,rb;
input write;
input [3:0] data_in;
output reg [63:0] vala,valb;
output reg err;

reg [63:0] storage [14:0];

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


endmodule