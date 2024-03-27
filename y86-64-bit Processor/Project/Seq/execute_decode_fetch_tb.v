module execute_decode_fetch_tb;

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
    wire [63:0] valA,valB;
    wire [63:0] PC_updated;

    reg write_enable;
    wire reg_error;
    wire [63:0] valE;
    wire cnd, SF, ZF, OF;


fetch f1(.icode(icode),.ifun(ifun),.rA(rA),.rB(rB),.valC(valC),.valP(valP),.imem_error(imem_error),.func_error(func_error),.halt(halt),.nop(nop),.clk(clk),.PC(PC));

decode_reg_block d1(clk, 1'b0, icode, ifun, rA, rB, 1'b0, valE, 64'bx, valP, valC, valA, valB, PC_updated, reg_error);

execute_block e1(.vala(valA),.valb(valB),.valc(valC),.icode(icode),.ifun(ifun),.vale(valE),.cnd(cnd),.SF(SF),.ZF(ZF),.OF(OF));

initial
begin
    
    $monitor("ra = %d, rb = %d, PC = %0d, icode = %d, ifun = %d, E = %0d , SF = %d, ZF = %d, OF = %d", rA, rB, PC, icode, ifun,valE,SF,ZF,OF);
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

