module fetch_pipe_tb;
    reg clk;
    reg [63:0] predPC;
    reg [63:0] M_valA, W_valM;
    reg [3:0] M_icode, W_icode;
    reg M_cnd;

    wire [63:0] f_predPC, f_valC, f_valP;
    wire [3:0] f_icode, f_ifun, f_Stat;
    wire [3:0] f_rA, f_rB;

    
    fetch_pipe f(predPC, M_Cnd, M_icode, W_icode, W_valM, M_valA,
    f_icode, f_ifun, f_rA, f_rB, f_Stat, f_valC, f_valP, f_predPC);

    always @ (posedge clk) begin 
        predPC = f_predPC;
    end

    initial 
    begin 
        $dumpfile("f_out.vcd");
        $dumpvars(0, fetch_pipe_tb);
        clk = 0;
        predPC = 0;
        M_icode = 0;
        W_icode = 0; W_valM = 0;
        M_valA = 0;
        #5 $display("clk = %b, fic = %0d, fif = %0d, frA = %0d, frb = %0d, C = %0d, P = %0d, f_predPC = %0d, f_Stat = %0d\n", 
        clk, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, f_predPC, f_Stat);

        #5 clk = !clk;
        #5 $display("clk = %b, predicted Pc = %0d\n", clk, predPC);

        #5 clk = !clk;
        M_icode = 0;
        W_icode = 0; W_valM = 0;
        M_valA = 0;
        #5 $display("clk = %b, fic = %0d, fif = %0d, frA = %0d, frb = %0d, C = %0d, P = %0d, f_predPC = %0d, f_Stat = %0d\n", 
        clk, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, f_predPC, f_Stat);

        #5 clk = !clk;
        #5 $display("clk = %b, predicted Pc = %0d\n", clk, predPC);

        #5 clk = !clk;
        M_icode = 0;
        W_icode = 0; W_valM = 0;
        M_valA = 0;
        #5 $display("clk = %b, fic = %0d, fif = %0d, frA = %0d, frb = %0d, C = %0d, P = %0d, f_predPC = %0d, f_Stat = %0d\n", 
        clk, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, f_predPC, f_Stat);

        #5 clk = !clk;
        #5 $display("clk = %b, predicted Pc = %0d\n", clk, predPC);

        #5 clk = !clk;
        M_icode = 3;
        W_icode = 0; W_valM = 0;
        M_valA = 15;
        #5 $display("clk = %b, fic = %0d, fif = %0d, frA = %0d, frb = %0d, C = %0d, P = %0d, f_predPC = %0d, f_Stat = %0d\n", 
        clk, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, f_predPC, f_Stat);

        #5 clk = !clk;
        #5 $display("clk = %b, predicted Pc = %0d\n", clk, predPC);

        #5 clk = !clk;
        M_icode = 2;
        W_icode = 3; W_valM = 0;
        M_valA = 15;
        #5 $display("clk = %b, fic = %0d, fif = %0d, frA = %0d, frb = %0d, C = %0d, P = %0d, f_predPC = %0d, f_Stat = %0d\n", 
        clk, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, f_predPC, f_Stat);

        #5 clk = !clk;
        #5 $display("clk = %b, predicted Pc = %0d\n", clk, predPC);

        #5 clk = !clk;
        M_icode = 6;
        W_icode = 2; W_valM = 0;
        M_valA = 2;
        #5 $display("clk = %b, fic = %0d, fif = %0d, frA = %0d, frb = %0d, C = %0d, P = %0d, f_predPC = %0d, f_Stat = %0d\n", 
        clk, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, f_predPC, f_Stat);

        #5 clk = !clk;
        #5 $display("clk = %b, predicted Pc = %0d\n", clk, predPC);

        #5 clk = !clk;
        M_icode = 8;
        W_icode = 6; W_valM = 0;
        M_valA = f_valP;
        #5 $display("clk = %b, fic = %0d, fif = %0d, frA = %0d, frb = %0d, C = %0d, P = %0d, f_predPC = %0d, f_Stat = %0d\n", 
        clk, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, f_predPC, f_Stat);

        #5 clk = !clk;
        #5 $display("clk = %b, predicted Pc = %0d\n", clk, predPC);

        #5 clk = !clk;
        M_icode = 10;
        W_icode = 8; W_valM = 0;
        M_valA = 4;
        #5 $display("clk = %b, fic = %0d, fif = %0d, frA = %0d, frb = %0d, C = %0d, P = %0d, f_predPC = %0d, f_Stat = %0d\n", 
        clk, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, f_predPC, f_Stat);

        #5 clk = !clk;
        #5 $display("clk = %b, predicted Pc = %0d\n", clk, predPC);

        #5 clk = !clk;
        M_icode = 9;
        W_icode = 10; W_valM = 0;
        M_valA = 4;
        #5 $display("clk = %b, fic = %0d, fif = %0d, frA = %0d, frb = %0d, C = %0d, P = %0d, f_predPC = %0d, f_Stat = %0d\n", 
        clk, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, f_predPC, f_Stat);

        #5 clk = !clk;
        #5 $display("clk = %b, predicted Pc = %0d\n", clk, predPC);

        #5 clk = !clk;
        M_icode = 11;
        W_icode = 9; W_valM = 4;
        M_valA = 2;
        #5 $display("clk = %b, fic = %0d, fif = %0d, frA = %0d, frb = %0d, C = %0d, P = %0d, f_predPC = %0d, f_Stat = %0d\n", 
        clk, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, f_predPC, f_Stat);

        #5 clk = !clk;
        #5 $display("clk = %b, predicted Pc = %0d\n", clk, predPC);
    end
endmodule 