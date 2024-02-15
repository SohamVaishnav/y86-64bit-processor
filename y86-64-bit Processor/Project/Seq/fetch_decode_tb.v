module fetch_decode_tb;

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
    wire [63:0] valA, valB;
    wire reg_error;

    reg write_enable;

    // reg [63:0] storage [14:0];

fetch f1(.icode(icode),.ifun(ifun),.rA(rA),.rB(rB),.valC(valC),.valP(valP),.imem_error(imem_error),.func_error(func_error),.halt(halt),.nop(nop),.clk(clk),.PC(PC));

decode_reg_block d1(clk, icode, ifun, rA, rB, 1'b0, 64'bx, 64'bx, valA, valB, reg_error);

initial
begin
    $dumpfile("out.vcd");
    $dumpvars(0, fetch_decode_tb);
    $monitor("clk = %d, ra = %d, rb = %d, PC = %0d, icode = %d, ifun = %d, write = %d, A = %0d, B = %0d",
    clk, rA, rB, PC, icode, ifun, write_enable, valA, valB);
        #20 clk = 0;
        write_enable = 0;

        #20 clk = !clk;
        PC = 0;

        #20 clk = !clk;
        PC = 1;

        #20 clk = !clk;
        PC = 1024;

        #20 $finish;

end


endmodule
