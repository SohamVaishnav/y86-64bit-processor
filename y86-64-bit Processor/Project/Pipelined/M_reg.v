module M_reg(e_cnd, M_bubble, clk, e_stat, e_icode, e_valE, e_valA, e_dstE, e_dstM, M_cnd, M_stat, M_icode, M_valE, M_valA, M_dstE, M_dstM);

input e_cnd, clk;
input [3:0] e_stat, e_icode, e_dstE, e_dstM;
input [63:0] e_valE, e_valA;
input M_bubble;
output reg M_cnd;
output reg [3:0] M_stat, M_icode, M_dstE, M_dstM;
output reg [63:0] M_valE, M_valA;

reg cnd;
reg [3:0] stat, icode;
reg [63:0] valE, valA, dstE, dstM;

initial begin 
    M_stat = 8;
end

always@(*)
begin
    cnd = e_cnd;
    stat = e_stat;
    icode = e_icode;
    valE = e_valE;
    valA = e_valA;
    dstE = e_dstE;
    dstM = e_dstM;
end

always@(posedge clk)
begin
    if (!M_bubble) begin 
        M_cnd <= cnd;
        M_stat <= stat;
        M_icode <= icode;
        M_valE <= valE;
        M_valA <= valA;
        M_dstE <= dstE;
        M_dstM <= dstM;
    end
    else begin 
        M_cnd <= 1'bx;
        M_stat <= 4'd8;
        M_icode <= 4'b0001;
        M_valE <= 64'bx;
        M_valA <= 64'bx;
        M_dstE <= 4'bx;
        M_dstM <= 4'bx;
    end
end



endmodule
