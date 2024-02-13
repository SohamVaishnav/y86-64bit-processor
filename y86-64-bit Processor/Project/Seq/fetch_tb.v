module fetch_tb;
    reg [63:0] PC;
    reg clk;

    wire [3:0] icode;
    wire [3:0] ifun;
    wire [3:0] rA;
    wire [3:0] rB;
    wire [63:0] valC;
    wire [63:0] valP;
    wire imem_error;
    wire func_error;
    wire halt, nop;

    fetch M(PC, clk, icode, ifun, rA, rB, valC, valP, imem_error, func_error, halt, nop);

    initial 
    begin 
        $dumpfile("fetch_out.vcd");
        $dumpvars(0, fetch_tb);
        $monitor("halt = %d, nop = %d, PC = %0d, icode = %0d, ifun = %d, rA = %d, rB = %0d, valc = %0d, valp = %0d", 
        halt, nop, PC, icode, ifun, rA, rB, valC, valP);

        #20 clk = 0;

        #20 clk = !clk;
        PC = 0;

        #20 clk = !clk;
        PC = 1;

        #20 clk = !clk;
        PC = 1024;

        #20 $finish;
    end
endmodule