module PC_update_tb;
    reg clk, halt, nop;
    reg [63:0] valP, valC, valM;
    reg [3:0] icode, ifun;
    reg cnd;

    wire [63:0] PC_updated;

    PC_update M(clk, halt, nop, icode, ifun, valP, valC, valM, cnd, PC_updated);

    initial begin 
        $dumpfile("PC_update_out.vcd");
        $dumpvars(0, PC_update_tb);
        $monitor("clk = %d, icode = %d, ifun = %d, P = %0d, C = %0d, M = %0d, cnd = %d, Pup = %0d", 
        clk, icode, ifun, valP, valC, valM, cnd, PC_updated);

        #20 clk = 0; // clk -> initiated 

        #20 clk = !clk; // clk -> 1 : PC ready to get updated 
        icode = 0; ifun = 0;
        valP = 10; valC = 11; valM = 12;
        cnd = 1;

        #20 clk = !clk; // clk -> 0 : PC updated 

        #20 clk = !clk; // clk -> 1 : PC ready to get updated 
        icode = 1; ifun = 0;
        valP = 10; valC = 11; valM = 12;
        cnd = 0;

        #20 clk = !clk; // clk -> 0 : PC updated 

        #20 clk = !clk; // clk -> 1 : PC ready to get updated 
        icode = 2; ifun = 0;
        valP = 10; valC = 11; valM = 12;
        cnd = 1;

        #20 clk = !clk; // clk -> 0 : PC updated 

        #20 clk = !clk; // clk -> 1 : PC ready to get updated 
        icode = 3; ifun = 0;
        valP = 10; valC = 11; valM = 12;
        cnd = 0;

        #20 clk = !clk; // clk -> 0 : PC updated 

        #20 clk = !clk; // clk -> 1 : PC ready to get updated 
        icode = 4; ifun = 0;
        valP = 10; valC = 11; valM = 12;
        cnd = 1;

        #20 clk = !clk; // clk -> 0 : PC updated 

        #20 clk = !clk; // clk -> 1 : PC ready to get updated 
        icode = 5; ifun = 0;
        valP = 10; valC = 11; valM = 12;
        cnd = 0;

        #20 clk = !clk; // clk -> 0 : PC updated 

        #20 clk = !clk; // clk -> 1 : PC ready to get updated 
        icode = 6; ifun = 0;
        valP = 10; valC = 11; valM = 12;
        cnd = 1;

        #20 clk = !clk; // clk -> 0 : PC updated 

        #20 clk = !clk; // clk -> 1 : PC ready to get updated 
        icode = 7; ifun = 0;
        valP = 10; valC = 11; valM = 12;
        cnd = 1;

        #20 clk = !clk; // clk -> 0 : PC updated 

        #20 clk = !clk; // clk -> 1 : PC ready to get updated 
        icode = 7; ifun = 1;
        valP = 10; valC = 11; valM = 12;
        cnd = 0;

        #20 clk = !clk; // clk -> 0 : PC updated 

        #20 clk = !clk; // clk -> 1 : PC ready to get updated 
        icode = 7; ifun = 2;
        valP = 10; valC = 11; valM = 12;
        cnd = 1;

        #20 clk = !clk; // clk -> 0 : PC updated

        #20 clk = !clk; // clk -> 1 : PC ready to get updated 
        icode = 8; ifun = 0;
        valP = 10; valC = 11; valM = 12;
        cnd = 0;

        #20 clk = !clk; // clk -> 0 : PC updated 

        #20 clk = !clk; // clk -> 1 : PC ready to get updated 
        icode = 9; ifun = 0;
        valP = 10; valC = 11; valM = 12;
        cnd = 1;

        #20 clk = !clk; // clk -> 0 : PC updated

        #20 clk = !clk; // clk -> 1 : PC ready to get updated 
        icode = 10; ifun = 2;
        valP = 10; valC = 11; valM = 12;
        cnd = 0;

        #20 clk = !clk; // clk -> 0 : PC updated

        #20 clk = !clk; // clk -> 1 : PC ready to get updated 
        icode = 11; ifun = 0;
        valP = 10; valC = 11; valM = 12;
        cnd = 1;

        #20 clk = !clk; // clk -> 0 : PC updated

    end
endmodule