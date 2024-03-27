`include "fetch_pipe.v"
`include "decode_wb_pipe.v"
`include "execute_pipe.v"
`include "memory_pipe.v"
`include "pipe_control_logic.v"
`include "D_reg.v"
`include "E_reg.v"
`include "M_reg.v"
`include "W_reg.v"

module processor_pipe;
    reg clk;
    reg [63:0] predPC;
    reg write_enable;

    wire ZF, OF, SF;
    // reg [63:0] M_valA, W_valM;
    // reg [3:0] M_icode, W_icode;
    // reg M_cnd;
    
    wire F_stall, D_stall, D_bubble;
    wire E_bubble, M_bubble, W_stall;
    wire cnd;

    wire [63:0] f_predPC, f_valC, f_valP;
    wire [3:0] f_icode, f_ifun, f_Stat;
    wire [3:0] f_rA, f_rB;

    wire [3:0] D_Stat, D_icode, D_ifun;
    wire [3:0] D_rA, D_rB;
    wire [63:0] D_valC, D_valP;

    wire [3:0] d_icode, d_ifun, d_Stat;
    wire [63:0] d_valC, d_valA, d_valB;
    wire [3:0] d_dstE, d_dstM;
    wire [3:0] d_srcA, d_srcB; 

    wire [3:0] E_Stat, E_icode, E_ifun;
    wire [3:0] E_rA, E_rB;
    wire [3:0] E_srcA, E_srcB;
    wire [63:0] E_valC, E_valA, E_valB;
    wire [3:0] E_dstE, E_dstM;

    wire [3:0] e_icode, e_Stat;
    wire [63:0] e_valE, e_valA;
    wire [3:0] e_dstE, e_dstM;
    wire e_cnd;

    wire [3:0] M_icode, M_Stat; 
    wire [63:0] M_valE, M_valA;
    wire [3:0] M_dstE, M_dstM;
    wire M_cnd;

    wire [3:0] m_icode, m_Stat;
    wire [63:0] m_valE, m_valM;
    wire [3:0] m_dstE, m_dstM;

    wire [3:0] W_icode, W_Stat;
    wire [63:0] W_valE, W_valM;
    wire [3:0] W_dstE, W_dstM;

    pipe_control_logic pcl(W_Stat, m_Stat, M_icode, E_dstM, E_icode, d_srcB, d_srcA, D_icode, e_cnd,
    W_stall, M_bubble, cnd, E_bubble, D_bubble, D_stall, F_stall);

    fetch_pipe f1(predPC, M_cnd, M_icode, W_icode, W_valM, M_valA, 
    f_icode, f_ifun, f_rA, f_rB, f_Stat, f_valC, f_valP, f_predPC);

    D_reg D(f_Stat, f_icode, f_ifun, f_rA, f_rB, clk, f_valC, f_valP, D_stall, D_bubble, 
    D_Stat, D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP);

    decode_wb_pipe d1(D_icode, D_ifun, D_rA, D_rB, D_Stat, D_valC, D_valP,
    e_dstE, M_dstE, e_valE, M_valE, M_dstM, W_dstM, W_dstE, W_valE, m_valM, W_valM, write_enable,
    d_icode, d_ifun, d_Stat, d_valC, d_valA, d_valB, d_dstE, d_dstM, d_srcA, d_srcB);

    E_reg E(d_Stat, d_icode, d_ifun, d_srcA, d_srcB, clk, d_valC, d_valA, d_valB, d_dstE, d_dstM,
    E_bubble, E_Stat, E_icode, E_ifun, E_srcA, E_srcB, E_valC, E_valA, E_valB, E_dstE, E_dstM);

    execute_pipe e1(E_Stat, W_Stat, m_Stat, E_icode, E_ifun, E_dstE, E_dstM, E_valC, E_valA, E_valB,
    e_cnd, e_Stat, e_icode, e_dstE, e_dstM, e_valE, e_valA, SF, ZF, OF);

    M_reg M(e_cnd, M_bubble, clk, e_Stat, e_icode, e_valE, e_valA, e_dstE, e_dstM, 
    M_cnd, M_Stat, M_icode, M_valE, M_valA, M_dstE, M_dstM);

    memory_pipe m1(M_cnd, M_Stat, M_icode, M_dstE, M_dstM, M_valA, M_valE,
    m_Stat, m_icode, m_dstE, m_dstM, m_valE, m_valM);

    W_reg W(clk, m_Stat, m_icode, m_valE, m_valM, m_dstE, m_dstM, W_stall,
    W_Stat, W_icode, W_valE, W_valM, W_dstE, W_dstM);

    decode_wb_pipe w1(D_icode, D_ifun, D_rA, D_rB, D_Stat, D_valC, D_valP, 
    e_dstE, M_dstE, e_valE, M_valE, M_dstM, W_dstM, W_dstE, W_valE, m_valM, W_valM, write_enable,
    d_icode, d_ifun, d_Stat, d_valC, d_valA, d_valB, d_dstE, d_dstM, d_srcA, d_srcB);

    always @ (*) begin 
        if (D_Stat == 4'b0001 || D_Stat == 4'b0100 || D_Stat == 4'b0010) begin 
            #5 $display("Processor will be halted within 5 clock cycles!\n");
            #50 $finish;
        end
    end


    always begin 
        #5 clk = !clk;
    end

    always @ (negedge clk) begin 
        #5 $display("clk = %d", clk);
        $display("Fetch block: F_stall = %0d", F_stall);
        $display("currPr_Pc = %0d, f_ic = %d, f_if = %d, f_rA = %d, f_rB = %d, C = %0d, P = %0d, f_St = %d, f_prPc = %0d", 
        predPC, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, f_Stat, f_predPC);

        $display("Decode block: D_stall = %d, D_bubble = %0d", D_stall, D_bubble);
        $display("d_ic = %d, d_if = %d, d_A = %0d, d_B = %0d, d_C = %0d, d_dstE = %0d, d_dstM = %d, d_srcA = %0d, d_srcB = %0d, d_St = %0d", 
        d_icode, d_ifun, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);

        $display("Execute block: E_bubble = %0d", E_bubble);
        $display("e_cnd = %d, ZF = %0d, e_ic = %d, e_dstE = %0d, e_dstM = %0d, E = %0d, A = %0d, e_St = %d",
        e_cnd, ZF, e_icode, e_dstE, e_dstM, e_valE, e_valA, e_Stat);

        $display("Memory block: M_bubble = %0d", M_bubble);
        $display("m_ic = %d, m_dstE = %0d, m_dstM = %0d, E = %0d, M = %0d, m_St = %d\n",
        m_icode, m_dstE, m_dstM, m_valE, m_valM, m_Stat);
    end

    always @ (posedge clk) begin 
        #5 $display("clk = %d, time = %d", clk, $time);
        $display("F pipe: F_stall = %0d", F_stall);
        $display("predicted PC = %0d", predPC);

        $display("D pipe: D_stall = %0d, D_bubble = %0d", D_stall, D_bubble);
        $display("D_ic = %d, D_if = %d, D_rA = %d, D_rB = %d, C = %0d, P = %0d, D_St = %d", 
        D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, D_Stat);

        $display("E pipe: E_bubble = %0d", E_bubble);
        $display("E_ic = %d, E_if = %d, E_A = %0d, E_B = %0d, E_C = %0d, E_dstE = %0d, E_dstM = %d, E_srcA = %0d, E_srcB = %0d, E_St = %0d", 
        E_icode, E_ifun, E_valA, E_valB, E_valC, E_dstE, E_dstM, E_srcA, E_srcB, E_Stat);

        $display("M pipe: M_bubble = %0d", M_bubble);
        $display("M_ic = %d, M_dstE = %0d, M_dstM = %0d, E = %0d, A = %0d, M_cnd = %d, M_St = %d", 
        M_icode, M_dstE, M_dstM, M_valE, M_valA, M_cnd, M_Stat);

        $display("W pipe: W_stall = %0d", W_stall);
        $display("W_ic = %d, W_dstE = %0d, W_dstM = %0d, E = %0d, M = %0d, W_St = %d\n", 
        W_icode, W_dstE, W_dstM, W_valE, W_valM, W_Stat);
    end

    always @ (posedge clk) begin 
        if (!F_stall) begin 
            predPC = f_predPC;
        end
    end
    
    initial begin 
        $dumpfile("proc_pipe_out.vcd");
        $dumpvars(0, processor_pipe);

        clk = 0;
        predPC = 0;

        // $monitor("time = %d", $time);
        // #5 $display("clk = %d", clk);
        // $display("Fetch block: F_stall = %0d", F_stall);
        // $display("currPr_Pc = %0d, f_ic = %d, f_if = %d, f_rA = %d, f_rB = %d, C = %0d, P = %0d, f_St = %d, f_prPc = %0d", 
        // predPC, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, f_Stat, f_predPC);

        // $display("Decode block: D_stall = %d, D_bubble = %0d", D_stall, D_bubble);
        // $display("d_ic = %d, d_if = %d, d_A = %0d, d_B = %0d, d_C = %0d, d_dstE = %0d, d_dstM = %d, d_srcA = %0d, d_srcB = %0d, d_St = %0d", 
        // d_icode, d_ifun, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);

        // $display("Execute block: E_bubble = %0d", E_bubble);
        // $display("e_cnd = %d, e_ic = %d, e_dstE = %0d, e_dstM = %0d, E = %0d, A = %0d, e_St = %d",
        // e_cnd, e_icode, e_dstE, e_dstM, e_valE, e_valA, e_Stat);

        // $display("Memory block: M_bubble = %0d", M_bubble);
        // $display("m_ic = %d, m_dstE = %0d, m_dstM = %0d, E = %0d, M = %0d, m_St = %d",
        // m_icode, m_dstE, m_dstM, m_valE, m_valM, m_Stat);

        // $display("WB block: W_stall = %0d", W_stall);
        // $display("d_ic = %d, d_if = %d, d_A = %0d, d_B = %0d, d_C = %0d, d_dstE = %0d, d_dstM = %d, d_srcA = %0d, d_srcB = %0d, d_St = %0d\n", 
        // d_icode, d_ifun, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);


        // #5 clk = !clk;
        // #5 $display("clk = %d", clk);
        // $display("F pipe: F_stall = %0d", F_stall);
        // // predPC = f_predPC;
        // $display("predicted PC = %0d", predPC);

        // $display("D pipe: D_stall = %0d, D_bubble = %0d", D_stall, D_bubble);
        // $display("D_ic = %d, D_if = %d, D_rA = %d, D_rB = %d, C = %0d, P = %0d, D_St = %d", 
        // D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, D_Stat);

        // $display("E pipe: E_bubble = %0d", E_bubble);
        // $display("E_ic = %d, E_if = %d, E_A = %0d, E_B = %0d, E_C = %0d, E_dstE = %0d, E_dstM = %d, E_srcA = %0d, E_srcB = %0d, E_St = %0d", 
        // E_icode, E_ifun, E_valA, E_valB, E_valC, E_dstE, E_dstM, E_srcA, E_srcB, E_Stat);

        // $display("M pipe: M_bubble = %0d", M_bubble);
        // $display("M_ic = %d, M_dstE = %0d, M_dstM = %0d, E = %0d, A = %0d, M_cnd = %d, M_St = %d", 
        // M_icode, M_dstE, M_dstM, M_valE, M_valA, M_cnd, M_Stat);

        // $display("W pipe: W_stall = %0d", W_stall);
        // $display("W_ic = %d, W_dstE = %0d, W_dstM = %0d, E = %0d, M = %0d, W_St = %d\n", 
        // W_icode, W_dstE, W_dstM, W_valE, W_valM, W_Stat);

        // //cycle 2
        // #5 clk = !clk;
        // #5 $display("clk = %d", clk);
        // $display("Fetch block: F_stall = %0d", F_stall);
        // $display("currPr_Pc = %0d, f_ic = %d, f_if = %d, f_rA = %d, f_rB = %d, C = %0d, P = %0d, f_St = %d, f_prPc = %0d", 
        // predPC, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, f_Stat, f_predPC);

        // $display("Decode block: D_stall = %d, D_bubble = %0d", D_stall, D_bubble);
        // $display("d_ic = %d, d_if = %d, d_A = %0d, d_B = %0d, d_C = %0d, d_dstE = %0d, d_dstM = %d, d_srcA = %0d, d_srcB = %0d, d_St = %0d", 
        // d_icode, d_ifun, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);

        // $display("Execute block: E_bubble = %0d", E_bubble);
        // $display("e_cnd = %d, e_ic = %d, e_dstE = %0d, e_dstM = %0d, E = %0d, A = %0d, e_St = %d",
        // e_cnd, e_icode, e_dstE, e_dstM, e_valE, e_valA, e_Stat);

        // $display("Memory block: M_bubble = %0d", M_bubble);
        // $display("m_ic = %d, m_dstE = %0d, m_dstM = %0d, E = %0d, M = %0d, m_St = %d",
        // m_icode, m_dstE, m_dstM, m_valE, m_valM, m_Stat);

        // $display("WB block: W_stall = %0d", W_stall);
        // $display("d_ic = %d, d_if = %d, d_A = %0d, d_B = %0d, d_C = %0d, d_dstE = %0d, d_dstM = %d, d_srcA = %0d, d_srcB = %0d, d_St = %0d\n", 
        // d_icode, d_ifun, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);


        // #5 clk = !clk;
        // #5 $display("clk = %d", clk);
        // $display("F pipe: F_stall = %0d", F_stall);
        // // predPC = f_predPC;
        // $display("predicted PC = %0d", predPC);

        // $display("D pipe: D_stall = %0d, D_bubble = %0d", D_stall, D_bubble);
        // $display("D_ic = %d, D_if = %d, D_rA = %d, D_rB = %d, C = %0d, P = %0d, D_St = %d", 
        // D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, D_Stat);

        // $display("E pipe: E_bubble = %0d", E_bubble);
        // $display("E_ic = %d, E_if = %d, E_A = %0d, E_B = %0d, E_C = %0d, E_dstE = %0d, E_dstM = %d, E_srcA = %0d, E_srcB = %0d, E_St = %0d", 
        // E_icode, E_ifun, E_valA, E_valB, E_valC, E_dstE, E_dstM, E_srcA, E_srcB, E_Stat);

        // $display("M pipe: M_bubble = %0d", M_bubble);
        // $display("M_ic = %d, M_dstE = %0d, M_dstM = %0d, E = %0d, A = %0d, M_cnd = %d, M_St = %d", 
        // M_icode, M_dstE, M_dstM, M_valE, M_valA, M_cnd, M_Stat);

        // $display("W pipe: W_stall = %0d", W_stall);
        // $display("W_ic = %d, W_dstE = %0d, W_dstM = %0d, E = %0d, M = %0d, W_St = %d\n", 
        // W_icode, W_dstE, W_dstM, W_valE, W_valM, W_Stat);

        // //cycle 3
        // #5 clk = !clk;
        // #5 $display("clk = %d", clk);
        // $display("Fetch block: F_stall = %0d", F_stall);
        // $display("currPr_Pc = %0d, f_ic = %d, f_if = %d, f_rA = %d, f_rB = %d, C = %0d, P = %0d, f_St = %d, f_prPc = %0d", 
        // predPC, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, f_Stat, f_predPC);

        // $display("Decode block: D_stall = %d, D_bubble = %0d", D_stall, D_bubble);
        // $display("d_ic = %d, d_if = %d, d_A = %0d, d_B = %0d, d_C = %0d, d_dstE = %0d, d_dstM = %d, d_srcA = %0d, d_srcB = %0d, d_St = %0d", 
        // d_icode, d_ifun, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);

        // $display("Execute block: E_bubble = %0d", E_bubble);
        // $display("e_cnd = %d, e_ic = %d, e_dstE = %0d, e_dstM = %0d, E = %0d, A = %0d, e_St = %d",
        // e_cnd, e_icode, e_dstE, e_dstM, e_valE, e_valA, e_Stat);

        // $display("Memory block: M_bubble = %0d", M_bubble);
        // $display("m_ic = %d, m_dstE = %0d, m_dstM = %0d, E = %0d, M = %0d, m_St = %d",
        // m_icode, m_dstE, m_dstM, m_valE, m_valM, m_Stat);

        // $display("WB block: W_stall = %0d", W_stall);
        // $display("d_ic = %d, d_if = %d, d_A = %0d, d_B = %0d, d_C = %0d, d_dstE = %0d, d_dstM = %d, d_srcA = %0d, d_srcB = %0d, d_St = %0d\n", 
        // d_icode, d_ifun, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);


        // #5 clk = !clk;
        // #5 $display("clk = %d", clk);
        // $display("F pipe: F_stall = %0d", F_stall);
        // // predPC = f_predPC;
        // $display("predicted PC = %0d", predPC);

        // $display("D pipe: D_stall = %0d, D_bubble = %0d", D_stall, D_bubble);
        // $display("D_ic = %d, D_if = %d, D_rA = %d, D_rB = %d, C = %0d, P = %0d, D_St = %d", 
        // D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, D_Stat);

        // $display("E pipe: E_bubble = %0d", E_bubble);
        // $display("E_ic = %d, E_if = %d, E_A = %0d, E_B = %0d, E_C = %0d, E_dstE = %0d, E_dstM = %d, E_srcA = %0d, E_srcB = %0d, E_St = %0d", 
        // E_icode, E_ifun, E_valA, E_valB, E_valC, E_dstE, E_dstM, E_srcA, E_srcB, E_Stat);

        // $display("M pipe: M_bubble = %0d", M_bubble);
        // $display("M_ic = %d, M_dstE = %0d, M_dstM = %0d, E = %0d, A = %0d, M_cnd = %d, M_St = %d", 
        // M_icode, M_dstE, M_dstM, M_valE, M_valA, M_cnd, M_Stat);

        // $display("W pipe: W_stall = %0d", W_stall);
        // $display("W_ic = %d, W_dstE = %0d, W_dstM = %0d, E = %0d, M = %0d, W_St = %d\n", 
        // W_icode, W_dstE, W_dstM, W_valE, W_valM, W_Stat);

        // //cycle 4
        // #5 clk = !clk;
        // #5 $display("clk = %d", clk);
        // $display("Fetch block: F_stall = %0d", F_stall);
        // $display("currPr_Pc = %0d, f_ic = %d, f_if = %d, f_rA = %d, f_rB = %d, C = %0d, P = %0d, f_St = %d, f_prPc = %0d", 
        // predPC, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, f_Stat, f_predPC);

        // $display("Decode block: D_stall = %d, D_bubble = %0d", D_stall, D_bubble);
        // $display("d_ic = %d, d_if = %d, d_A = %0d, d_B = %0d, d_C = %0d, d_dstE = %0d, d_dstM = %d, d_srcA = %0d, d_srcB = %0d, d_St = %0d", 
        // d_icode, d_ifun, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);

        // $display("Execute block: E_bubble = %0d", E_bubble);
        // $display("e_cnd = %d, e_ic = %d, e_dstE = %0d, e_dstM = %0d, E = %0d, A = %0d, e_St = %d",
        // e_cnd, e_icode, e_dstE, e_dstM, e_valE, e_valA, e_Stat);

        // $display("Memory block: M_bubble = %0d", M_bubble);
        // $display("m_ic = %d, m_dstE = %0d, m_dstM = %0d, E = %0d, M = %0d, m_St = %d",
        // m_icode, m_dstE, m_dstM, m_valE, m_valM, m_Stat);

        // $display("WB block: W_stall = %0d", W_stall);
        // $display("d_ic = %d, d_if = %d, d_A = %0d, d_B = %0d, d_C = %0d, d_dstE = %0d, d_dstM = %d, d_srcA = %0d, d_srcB = %0d, d_St = %0d\n", 
        // d_icode, d_ifun, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);


        // #5 clk = !clk;
        // #5 $display("clk = %d", clk);
        // $display("F pipe: F_stall = %0d", F_stall);
        // // predPC = f_predPC;
        // $display("predicted PC = %0d", predPC);

        // $display("D pipe: D_stall = %0d, D_bubble = %0d", D_stall, D_bubble);
        // $display("D_ic = %d, D_if = %d, D_rA = %d, D_rB = %d, C = %0d, P = %0d, D_St = %d", 
        // D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, D_Stat);

        // $display("E pipe: E_bubble = %0d", E_bubble);
        // $display("E_ic = %d, E_if = %d, E_A = %0d, E_B = %0d, E_C = %0d, E_dstE = %0d, E_dstM = %d, E_srcA = %0d, E_srcB = %0d, E_St = %0d", 
        // E_icode, E_ifun, E_valA, E_valB, E_valC, E_dstE, E_dstM, E_srcA, E_srcB, E_Stat);

        // $display("M pipe: M_bubble = %0d", M_bubble);
        // $display("M_ic = %d, M_dstE = %0d, M_dstM = %0d, E = %0d, A = %0d, M_cnd = %d, M_St = %d", 
        // M_icode, M_dstE, M_dstM, M_valE, M_valA, M_cnd, M_Stat);

        // $display("W pipe: W_stall = %0d", W_stall);
        // $display("W_ic = %d, W_dstE = %0d, W_dstM = %0d, E = %0d, M = %0d, W_St = %d\n", 
        // W_icode, W_dstE, W_dstM, W_valE, W_valM, W_Stat);

        // //cycle 5
        // #5 clk = !clk;
        // #5 $display("clk = %d", clk);
        // $display("Fetch block: F_stall = %0d", F_stall);
        // $display("currPr_Pc = %0d, f_ic = %d, f_if = %d, f_rA = %d, f_rB = %d, C = %0d, P = %0d, f_St = %d, f_prPc = %0d", 
        // predPC, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, f_Stat, f_predPC);

        // $display("Decode block: D_stall = %d, D_bubble = %0d", D_stall, D_bubble);
        // $display("d_ic = %d, d_if = %d, d_A = %0d, d_B = %0d, d_C = %0d, d_dstE = %0d, d_dstM = %d, d_srcA = %0d, d_srcB = %0d, d_St = %0d", 
        // d_icode, d_ifun, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);

        // $display("Execute block: E_bubble = %0d", E_bubble);
        // $display("e_cnd = %d, e_ic = %d, e_dstE = %0d, e_dstM = %0d, E = %0d, A = %0d, e_St = %d",
        // e_cnd, e_icode, e_dstE, e_dstM, e_valE, e_valA, e_Stat);

        // $display("Memory block: M_bubble = %0d", M_bubble);
        // $display("m_ic = %d, m_dstE = %0d, m_dstM = %0d, E = %0d, M = %0d, m_St = %d",
        // m_icode, m_dstE, m_dstM, m_valE, m_valM, m_Stat);

        // $display("WB block: W_stall = %0d", W_stall);
        // $display("d_ic = %d, d_if = %d, d_A = %0d, d_B = %0d, d_C = %0d, d_dstE = %0d, d_dstM = %d, d_srcA = %0d, d_srcB = %0d, d_St = %0d\n", 
        // d_icode, d_ifun, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);


        // #5 clk = !clk;
        // #5 $display("clk = %d", clk);
        // $display("F pipe: F_stall = %0d", F_stall);
        // // predPC = f_predPC;
        // $display("predicted PC = %0d", predPC);

        // $display("D pipe: D_stall = %0d, D_bubble = %0d", D_stall, D_bubble);
        // $display("D_ic = %d, D_if = %d, D_rA = %d, D_rB = %d, C = %0d, P = %0d, D_St = %d", 
        // D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, D_Stat);

        // $display("E pipe: E_bubble = %0d", E_bubble);
        // $display("E_ic = %d, E_if = %d, E_A = %0d, E_B = %0d, E_C = %0d, E_dstE = %0d, E_dstM = %d, E_srcA = %0d, E_srcB = %0d, E_St = %0d", 
        // E_icode, E_ifun, E_valA, E_valB, E_valC, E_dstE, E_dstM, E_srcA, E_srcB, E_Stat);

        // $display("M pipe: M_bubble = %0d", M_bubble);
        // $display("M_ic = %d, M_dstE = %0d, M_dstM = %0d, E = %0d, A = %0d, M_cnd = %d, M_St = %d", 
        // M_icode, M_dstE, M_dstM, M_valE, M_valA, M_cnd, M_Stat);

        // $display("W pipe: W_stall = %0d", W_stall);
        // $display("W_ic = %d, W_dstE = %0d, W_dstM = %0d, E = %0d, M = %0d, W_St = %d\n", 
        // W_icode, W_dstE, W_dstM, W_valE, W_valM, W_Stat);

        // //cycle 6
        // #5 clk = !clk;
        // #5 $display("clk = %d", clk);
        // $display("Fetch block: F_stall = %0d", F_stall);
        // $display("currPr_Pc = %0d, f_ic = %d, f_if = %d, f_rA = %d, f_rB = %d, C = %0d, P = %0d, f_St = %d, f_prPc = %0d", 
        // predPC, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, f_Stat, f_predPC);

        // $display("Decode block: D_stall = %d, D_bubble = %0d", D_stall, D_bubble);
        // $display("d_ic = %d, d_if = %d, d_A = %0d, d_B = %0d, d_C = %0d, d_dstE = %0d, d_dstM = %d, d_srcA = %0d, d_srcB = %0d, d_St = %0d", 
        // d_icode, d_ifun, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);

        // $display("Execute block: E_bubble = %0d", E_bubble);
        // $display("e_cnd = %d, e_ic = %d, e_dstE = %0d, e_dstM = %0d, E = %0d, A = %0d, e_St = %d",
        // e_cnd, e_icode, e_dstE, e_dstM, e_valE, e_valA, e_Stat);

        // $display("Memory block: M_bubble = %0d", M_bubble);
        // $display("m_ic = %d, m_dstE = %0d, m_dstM = %0d, E = %0d, M = %0d, m_St = %d",
        // m_icode, m_dstE, m_dstM, m_valE, m_valM, m_Stat);

        // $display("WB block: W_stall = %0d", W_stall);
        // $display("d_ic = %d, d_if = %d, d_A = %0d, d_B = %0d, d_C = %0d, d_dstE = %0d, d_dstM = %d, d_srcA = %0d, d_srcB = %0d, d_St = %0d\n", 
        // d_icode, d_ifun, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);


        // #5 clk = !clk;
        // #5 $display("clk = %d", clk);
        // $display("F pipe: F_stall = %0d", F_stall);
        // // predPC = f_predPC;
        // $display("predicted PC = %0d", predPC);

        // $display("D pipe: D_stall = %0d, D_bubble = %0d", D_stall, D_bubble);
        // $display("D_ic = %d, D_if = %d, D_rA = %d, D_rB = %d, C = %0d, P = %0d, D_St = %d", 
        // D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, D_Stat);

        // $display("E pipe: E_bubble = %0d", E_bubble);
        // $display("E_ic = %d, E_if = %d, E_A = %0d, E_B = %0d, E_C = %0d, E_dstE = %0d, E_dstM = %d, E_srcA = %0d, E_srcB = %0d, E_St = %0d", 
        // E_icode, E_ifun, E_valA, E_valB, E_valC, E_dstE, E_dstM, E_srcA, E_srcB, E_Stat);

        // $display("M pipe: M_bubble = %0d", M_bubble);
        // $display("M_ic = %d, M_dstE = %0d, M_dstM = %0d, E = %0d, A = %0d, M_cnd = %d, M_St = %d", 
        // M_icode, M_dstE, M_dstM, M_valE, M_valA, M_cnd, M_Stat);

        // $display("W pipe: W_stall = %0d", W_stall);
        // $display("W_ic = %d, W_dstE = %0d, W_dstM = %0d, E = %0d, M = %0d, W_St = %d\n", 
        // W_icode, W_dstE, W_dstM, W_valE, W_valM, W_Stat);

        // //cycle 7
        // #5 clk = !clk;
        // #5 $display("clk = %d", clk);
        // $display("Fetch block: F_stall = %0d", F_stall);
        // $display("currPr_Pc = %0d, f_ic = %d, f_if = %d, f_rA = %d, f_rB = %d, C = %0d, P = %0d, f_St = %d, f_prPc = %0d", 
        // predPC, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, f_Stat, f_predPC);

        // $display("Decode block: D_stall = %d, D_bubble = %0d", D_stall, D_bubble);
        // $display("d_ic = %d, d_if = %d, d_A = %0d, d_B = %0d, d_C = %0d, d_dstE = %0d, d_dstM = %d, d_srcA = %0d, d_srcB = %0d, d_St = %0d", 
        // d_icode, d_ifun, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);

        // $display("Execute block: E_bubble = %0d", E_bubble);
        // $display("e_cnd = %d, e_ic = %d, e_dstE = %0d, e_dstM = %0d, E = %0d, A = %0d, e_St = %d",
        // e_cnd, e_icode, e_dstE, e_dstM, e_valE, e_valA, e_Stat);

        // $display("Memory block: M_bubble = %0d", M_bubble);
        // $display("m_ic = %d, m_dstE = %0d, m_dstM = %0d, E = %0d, M = %0d, m_St = %d",
        // m_icode, m_dstE, m_dstM, m_valE, m_valM, m_Stat);

        // $display("WB block: W_stall = %0d", W_stall);
        // $display("d_ic = %d, d_if = %d, d_A = %0d, d_B = %0d, d_C = %0d, d_dstE = %0d, d_dstM = %d, d_srcA = %0d, d_srcB = %0d, d_St = %0d\n", 
        // d_icode, d_ifun, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);


        // #5 clk = !clk;
        // #5 $display("clk = %d", clk);
        // $display("F pipe: F_stall = %0d", F_stall);
        // // predPC = f_predPC;
        // $display("predicted PC = %0d", predPC);

        // $display("D pipe: D_stall = %0d, D_bubble = %0d", D_stall, D_bubble);
        // $display("D_ic = %d, D_if = %d, D_rA = %d, D_rB = %d, C = %0d, P = %0d, D_St = %d", 
        // D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, D_Stat);

        // $display("E pipe: E_bubble = %0d", E_bubble);
        // $display("E_ic = %d, E_if = %d, E_A = %0d, E_B = %0d, E_C = %0d, E_dstE = %0d, E_dstM = %d, E_srcA = %0d, E_srcB = %0d, E_St = %0d", 
        // E_icode, E_ifun, E_valA, E_valB, E_valC, E_dstE, E_dstM, E_srcA, E_srcB, E_Stat);

        // $display("M pipe: M_bubble = %0d", M_bubble);
        // $display("M_ic = %d, M_dstE = %0d, M_dstM = %0d, E = %0d, A = %0d, M_cnd = %d, M_St = %d", 
        // M_icode, M_dstE, M_dstM, M_valE, M_valA, M_cnd, M_Stat);

        // $display("W pipe: W_stall = %0d", W_stall);
        // $display("W_ic = %d, W_dstE = %0d, W_dstM = %0d, E = %0d, M = %0d, W_St = %d\n", 
        // W_icode, W_dstE, W_dstM, W_valE, W_valM, W_Stat);

        // //cycle 8
        // #5 clk = !clk;
        // #5 $display("clk = %d", clk);
        // $display("Fetch block: F_stall = %0d", F_stall);
        // $display("currPr_Pc = %0d, f_ic = %d, f_if = %d, f_rA = %d, f_rB = %d, C = %0d, P = %0d, f_St = %d, f_prPc = %0d", 
        // predPC, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, f_Stat, f_predPC);

        // $display("Decode block: D_stall = %d, D_bubble = %0d", D_stall, D_bubble);
        // $display("d_ic = %d, d_if = %d, d_A = %0d, d_B = %0d, d_C = %0d, d_dstE = %0d, d_dstM = %d, d_srcA = %0d, d_srcB = %0d, d_St = %0d", 
        // d_icode, d_ifun, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);

        // $display("Execute block: E_bubble = %0d", E_bubble);
        // $display("e_cnd = %d, e_ic = %d, e_dstE = %0d, e_dstM = %0d, E = %0d, A = %0d, e_St = %d",
        // e_cnd, e_icode, e_dstE, e_dstM, e_valE, e_valA, e_Stat);

        // $display("Memory block: M_bubble = %0d", M_bubble);
        // $display("m_ic = %d, m_dstE = %0d, m_dstM = %0d, E = %0d, M = %0d, m_St = %d",
        // m_icode, m_dstE, m_dstM, m_valE, m_valM, m_Stat);

        // $display("WB block: W_stall = %0d", W_stall);
        // $display("d_ic = %d, d_if = %d, d_A = %0d, d_B = %0d, d_C = %0d, d_dstE = %0d, d_dstM = %d, d_srcA = %0d, d_srcB = %0d, d_St = %0d\n", 
        // d_icode, d_ifun, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);


        // #5 clk = !clk;
        // #5 $display("clk = %d", clk);
        // $display("F pipe: F_stall = %0d", F_stall);
        // // predPC = f_predPC;
        // $display("predicted PC = %0d", predPC);

        // $display("D pipe: D_stall = %0d, D_bubble = %0d", D_stall, D_bubble);
        // $display("D_ic = %d, D_if = %d, D_rA = %d, D_rB = %d, C = %0d, P = %0d, D_St = %d", 
        // D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, D_Stat);

        // $display("E pipe: E_bubble = %0d", E_bubble);
        // $display("E_ic = %d, E_if = %d, E_A = %0d, E_B = %0d, E_C = %0d, E_dstE = %0d, E_dstM = %d, E_srcA = %0d, E_srcB = %0d, E_St = %0d", 
        // E_icode, E_ifun, E_valA, E_valB, E_valC, E_dstE, E_dstM, E_srcA, E_srcB, E_Stat);

        // $display("M pipe: M_bubble = %0d", M_bubble);
        // $display("M_ic = %d, M_dstE = %0d, M_dstM = %0d, E = %0d, A = %0d, M_cnd = %d, M_St = %d", 
        // M_icode, M_dstE, M_dstM, M_valE, M_valA, M_cnd, M_Stat);

        // $display("W pipe: W_stall = %0d", W_stall);
        // $display("W_ic = %d, W_dstE = %0d, W_dstM = %0d, E = %0d, M = %0d, W_St = %d\n", 
        // W_icode, W_dstE, W_dstM, W_valE, W_valM, W_Stat);

        // //cycle 9
        // #5 clk = !clk;
        // #5 $display("clk = %d", clk);
        // $display("Fetch block: F_stall = %0d", F_stall);
        // $display("currPr_Pc = %0d, f_ic = %d, f_if = %d, f_rA = %d, f_rB = %d, C = %0d, P = %0d, f_St = %d, f_prPc = %0d", 
        // predPC, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, f_Stat, f_predPC);

        // $display("Decode block: D_stall = %d, D_bubble = %0d", D_stall, D_bubble);
        // $display("d_ic = %d, d_if = %d, d_A = %0d, d_B = %0d, d_C = %0d, d_dstE = %0d, d_dstM = %d, d_srcA = %0d, d_srcB = %0d, d_St = %0d", 
        // d_icode, d_ifun, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);

        // $display("Execute block: E_bubble = %0d", E_bubble);
        // $display("e_cnd = %d, e_ic = %d, e_dstE = %0d, e_dstM = %0d, E = %0d, A = %0d, e_St = %d",
        // e_cnd, e_icode, e_dstE, e_dstM, e_valE, e_valA, e_Stat);

        // $display("Memory block: M_bubble = %0d", M_bubble);
        // $display("m_ic = %d, m_dstE = %0d, m_dstM = %0d, E = %0d, M = %0d, m_St = %d",
        // m_icode, m_dstE, m_dstM, m_valE, m_valM, m_Stat);

        // $display("WB block: W_stall = %0d", W_stall);
        // $display("d_ic = %d, d_if = %d, d_A = %0d, d_B = %0d, d_C = %0d, d_dstE = %0d, d_dstM = %d, d_srcA = %0d, d_srcB = %0d, d_St = %0d\n", 
        // d_icode, d_ifun, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);


        // #5 clk = !clk;
        // #5 $display("clk = %d", clk);
        // $display("F pipe: F_stall = %0d", F_stall);
        // // predPC = f_predPC;
        // $display("predicted PC = %0d", predPC);

        // $display("D pipe: D_stall = %0d, D_bubble = %0d", D_stall, D_bubble);
        // $display("D_ic = %d, D_if = %d, D_rA = %d, D_rB = %d, C = %0d, P = %0d, D_St = %d", 
        // D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, D_Stat);

        // $display("E pipe: E_bubble = %0d", E_bubble);
        // $display("E_ic = %d, E_if = %d, E_A = %0d, E_B = %0d, E_C = %0d, E_dstE = %0d, E_dstM = %d, E_srcA = %0d, E_srcB = %0d, E_St = %0d", 
        // E_icode, E_ifun, E_valA, E_valB, E_valC, E_dstE, E_dstM, E_srcA, E_srcB, E_Stat);

        // $display("M pipe: M_bubble = %0d", M_bubble);
        // $display("M_ic = %d, M_dstE = %0d, M_dstM = %0d, E = %0d, A = %0d, M_cnd = %d, M_St = %d", 
        // M_icode, M_dstE, M_dstM, M_valE, M_valA, M_cnd, M_Stat);

        // $display("W pipe: W_stall = %0d", W_stall);
        // $display("W_ic = %d, W_dstE = %0d, W_dstM = %0d, E = %0d, M = %0d, W_St = %d\n", 
        // W_icode, W_dstE, W_dstM, W_valE, W_valM, W_Stat);

        // //cycle 10
        // #5 clk = !clk;
        // #5 $display("clk = %d", clk);
        // $display("Fetch block: F_stall = %0d", F_stall);
        // $display("currPr_Pc = %0d, f_ic = %d, f_if = %d, f_rA = %d, f_rB = %d, C = %0d, P = %0d, f_St = %d, f_prPc = %0d", 
        // predPC, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, f_Stat, f_predPC);

        // $display("Decode block: D_stall = %d, D_bubble = %0d", D_stall, D_bubble);
        // $display("d_ic = %d, d_if = %d, d_A = %0d, d_B = %0d, d_C = %0d, d_dstE = %0d, d_dstM = %d, d_srcA = %0d, d_srcB = %0d, d_St = %0d", 
        // d_icode, d_ifun, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);

        // $display("Execute block: E_bubble = %0d", E_bubble);
        // $display("e_cnd = %d, e_ic = %d, e_dstE = %0d, e_dstM = %0d, E = %0d, A = %0d, e_St = %d",
        // e_cnd, e_icode, e_dstE, e_dstM, e_valE, e_valA, e_Stat);

        // $display("Memory block: M_bubble = %0d", M_bubble);
        // $display("m_ic = %d, m_dstE = %0d, m_dstM = %0d, E = %0d, M = %0d, m_St = %d",
        // m_icode, m_dstE, m_dstM, m_valE, m_valM, m_Stat);

        // $display("WB block: W_stall = %0d", W_stall);
        // $display("d_ic = %d, d_if = %d, d_A = %0d, d_B = %0d, d_C = %0d, d_dstE = %0d, d_dstM = %d, d_srcA = %0d, d_srcB = %0d, d_St = %0d\n", 
        // d_icode, d_ifun, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);


        // #5 clk = !clk;
        // #5 $display("clk = %d", clk);
        // $display("F pipe: F_stall = %0d", F_stall);
        // // predPC = f_predPC;
        // $display("predicted PC = %0d", predPC);

        // $display("D pipe: D_stall = %0d, D_bubble = %0d", D_stall, D_bubble);
        // $display("D_ic = %d, D_if = %d, D_rA = %d, D_rB = %d, C = %0d, P = %0d, D_St = %d", 
        // D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, D_Stat);

        // $display("E pipe: E_bubble = %0d", E_bubble);
        // $display("E_ic = %d, E_if = %d, E_A = %0d, E_B = %0d, E_C = %0d, E_dstE = %0d, E_dstM = %d, E_srcA = %0d, E_srcB = %0d, E_St = %0d", 
        // E_icode, E_ifun, E_valA, E_valB, E_valC, E_dstE, E_dstM, E_srcA, E_srcB, E_Stat);

        // $display("M pipe: M_bubble = %0d", M_bubble);
        // $display("M_ic = %d, M_dstE = %0d, M_dstM = %0d, E = %0d, A = %0d, M_cnd = %d, M_St = %d", 
        // M_icode, M_dstE, M_dstM, M_valE, M_valA, M_cnd, M_Stat);

        // $display("W pipe: W_stall = %0d", W_stall);
        // $display("W_ic = %d, W_dstE = %0d, W_dstM = %0d, E = %0d, M = %0d, W_St = %d\n", 
        // W_icode, W_dstE, W_dstM, W_valE, W_valM, W_Stat);

        // //cycle 11
        // #5 clk = !clk;
        // #5 $display("clk = %d", clk);
        // $display("Fetch block: F_stall = %0d", F_stall);
        // $display("currPr_Pc = %0d, f_ic = %d, f_if = %d, f_rA = %d, f_rB = %d, C = %0d, P = %0d, f_St = %d, f_prPc = %0d", 
        // predPC, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, f_Stat, f_predPC);

        // $display("Decode block: D_stall = %d, D_bubble = %0d", D_stall, D_bubble);
        // $display("d_ic = %d, d_if = %d, d_A = %0d, d_B = %0d, d_C = %0d, d_dstE = %0d, d_dstM = %d, d_srcA = %0d, d_srcB = %0d, d_St = %0d", 
        // d_icode, d_ifun, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);

        // $display("Execute block: E_bubble = %0d", E_bubble);
        // $display("e_cnd = %d, e_ic = %d, e_dstE = %0d, e_dstM = %0d, E = %0d, A = %0d, e_St = %d",
        // e_cnd, e_icode, e_dstE, e_dstM, e_valE, e_valA, e_Stat);

        // $display("Memory block: M_bubble = %0d", M_bubble);
        // $display("m_ic = %d, m_dstE = %0d, m_dstM = %0d, E = %0d, M = %0d, m_St = %d",
        // m_icode, m_dstE, m_dstM, m_valE, m_valM, m_Stat);

        // $display("WB block: W_stall = %0d", W_stall);
        // $display("d_ic = %d, d_if = %d, d_A = %0d, d_B = %0d, d_C = %0d, d_dstE = %0d, d_dstM = %d, d_srcA = %0d, d_srcB = %0d, d_St = %0d\n", 
        // d_icode, d_ifun, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);


        // #5 clk = !clk;
        // #5 $display("clk = %d", clk);
        // $display("F pipe: F_stall = %0d", F_stall);
        // // predPC = f_predPC;
        // $display("predicted PC = %0d", predPC);

        // $display("D pipe: D_stall = %0d, D_bubble = %0d", D_stall, D_bubble);
        // $display("D_ic = %d, D_if = %d, D_rA = %d, D_rB = %d, C = %0d, P = %0d, D_St = %d", 
        // D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, D_Stat);

        // $display("E pipe: E_bubble = %0d", E_bubble);
        // $display("E_ic = %d, E_if = %d, E_A = %0d, E_B = %0d, E_C = %0d, E_dstE = %0d, E_dstM = %d, E_srcA = %0d, E_srcB = %0d, E_St = %0d", 
        // E_icode, E_ifun, E_valA, E_valB, E_valC, E_dstE, E_dstM, E_srcA, E_srcB, E_Stat);

        // $display("M pipe: M_bubble = %0d", M_bubble);
        // $display("M_ic = %d, M_dstE = %0d, M_dstM = %0d, E = %0d, A = %0d, M_cnd = %d, M_St = %d", 
        // M_icode, M_dstE, M_dstM, M_valE, M_valA, M_cnd, M_Stat);

        // $display("W pipe: W_stall = %0d", W_stall);
        // $display("W_ic = %d, W_dstE = %0d, W_dstM = %0d, E = %0d, M = %0d, W_St = %d\n", 
        // W_icode, W_dstE, W_dstM, W_valE, W_valM, W_Stat);

        // //cycle 12
        // #5 clk = !clk;
        // #5 $display("clk = %d", clk);
        // $display("Fetch block: F_stall = %0d", F_stall);
        // $display("currPr_Pc = %0d, f_ic = %d, f_if = %d, f_rA = %d, f_rB = %d, C = %0d, P = %0d, f_St = %d, f_prPc = %0d", 
        // predPC, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, f_Stat, f_predPC);

        // $display("Decode block: D_stall = %d, D_bubble = %0d", D_stall, D_bubble);
        // $display("d_ic = %d, d_if = %d, d_A = %0d, d_B = %0d, d_C = %0d, d_dstE = %0d, d_dstM = %d, d_srcA = %0d, d_srcB = %0d, d_St = %0d", 
        // d_icode, d_ifun, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);

        // $display("Execute block: E_bubble = %0d", E_bubble);
        // $display("e_cnd = %d, e_ic = %d, e_dstE = %0d, e_dstM = %0d, E = %0d, A = %0d, e_St = %d",
        // e_cnd, e_icode, e_dstE, e_dstM, e_valE, e_valA, e_Stat);

        // $display("Memory block: M_bubble = %0d", M_bubble);
        // $display("m_ic = %d, m_dstE = %0d, m_dstM = %0d, E = %0d, M = %0d, m_St = %d",
        // m_icode, m_dstE, m_dstM, m_valE, m_valM, m_Stat);

        // $display("WB block: W_stall = %0d", W_stall);
        // $display("d_ic = %d, d_if = %d, d_A = %0d, d_B = %0d, d_C = %0d, d_dstE = %0d, d_dstM = %d, d_srcA = %0d, d_srcB = %0d, d_St = %0d\n", 
        // d_icode, d_ifun, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);


        // #5 clk = !clk;
        // #5 $display("clk = %d", clk);
        // $display("F pipe: F_stall = %0d", F_stall);
        // // predPC = f_predPC;
        // $display("predicted PC = %0d", predPC);

        // $display("D pipe: D_stall = %0d, D_bubble = %0d", D_stall, D_bubble);
        // $display("D_ic = %d, D_if = %d, D_rA = %d, D_rB = %d, C = %0d, P = %0d, D_St = %d", 
        // D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, D_Stat);

        // $display("E pipe: E_bubble = %0d", E_bubble);
        // $display("E_ic = %d, E_if = %d, E_A = %0d, E_B = %0d, E_C = %0d, E_dstE = %0d, E_dstM = %d, E_srcA = %0d, E_srcB = %0d, E_St = %0d", 
        // E_icode, E_ifun, E_valA, E_valB, E_valC, E_dstE, E_dstM, E_srcA, E_srcB, E_Stat);

        // $display("M pipe: M_bubble = %0d", M_bubble);
        // $display("M_ic = %d, M_dstE = %0d, M_dstM = %0d, E = %0d, A = %0d, M_cnd = %d, M_St = %d", 
        // M_icode, M_dstE, M_dstM, M_valE, M_valA, M_cnd, M_Stat);

        // $display("W pipe: W_stall = %0d", W_stall);
        // $display("W_ic = %d, W_dstE = %0d, W_dstM = %0d, E = %0d, M = %0d, W_St = %d\n", 
        // W_icode, W_dstE, W_dstM, W_valE, W_valM, W_Stat);

        // //cycle 13
        // #5 clk = !clk;
        // #5 $display("clk = %d", clk);
        // $display("Fetch block: F_stall = %0d", F_stall);
        // $display("currPr_Pc = %0d, f_ic = %d, f_if = %d, f_rA = %d, f_rB = %d, C = %0d, P = %0d, f_St = %d, f_prPc = %0d", 
        // predPC, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, f_Stat, f_predPC);

        // $display("Decode block: D_stall = %d, D_bubble = %0d", D_stall, D_bubble);
        // $display("d_ic = %d, d_if = %d, d_A = %0d, d_B = %0d, d_C = %0d, d_dstE = %0d, d_dstM = %d, d_srcA = %0d, d_srcB = %0d, d_St = %0d", 
        // d_icode, d_ifun, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);

        // $display("Execute block: E_bubble = %0d", E_bubble);
        // $display("e_cnd = %d, e_ic = %d, e_dstE = %0d, e_dstM = %0d, E = %0d, A = %0d, e_St = %d",
        // e_cnd, e_icode, e_dstE, e_dstM, e_valE, e_valA, e_Stat);

        // $display("Memory block: M_bubble = %0d", M_bubble);
        // $display("m_ic = %d, m_dstE = %0d, m_dstM = %0d, E = %0d, M = %0d, m_St = %d",
        // m_icode, m_dstE, m_dstM, m_valE, m_valM, m_Stat);

        // $display("WB block: W_stall = %0d", W_stall);
        // $display("d_ic = %d, d_if = %d, d_A = %0d, d_B = %0d, d_C = %0d, d_dstE = %0d, d_dstM = %d, d_srcA = %0d, d_srcB = %0d, d_St = %0d\n", 
        // d_icode, d_ifun, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);


        // #5 clk = !clk;
        // #5 $display("clk = %d", clk);
        // $display("F pipe: F_stall = %0d", F_stall);
        // // predPC = f_predPC;
        // $display("predicted PC = %0d", predPC);

        // $display("D pipe: D_stall = %0d, D_bubble = %0d", D_stall, D_bubble);
        // $display("D_ic = %d, D_if = %d, D_rA = %d, D_rB = %d, C = %0d, P = %0d, D_St = %d", 
        // D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, D_Stat);

        // $display("E pipe: E_bubble = %0d", E_bubble);
        // $display("E_ic = %d, E_if = %d, E_A = %0d, E_B = %0d, E_C = %0d, E_dstE = %0d, E_dstM = %d, E_srcA = %0d, E_srcB = %0d, E_St = %0d", 
        // E_icode, E_ifun, E_valA, E_valB, E_valC, E_dstE, E_dstM, E_srcA, E_srcB, E_Stat);

        // $display("M pipe: M_bubble = %0d", M_bubble);
        // $display("M_ic = %d, M_dstE = %0d, M_dstM = %0d, E = %0d, A = %0d, M_cnd = %d, M_St = %d", 
        // M_icode, M_dstE, M_dstM, M_valE, M_valA, M_cnd, M_Stat);

        // $display("W pipe: W_stall = %0d", W_stall);
        // $display("W_ic = %d, W_dstE = %0d, W_dstM = %0d, E = %0d, M = %0d, W_St = %d\n", 
        // W_icode, W_dstE, W_dstM, W_valE, W_valM, W_Stat);

        // //cycle 14
        // #5 clk = !clk;
        // #5 $display("clk = %d", clk);
        // $display("Fetch block: F_stall = %0d", F_stall);
        // $display("currPr_Pc = %0d, f_ic = %d, f_if = %d, f_rA = %d, f_rB = %d, C = %0d, P = %0d, f_St = %d, f_prPc = %0d", 
        // predPC, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, f_Stat, f_predPC);

        // $display("Decode block: D_stall = %d, D_bubble = %0d", D_stall, D_bubble);
        // $display("d_ic = %d, d_if = %d, d_A = %0d, d_B = %0d, d_C = %0d, d_dstE = %0d, d_dstM = %d, d_srcA = %0d, d_srcB = %0d, d_St = %0d", 
        // d_icode, d_ifun, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);

        // $display("Execute block: E_bubble = %0d", E_bubble);
        // $display("e_cnd = %d, e_ic = %d, e_dstE = %0d, e_dstM = %0d, E = %0d, A = %0d, e_St = %d",
        // e_cnd, e_icode, e_dstE, e_dstM, e_valE, e_valA, e_Stat);

        // $display("Memory block: M_bubble = %0d", M_bubble);
        // $display("m_ic = %d, m_dstE = %0d, m_dstM = %0d, E = %0d, M = %0d, m_St = %d",
        // m_icode, m_dstE, m_dstM, m_valE, m_valM, m_Stat);

        // $display("WB block: W_stall = %0d", W_stall);
        // $display("d_ic = %d, d_if = %d, d_A = %0d, d_B = %0d, d_C = %0d, d_dstE = %0d, d_dstM = %d, d_srcA = %0d, d_srcB = %0d, d_St = %0d\n", 
        // d_icode, d_ifun, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);


        // #5 clk = !clk;
        // #5 $display("clk = %d", clk);
        // $display("F pipe: F_stall = %0d", F_stall);
        // // predPC = f_predPC;
        // $display("predicted PC = %0d", predPC);

        // $display("D pipe: D_stall = %0d, D_bubble = %0d", D_stall, D_bubble);
        // $display("D_ic = %d, D_if = %d, D_rA = %d, D_rB = %d, C = %0d, P = %0d, D_St = %d", 
        // D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, D_Stat);

        // $display("E pipe: E_bubble = %0d", E_bubble);
        // $display("E_ic = %d, E_if = %d, E_A = %0d, E_B = %0d, E_C = %0d, E_dstE = %0d, E_dstM = %d, E_srcA = %0d, E_srcB = %0d, E_St = %0d", 
        // E_icode, E_ifun, E_valA, E_valB, E_valC, E_dstE, E_dstM, E_srcA, E_srcB, E_Stat);

        // $display("M pipe: M_bubble = %0d", M_bubble);
        // $display("M_ic = %d, M_dstE = %0d, M_dstM = %0d, E = %0d, A = %0d, M_cnd = %d, M_St = %d", 
        // M_icode, M_dstE, M_dstM, M_valE, M_valA, M_cnd, M_Stat);

        // $display("W pipe: W_stall = %0d", W_stall);
        // $display("W_ic = %d, W_dstE = %0d, W_dstM = %0d, E = %0d, M = %0d, W_St = %d\n", 
        // W_icode, W_dstE, W_dstM, W_valE, W_valM, W_Stat);

        // //cycle 15
        // #5 clk = !clk;
        // #5 $display("clk = %d", clk);
        // $display("Fetch block: F_stall = %0d", F_stall);
        // $display("currPr_Pc = %0d, f_ic = %d, f_if = %d, f_rA = %d, f_rB = %d, C = %0d, P = %0d, f_St = %d, f_prPc = %0d", 
        // predPC, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, f_Stat, f_predPC);

        // $display("Decode block: D_stall = %d, D_bubble = %0d", D_stall, D_bubble);
        // $display("d_ic = %d, d_if = %d, d_A = %0d, d_B = %0d, d_C = %0d, d_dstE = %0d, d_dstM = %d, d_srcA = %0d, d_srcB = %0d, d_St = %0d", 
        // d_icode, d_ifun, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);

        // $display("Execute block: E_bubble = %0d", E_bubble);
        // $display("e_cnd = %d, e_ic = %d, e_dstE = %0d, e_dstM = %0d, E = %0d, A = %0d, e_St = %d",
        // e_cnd, e_icode, e_dstE, e_dstM, e_valE, e_valA, e_Stat);

        // $display("Memory block: M_bubble = %0d", M_bubble);
        // $display("m_ic = %d, m_dstE = %0d, m_dstM = %0d, E = %0d, M = %0d, m_St = %d",
        // m_icode, m_dstE, m_dstM, m_valE, m_valM, m_Stat);

        // $display("WB block: W_stall = %0d", W_stall);
        // $display("d_ic = %d, d_if = %d, d_A = %0d, d_B = %0d, d_C = %0d, d_dstE = %0d, d_dstM = %d, d_srcA = %0d, d_srcB = %0d, d_St = %0d\n", 
        // d_icode, d_ifun, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);


        // #5 clk = !clk;
        // #5 $display("clk = %d", clk);
        // $display("F pipe: F_stall = %0d", F_stall);
        // // predPC = f_predPC;
        // $display("predicted PC = %0d", predPC);

        // $display("D pipe: D_stall = %0d, D_bubble = %0d", D_stall, D_bubble);
        // $display("D_ic = %d, D_if = %d, D_rA = %d, D_rB = %d, C = %0d, P = %0d, D_St = %d", 
        // D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, D_Stat);

        // $display("E pipe: E_bubble = %0d", E_bubble);
        // $display("E_ic = %d, E_if = %d, E_A = %0d, E_B = %0d, E_C = %0d, E_dstE = %0d, E_dstM = %d, E_srcA = %0d, E_srcB = %0d, E_St = %0d", 
        // E_icode, E_ifun, E_valA, E_valB, E_valC, E_dstE, E_dstM, E_srcA, E_srcB, E_Stat);

        // $display("M pipe: M_bubble = %0d", M_bubble);
        // $display("M_ic = %d, M_dstE = %0d, M_dstM = %0d, E = %0d, A = %0d, M_cnd = %d, M_St = %d", 
        // M_icode, M_dstE, M_dstM, M_valE, M_valA, M_cnd, M_Stat);

        // $display("W pipe: W_stall = %0d", W_stall);
        // $display("W_ic = %d, W_dstE = %0d, W_dstM = %0d, E = %0d, M = %0d, W_St = %d\n", 
        // W_icode, W_dstE, W_dstM, W_valE, W_valM, W_Stat);

        // //cycle 16
        // #5 clk = !clk;
        // #5 $display("clk = %d", clk);
        // $display("Fetch block: F_stall = %0d", F_stall);
        // $display("currPr_Pc = %0d, f_ic = %d, f_if = %d, f_rA = %d, f_rB = %d, C = %0d, P = %0d, f_St = %d, f_prPc = %0d", 
        // predPC, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, f_Stat, f_predPC);

        // $display("Decode block: D_stall = %d, D_bubble = %0d", D_stall, D_bubble);
        // $display("d_ic = %d, d_if = %d, d_A = %0d, d_B = %0d, d_C = %0d, d_dstE = %0d, d_dstM = %d, d_srcA = %0d, d_srcB = %0d, d_St = %0d", 
        // d_icode, d_ifun, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);

        // $display("Execute block: E_bubble = %0d", E_bubble);
        // $display("e_cnd = %d, e_ic = %d, e_dstE = %0d, e_dstM = %0d, E = %0d, A = %0d, e_St = %d",
        // e_cnd, e_icode, e_dstE, e_dstM, e_valE, e_valA, e_Stat);

        // $display("Memory block: M_bubble = %0d", M_bubble);
        // $display("m_ic = %d, m_dstE = %0d, m_dstM = %0d, E = %0d, M = %0d, m_St = %d",
        // m_icode, m_dstE, m_dstM, m_valE, m_valM, m_Stat);

        // $display("WB block: W_stall = %0d", W_stall);
        // $display("d_ic = %d, d_if = %d, d_A = %0d, d_B = %0d, d_C = %0d, d_dstE = %0d, d_dstM = %d, d_srcA = %0d, d_srcB = %0d, d_St = %0d\n", 
        // d_icode, d_ifun, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);


        // #5 clk = !clk;
        // #5 $display("clk = %d", clk);
        // $display("F pipe: F_stall = %0d", F_stall);
        // // predPC = f_predPC;
        // $display("predicted PC = %0d", predPC);

        // $display("D pipe: D_stall = %0d, D_bubble = %0d", D_stall, D_bubble);
        // $display("D_ic = %d, D_if = %d, D_rA = %d, D_rB = %d, C = %0d, P = %0d, D_St = %d", 
        // D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, D_Stat);

        // $display("E pipe: E_bubble = %0d", E_bubble);
        // $display("E_ic = %d, E_if = %d, E_A = %0d, E_B = %0d, E_C = %0d, E_dstE = %0d, E_dstM = %d, E_srcA = %0d, E_srcB = %0d, E_St = %0d", 
        // E_icode, E_ifun, E_valA, E_valB, E_valC, E_dstE, E_dstM, E_srcA, E_srcB, E_Stat);

        // $display("M pipe: M_bubble = %0d", M_bubble);
        // $display("M_ic = %d, M_dstE = %0d, M_dstM = %0d, E = %0d, A = %0d, M_cnd = %d, M_St = %d", 
        // M_icode, M_dstE, M_dstM, M_valE, M_valA, M_cnd, M_Stat);

        // $display("W pipe: W_stall = %0d", W_stall);
        // $display("W_ic = %d, W_dstE = %0d, W_dstM = %0d, E = %0d, M = %0d, W_St = %d\n", 
        // W_icode, W_dstE, W_dstM, W_valE, W_valM, W_Stat);

        // //cycle 17
        // #5 clk = !clk;
        // #5 $display("clk = %d", clk);
        // $display("Fetch block: F_stall = %0d", F_stall);
        // $display("currPr_Pc = %0d, f_ic = %d, f_if = %d, f_rA = %d, f_rB = %d, C = %0d, P = %0d, f_St = %d, f_prPc = %0d", 
        // predPC, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, f_Stat, f_predPC);

        // $display("Decode block: D_stall = %d, D_bubble = %0d", D_stall, D_bubble);
        // $display("d_ic = %d, d_if = %d, d_A = %0d, d_B = %0d, d_C = %0d, d_dstE = %0d, d_dstM = %d, d_srcA = %0d, d_srcB = %0d, d_St = %0d", 
        // d_icode, d_ifun, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);

        // $display("Execute block: E_bubble = %0d", E_bubble);
        // $display("e_cnd = %d, e_ic = %d, e_dstE = %0d, e_dstM = %0d, E = %0d, A = %0d, e_St = %d",
        // e_cnd, e_icode, e_dstE, e_dstM, e_valE, e_valA, e_Stat);

        // $display("Memory block: M_bubble = %0d", M_bubble);
        // $display("m_ic = %d, m_dstE = %0d, m_dstM = %0d, E = %0d, M = %0d, m_St = %d",
        // m_icode, m_dstE, m_dstM, m_valE, m_valM, m_Stat);

        // $display("WB block: W_stall = %0d", W_stall);
        // $display("d_ic = %d, d_if = %d, d_A = %0d, d_B = %0d, d_C = %0d, d_dstE = %0d, d_dstM = %d, d_srcA = %0d, d_srcB = %0d, d_St = %0d\n", 
        // d_icode, d_ifun, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);


        // #5 clk = !clk;
        // #5 $display("clk = %d", clk);
        // $display("F pipe: F_stall = %0d", F_stall);
        // // predPC = f_predPC;
        // $display("predicted PC = %0d", predPC);

        // $display("D pipe: D_stall = %0d, D_bubble = %0d", D_stall, D_bubble);
        // $display("D_ic = %d, D_if = %d, D_rA = %d, D_rB = %d, C = %0d, P = %0d, D_St = %d", 
        // D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, D_Stat);

        // $display("E pipe: E_bubble = %0d", E_bubble);
        // $display("E_ic = %d, E_if = %d, E_A = %0d, E_B = %0d, E_C = %0d, E_dstE = %0d, E_dstM = %d, E_srcA = %0d, E_srcB = %0d, E_St = %0d", 
        // E_icode, E_ifun, E_valA, E_valB, E_valC, E_dstE, E_dstM, E_srcA, E_srcB, E_Stat);

        // $display("M pipe: M_bubble = %0d", M_bubble);
        // $display("M_ic = %d, M_dstE = %0d, M_dstM = %0d, E = %0d, A = %0d, M_cnd = %d, M_St = %d", 
        // M_icode, M_dstE, M_dstM, M_valE, M_valA, M_cnd, M_Stat);

        // $display("W pipe: W_stall = %0d", W_stall);
        // $display("W_ic = %d, W_dstE = %0d, W_dstM = %0d, E = %0d, M = %0d, W_St = %d\n", 
        // W_icode, W_dstE, W_dstM, W_valE, W_valM, W_Stat);

        // //cycle 18 
        // #5 clk = !clk;
        // #5 $display("clk = %d", clk);
        // $display("Fetch block: F_stall = %0d", F_stall);
        // $display("currPr_Pc = %0d, f_ic = %d, f_if = %d, f_rA = %d, f_rB = %d, C = %0d, P = %0d, f_St = %d, f_prPc = %0d", 
        // predPC, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, f_Stat, f_predPC);

        // $display("Decode block: D_stall = %d, D_bubble = %0d", D_stall, D_bubble);
        // $display("d_ic = %d, d_if = %d, d_A = %0d, d_B = %0d, d_C = %0d, d_dstE = %0d, d_dstM = %d, d_srcA = %0d, d_srcB = %0d, d_St = %0d", 
        // d_icode, d_ifun, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);

        // $display("Execute block: E_bubble = %0d", E_bubble);
        // $display("e_cnd = %d, e_ic = %d, e_dstE = %0d, e_dstM = %0d, E = %0d, A = %0d, e_St = %d",
        // e_cnd, e_icode, e_dstE, e_dstM, e_valE, e_valA, e_Stat);

        // $display("Memory block: M_bubble = %0d", M_bubble);
        // $display("m_ic = %d, m_dstE = %0d, m_dstM = %0d, E = %0d, M = %0d, m_St = %d",
        // m_icode, m_dstE, m_dstM, m_valE, m_valM, m_Stat);

        // $display("WB block: W_stall = %0d", W_stall);
        // $display("d_ic = %d, d_if = %d, d_A = %0d, d_B = %0d, d_C = %0d, d_dstE = %0d, d_dstM = %d, d_srcA = %0d, d_srcB = %0d, d_St = %0d\n", 
        // d_icode, d_ifun, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_Stat);


        // #5 clk = !clk;
        // #5 $display("clk = %d", clk);
        // $display("F pipe: F_stall = %0d", F_stall);
        // // predPC = f_predPC;
        // $display("predicted PC = %0d", predPC);

        // $display("D pipe: D_stall = %0d, D_bubble = %0d", D_stall, D_bubble);
        // $display("D_ic = %d, D_if = %d, D_rA = %d, D_rB = %d, C = %0d, P = %0d, D_St = %d", 
        // D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, D_Stat);

        // $display("E pipe: E_bubble = %0d", E_bubble);
        // $display("E_ic = %d, E_if = %d, E_A = %0d, E_B = %0d, E_C = %0d, E_dstE = %0d, E_dstM = %d, E_srcA = %0d, E_srcB = %0d, E_St = %0d", 
        // E_icode, E_ifun, E_valA, E_valB, E_valC, E_dstE, E_dstM, E_srcA, E_srcB, E_Stat);

        // $display("M pipe: M_bubble = %0d", M_bubble);
        // $display("M_ic = %d, M_dstE = %0d, M_dstM = %0d, E = %0d, A = %0d, M_cnd = %d, M_St = %d", 
        // M_icode, M_dstE, M_dstM, M_valE, M_valA, M_cnd, M_Stat);

        // $display("W pipe: W_stall = %0d", W_stall);
        // $display("W_ic = %d, W_dstE = %0d, W_dstM = %0d, E = %0d, M = %0d, W_St = %d\n", 
        // W_icode, W_dstE, W_dstM, W_valE, W_valM, W_Stat);

        // #10 $finish;
    end
endmodule