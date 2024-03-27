module E_reg(d_stat, d_icode, d_ifun, d_srcA, d_srcB, clk, d_valC, d_valA, d_valB, d_dstE, d_dstM, E_bubble, E_stat, E_icode, E_ifun, E_srcA, E_srcB,  E_valC, E_valA, E_valB, E_dstE, E_dstM);

input clk, E_bubble;
input [3:0] d_stat, d_icode, d_ifun, d_srcA, d_srcB, d_dstE, d_dstM;
input [63:0]  d_valC, d_valA, d_valB;
output reg [3:0] E_stat, E_icode, E_ifun, E_srcA, E_srcB, E_dstE, E_dstM;
output reg [63:0]  E_valC, E_valA, E_valB;

reg [3:0] stat, icode, ifun, srcA, srcB, dstE, dstM;
reg [63:0] valC, valA, valB;

initial begin 
    E_stat = 8;
end

always@(*)
begin
    stat = d_stat;
    icode = d_icode;
    ifun = d_ifun;
    srcA = d_srcA;
    srcB = d_srcB;
    valC = d_valC;
    valA = d_valA;
    valB = d_valB;
    dstE = d_dstE;
    dstM = d_dstM;
end

always@(posedge clk)
begin
    if (!E_bubble) begin 
        E_stat <= stat;
        E_icode <= icode;
        E_ifun <= ifun;
        E_srcA <= srcA;
        E_srcB <= srcB;
        E_valC <=valC;
        E_valA <= valA;
        E_valB <= valB;
        E_dstE <= dstE;
        E_dstM <= dstM;
    end
    else begin 
        E_stat <= 4'b1000;
        E_icode <= 4'b0001;
        E_ifun <= 4'b0000;
        E_srcA <= 4'bx;
        E_srcB <= 4'bx;
        E_valC <= 64'bx;
        E_valA <= 64'bx;
        E_valB <= 64'bx;
        E_dstE <= 4'bx;
        E_dstM <= 4'bx;
    end
end


endmodule
