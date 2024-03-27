module W_reg(clk, m_stat, m_icode, m_valE, m_valM, m_dstE, m_dstM, W_stall, W_stat, W_icode, W_valE, W_valM, W_dstE, W_dstM);

input clk, W_stall;
input [3:0] m_stat, m_icode, m_dstE, m_dstM;
input [63:0] m_valE, m_valM;
output reg [3:0] W_stat, W_icode, W_dstE, W_dstM;
output reg [63:0] W_valE, W_valM;

reg [3:0] stat, icode;
reg [63:0] valE, valM, dstE, dstM;

initial begin 
    W_stat = 8;
end

always@(*)
begin
    stat = m_stat;
    icode = m_icode;
    valE = m_valE;
    valM = m_valM;
    dstE = m_dstE;
    dstM = m_dstM;
end

always@(posedge clk)
begin
    if (!W_stall) begin
        W_stat <= stat;
        W_icode <= icode;
        W_valE <= valE;
        W_valM <= valM;
        W_dstE <= dstE;
        W_dstM <= dstM;
    end
end


endmodule
