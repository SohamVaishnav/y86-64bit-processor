module memory_tb;
    reg [63:0] valC, valP, valA, valB;
    reg [63:0] valE;
    reg [3:0] icode, ifun;
    reg clk;

    wire signed [63:0] valM;
    wire dmem_error;

    memory M(clk, icode, ifun, valA, valB, valC, valP, valE, valM, dmem_error);

    initial begin 
        $dumpfile("memory_out.vcd");
        $dumpvars(0, memory_tb);
        $monitor("icode = %0d, ifun = %0d, valA = %0d, valB = %0d, valC = %0d, valE = %0d, valP = %0d, valM = %0d, dmem_error = %0d", 
        icode, ifun, valA, valB, valC, valE, valP, valM, dmem_error);

        clk = 0; //0

        #20 clk = !clk; //1
        icode = 3; ifun = 0;
        valA = 64'bx; valB = 15;
        valC = 1; valP = 10;
        valE = 1;

        #20 clk = !clk; //0

        #20 clk = !clk; //1
        icode = 2; ifun = 0;
        valA = 1; valB = 14;
        valC = 1; valP = 12;
        valE = 1;

        #20 clk = !clk; //0
        // PC = valP;

        #20 clk = !clk; //1
        icode = 6; ifun = 0;
        valA = 1; valB = 1;
        valC = 1; valP = 14;
        valE = 2;

        #20 clk = !clk; //0
        // PC = valP;

        #20 clk = !clk; //1
        icode = 8; ifun = 0;
        valA = 2047; valB = 2047;
        valC = 25; valP = 23;
        valE = 2039;

        #20 clk = !clk; //0
        // PC = valP;

        #20 clk = !clk; //1
        icode = 10; ifun = 0;
        valA = 2; valB = 2039;
        valC = 1; valP = 27;
        valE = 2031;

        #20 clk = !clk; //0
        // PC = valP;

        #20 clk = !clk; //1
        icode = 9; ifun = 0;
        valA = 2031; valB = 2031;
        valC = 2; valP = 28;
        valE = 2039;

        #20 clk = !clk; //0
        // PC = valP;

        #20 clk = !clk; //1
        icode = 11; ifun = 0;
        valA = 2039; valB = 2039;
        valC = 2; valP = valM;
        valE = 2047;

        #20 clk = !clk; //0
        // PC = valP;

        #20 clk = !clk; //1

        #20 clk = !clk; //0
        // PC = valP;

        #20 clk = !clk; //1

        #20 clk = !clk; //0
        // PC = valP;

        #20 clk = !clk; //1

        #20 clk = !clk; //0
        // PC = valP;

        #20 $finish;
    end
endmodule