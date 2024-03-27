module pipe_control_logic(W_Stat, m_stat, M_icode, E_dstM, E_icode, d_srcB, d_srcA, D_icode, e_cnd, W_stall, M_bubble, cnd, E_bubble, D_bubble, D_stall, F_stall);

input [3:0] W_Stat, m_stat, M_icode, E_dstM, E_icode, d_srcB, d_srcA, D_icode ;
input e_cnd;
output reg W_stall, M_bubble, cnd, E_bubble, D_bubble, D_stall, F_stall; 

// initial 
// begin
//     W_stall = 0;
//     M_bubble = 0;
//     E_bubble = 0;
//     D_bubble = 0;
//     D_stall = 0;
//     F_stall = 0;
// end

always@(*)
begin
    M_bubble = 0;
    W_stall = 0;
    if ((((E_icode == 5) || (E_icode == 11)) && ((E_dstM == d_srcA) || (E_dstM == d_srcB))) || ((D_icode == 9)||(E_icode == 9)||(M_icode == 9))
    || (D_icode == 4'b0000))
    begin
        F_stall = 1;
    end
    else F_stall = 0;

    if(((E_icode == 7) && (e_cnd == 0)) || !((E_icode == 5)||(E_icode == 11) && ((E_dstM == d_srcA)||(E_dstM == d_srcB))) && ((D_icode == 9)||(E_icode == 9)||(M_icode == 9)))
    begin
        D_bubble = 1;
    end
    else D_bubble = 0;

    if(((E_icode == 7) && (e_cnd == 0)) || (((E_icode == 5) || (E_icode == 11)) && ((E_dstM == d_srcA) || (E_dstM == d_srcB)))
    || (D_icode == 4'b0000))
    begin
        E_bubble = 1;
    end
    else begin 
        E_bubble = 0;
    end
    
    if ((((E_icode == 5) || (E_icode == 11)) && ((E_dstM == d_srcA) || (E_dstM == d_srcB)))
    || (D_icode == 4'b0000)) begin 
        D_stall = 1;
    end
    else D_stall = 0;

    // if (W_Stat == 4'b0001) begin 
    //     M_bubble = 1;
    // end
    // else M_bubble = 0;

end


endmodule
