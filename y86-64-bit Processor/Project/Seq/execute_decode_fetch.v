module execute_decode_fetch_tb;

reg [63:0] PC;
    reg clk;

    wire [3:0] icode;
    wire [3:0] ifun;
    wire [3:0] rA;
    wire [3:0] rB;
    wire [63:0] valC;
    wire [63:0] valP;
    wire mem_error;
    wire func_error;
    wire halt, nop;
    wire [63:0] valA,valB;

    reg write;
    wire [3:0] data_in;
    wire err;
    wire [62:0] vale;
    wire cnd,SF,ZF,OF;


fetch f1(.icode(icode),.ifun(ifun),.rA(rA),.rB(rB),.valC(valC),.valP(valP),.mem_error(mem_error),.func_error(func_error),.halt(halt),.nop(nop),.clk(clk),.PC(PC));

decode_reg_block d1(.ra(rA),.rb(rB),.vala(valA),.valb(valB),.write(write),.err(err),.data_in(data_in));

execute_block e1(.vala(valA),.valb(valB),.valc(valC),.icode(icode),.ifun(ifun),.vale(vale),.cnd(cnd),.SF(SF),.ZF(ZF),.OF(OF));

initial
begin
    
    $monitor("ra = %d, rb = %d, PC = %0d, icode = %d, ifun = %d, write = %d ", rA, rB, PC, icode, ifun, write);
    #20 clk = 0;
    write = 0;

        #20 clk = !clk;
        PC = 0;

        #20 clk = !clk;
        PC = 1;

        #20 clk = !clk;
        PC = 1024;

        #20 $finish;

end


endmodule

