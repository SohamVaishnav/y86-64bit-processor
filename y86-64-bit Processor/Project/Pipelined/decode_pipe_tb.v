module decode_pipe_tb;
    reg clk;
    reg [3:0] D_icode, D_ifun; 
    reg [3:0] D_rA, D_rB;
    reg [3:0] D_Stat; 
    reg [63:0] D_valC, D_valP; 
    reg [3:0] e_dstE, M_dstE; 
    reg [63:0] e_valE, M_valE; 
    reg [3:0] M_dstM, W_dstM; 
    reg [3:0] W_dstE; 
    reg [63:0] W_valE, m_valM; 
    reg [63:0] W_valM; 
    reg write_enable;

    wire [3:0] d_icode, d_ifun; 
    wire [3:0] d_Stat; 
    wire [63:0] d_valC;
    wire [63:0] d_valA, d_valB; 
    wire [3:0] d_dstE, d_dstM; 
    wire [3:0] d_srcA, d_srcB;

    decode_wb_pipe d(D_icode, D_ifun, D_rA, D_rB, D_Stat, D_valC, D_valP,
    e_dstE, M_dstE, e_valE, M_valE, M_dstM, W_dstM, W_dstE, W_valE, m_valM, W_valM, write_enable,
    d_icode, d_ifun, d_Stat, d_valC, d_valA, d_valB, d_dstE, d_dstM, d_srcA, d_srcB);

    initial begin 
        $dumpfile("d_out.vcd");
        $dumpvars(0, decode_pipe_tb);

        clk = 0;
        
        #5 clk = !clk;
        D_icode = 3; D_ifun = 0; D_Stat = 8;
        D_rB = 3; D_valC = 2; D_rA = 15; D_valP = 10;
        
        #5 clk = !clk;
        #5 $display("dic = %0d, dif = %0d, C = %0d, A = %0d, B = %0d, dstE = %0d, dtsM = %0d, srcA = %0d, srcB = %0d, d_stat = %0d\n" ,
        d_icode, d_ifun, d_valC, d_valA, d_valB, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);

        #5 clk = !clk;
        D_icode = 2; D_ifun = 0; D_Stat = 8;
        D_rB = 11; D_valC = 2; D_rA = 3; D_valP = 12;
        e_dstE = 3; e_valE = 2;

        #5 clk = !clk;
        #5 $display("dic = %0d, dif = %0d, C = %0d, A = %0d, B = %0d, dstE = %0d, dtsM = %0d, srcA = %0d, srcB = %0d, d_stat = %0d\n" ,
        d_icode, d_ifun, d_valC, d_valA, d_valB, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);

        #5 clk = !clk;
        D_icode = 6; D_ifun = 0; D_Stat = 8;
        D_rB = 3; D_valC = 2; D_rA = 11; D_valP = 14;
        e_dstE = 3; e_valE = 2;
        M_dstE = 11; M_valE = 2;

        #5 clk = !clk;
        #5 $display("dic = %0d, dif = %0d, C = %0d, A = %0d, B = %0d, dstE = %0d, dtsM = %0d, srcA = %0d, srcB = %0d, d_stat = %0d\n" ,
        d_icode, d_ifun, d_valC, d_valA, d_valB, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);

        #5 clk = !clk;
        D_icode = 8; D_ifun = 0; D_Stat = 8;
        D_valC = 25; D_valP = 23;

        #5 clk = !clk;
        #5 $display("dic = %0d, dif = %0d, C = %0d, A = %0d, B = %0d, dstE = %0d, dtsM = %0d, srcA = %0d, srcB = %0d, d_stat = %0d\n" ,
        d_icode, d_ifun, d_valC, d_valA, d_valB, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);

        #5 clk = !clk;
        D_icode = 10; D_ifun = 0; D_Stat = 8;
        D_valC = 25; D_valP = 27;
        M_valE = 4; M_dstE = 11;

        #5 clk = !clk;
        #5 $display("dic = %0d, dif = %0d, C = %0d, A = %0d, B = %0d, dstE = %0d, dtsM = %0d, srcA = %0d, srcB = %0d, d_stat = %0d\n" ,
        d_icode, d_ifun, d_valC, d_valA, d_valB, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);

        #5 clk = !clk;
        D_icode = 9; D_ifun = 0; D_Stat = 8;
        D_valC = 25; D_valP = 28;

        #5 clk = !clk;
        #5 $display("dic = %0d, dif = %0d, C = %0d, A = %0d, B = %0d, dstE = %0d, dtsM = %0d, srcA = %0d, srcB = %0d, d_stat = %0d\n" ,
        d_icode, d_ifun, d_valC, d_valA, d_valB, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);

        #5 clk = !clk;
        D_icode = 11; D_ifun = 0; D_Stat = 8;
        D_valC = 23; D_valP = 25;

        #5 clk = !clk;
        #5 $display("dic = %0d, dif = %0d, C = %0d, A = %0d, B = %0d, dstE = %0d, dtsM = %0d, srcA = %0d, srcB = %0d, d_stat = %0d\n" ,
        d_icode, d_ifun, d_valC, d_valA, d_valB, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);        
    end
endmodule 