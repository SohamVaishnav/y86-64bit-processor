module memory_pipe_tb;
    reg M_cnd;
    reg [3:0] M_stat, M_icode;
    reg [3:0] M_dstE, M_dstM;
    reg [63:0] M_valA, M_valE;
    wire [3:0] m_stat, m_icode, m_dstE, m_dstM;
    wire [63:0] m_valE, m_valM;

    wire dmem_error;

    memory_pipe Mpip(.M_cnd(M_cnd),.M_stat(M_stat), .M_icode(M_icode),.M_dstE(M_dstE), .M_dstM(M_dstM),.M_valA(M_valA), .M_valE(M_valE),.m_stat(m_stat), .m_icode(m_icode), .m_dstE(m_dstE), .m_dstM(m_dstM),.m_valE(m_valE), .m_valM(m_valM));

    initial begin 
        // $dumpfile("memory_out.vcd");
        // $dumpvars(0, memory_tb);
        $monitor("M_icode = %0d, M_valA = %0d, M_valE = %0d, m_valM = %0d", 
        M_icode, M_valA, M_valE, m_valM);


        #20
        M_icode = 4;
        M_valA = 66;
        M_valE = 62;
        M_stat = 4'b1000;
        M_cnd = 0;
        M_dstE = 0;
        M_dstM = 0;

        #20
        M_icode = 5;
        M_valA = 1;
        M_valE = 62;

        #20
        M_icode = 6; 
        M_valA = 1;
        M_valE = 2;

        // PC = valP;

        #20
        M_icode = 10; 
        M_valA = 33;
        M_valE = 2039;

        #20
        M_icode = 11; 
        M_valA = 2039; 
        M_valE = 2047;
        // PC = valP;


        #20 $finish;
    end
endmodule