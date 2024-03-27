module execute_pipe_tb;

reg [3:0] E_stat, W_stat, m_stat, E_icode, E_ifun, E_dstE, E_dstM;
reg [63:0] E_valC, E_valA, E_valB;
wire e_cnd;
wire [3:0] e_stat, e_icode, e_dstE, e_dstM;
wire [63:0] e_valE, e_valA;
wire ZF, SF, OF;

execute_pipe dut(.E_stat(E_stat), .W_stat(W_stat), .m_stat(m_stat), .E_icode(E_icode), .E_ifun(E_ifun), .E_dstE(E_dstE), .E_dstM(E_dstM), .E_valC(E_valC), .E_valA(E_valA), .E_valB(E_valB), .e_cnd(e_cnd), .e_stat(e_stat), .e_icode(e_icode), .e_dstE(e_dstE), .e_dstM(e_dstM), .e_valE(e_valE), .e_valA(e_valA), .SF(SF), .ZF(ZF), .OF(OF));

always@(*)
begin
    $display("E_icode = %0d, E_ifun = %0d, E_valA = %0d, E_valB = %0d, E_valC = %0d, e_valE = %0d, ZF = %b", E_icode, E_ifun, E_valA, E_valB, E_valC, e_valE, ZF);
end

initial 
begin
    
        E_icode = 4'b0100; E_ifun = 4'b0001 ; E_valA = 4'b1001 ; E_valB = 4'b0001; E_valC = 4'b1011; E_stat = 1000; W_stat = 1000; m_stat = 1000; 
    #10 E_icode = 4'b0101; E_ifun = 4'b0101 ; E_valA = 4'b1000 ; E_valB = 4'b0101; E_valC = 4'b1010;
    #10 E_icode = 4'b0110; E_ifun = 4'b0000 ; E_valA = 4'b0000 ; E_valB = 4'b0000; E_valC = 4'b0001; 
    #10 E_icode = 4'b0110; E_ifun = 4'b0000 ; E_valA = 64'b0111111111111111111111111111111111111111111111111111111111111111 ; E_valB = 64'b0111111111111111111111111111111111111111111111111111111111111111 ; E_valC = 4'b0001;
    #10 E_icode = 4'b0111; E_ifun = 4'b0101 ; E_valA = 4'b0101 ; E_valB = 4'b1111; E_valC = 4'b0000;
    #10 E_icode = 4'b0110; E_ifun = 4'b0010 ; E_valA = 4'b0110 ; E_valB = 4'b0010; E_valC = 4'b0001;
    #10 E_icode = 4'b1000; E_ifun = 4'b0011 ; E_valA = 4'b0110 ; E_valB = 4'b1010; E_valC = 4'b1111;
    #10 E_icode = 4'b1001; E_ifun = 4'b1110; E_valA = 4'b1100 ; E_valB = 4'b0010; E_valC = 4'b1100;
    #10 E_icode = 4'b1010; E_ifun = 4'b0001 ; E_valA = 4'b1100 ; E_valB = 4'b1111; E_valC = 4'b0010;
    #10 E_icode = 4'b1011; E_ifun = 4'b0101 ; E_valA = 4'b0011 ; E_valB = 4'b0010; E_valC = 4'b1010;

end


endmodule
