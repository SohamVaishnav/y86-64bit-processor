module D_reg (f_stat, f_icode, f_ifun, f_rA, f_rB, clk, f_valC, f_valP, D_stall, D_bubble, D_stat, D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP);

input clk, D_stall, D_bubble;
input [3:0] f_stat, f_icode, f_ifun, f_rA, f_rB;
input [63:0] f_valC, f_valP;
output reg [3:0] D_stat, D_icode, D_ifun, D_rA, D_rB;
output reg [63:0] D_valC, D_valP;

reg [3:0] stat, icode, ifun, rA, rB;
reg [63:0] valC, valP;

initial begin 
    D_stat = 8;
end

always@(*)
begin
    stat = f_stat;
    icode = f_icode;
    ifun = f_ifun;
    rA = f_rA;
    rB = f_rB;
    valC = f_valC;
    valP = f_valP;
end

always@(posedge clk)
begin
    if (!D_stall && !D_bubble) begin 
        D_stat <= stat;
        D_icode <= icode;
        D_ifun <= ifun;
        D_rA <= rA;
        D_rB <= rB;
        D_valC <= valC;
        D_valP <= valP;
    end
    else if (D_bubble && !D_stall) begin 
        D_stat <= 4'b1000;
        D_icode <= 4'b0001;
        D_ifun <= 4'b0000;
        D_rA <= 4'bx;
        D_rB <= 4'bx;
        D_valC <= 64'bx;
        D_valP <= 64'bx;
    end 
end


endmodule
