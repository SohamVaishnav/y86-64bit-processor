 module execute_block_tb;

reg [63:0] vala,valb,valc;
reg [3:0] icode,ifun;
wire [62:0] vale;
wire cnd,SF,ZF,OF;

execute_block dut(.vala(vala),.valb(valb),.valc(valc),.icode(icode),.ifun(ifun),.vale(vale),.cnd(cnd),.SF(SF),.ZF(ZF),.OF(OF));

initial 
begin
    
        icode = 4'b0100; ifun = 4'b0001 ; vala = 4'b1001 ; valb = 4'b0001; valc = 4'b1011;
    #10 icode = 4'b0101; ifun = 4'b0101 ; vala = 4'b1000 ; valb = 4'b0101; valc = 4'b1010;
    #10 icode = 4'b0110; ifun = 4'b0000 ; vala = 4'b0110 ; valb = 4'b0010; valc = 4'b0001;
    #10 icode = 4'b0110; ifun = 4'b0000 ; vala = 64'b0111111111111111111111111111111111111111111111111111111111111111 ; valb = 64'b0111111111111111111111111111111111111111111111111111111111111111 ; valc = 4'b0001;
    #10 icode = 4'b0111; ifun = 4'b0101 ; vala = 4'b0101 ; valb = 4'b1111; valc = 4'b0000;
    #10 icode = 4'b0110; ifun = 4'b0010 ; vala = 4'b0110 ; valb = 4'b0010; valc = 4'b0001;
    #10 icode = 4'b1000; ifun = 4'b0011 ; vala = 4'b0110 ; valb = 4'b1010; valc = 4'b1111;
    #10 icode = 4'b1001; ifun = 4'b1110; vala = 4'b1100 ; valb = 4'b0010; valc = 4'b1100;
    #10 icode = 4'b1010; ifun = 4'b0001 ; vala = 4'b1100 ; valb = 4'b1111; valc = 4'b0010;
    #10 icode = 4'b1011; ifun = 4'b0101 ; vala = 4'b0011 ; valb = 4'b0010; valc = 4'b1010;

end


endmodule
