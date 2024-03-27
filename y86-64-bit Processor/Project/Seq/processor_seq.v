`include "fetch.v"
`include "decode_reg_block.v"
`include "execute_block.v"
`include "memory.v"

module memory_execute_decode_fetch_tb;
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

    reg reg_write_enable;
    reg mem_write_enable;
    wire dmem_error;
    wire reg_error;
    wire [63:0] valE, valM;
    wire cnd, SF, ZF, OF;

    reg [3:0] Stat; // AOK:ADR:INS:HLT

fetch f1(.PC(PC),.icode(icode),.ifun(ifun),.rA(rA),.rB(rB),.valC(valC),.valP(valP),.imem_error(imem_error),.func_error(func_error),.clk(clk));

decode_reg_block d1(clk, cnd, icode, ifun, rA, rB, reg_write_enable, valE, valM, valP, valC, valA, valB, PC_updated, reg_error);

execute_block e1(.vala(valA),.valb(valB),.valc(valC),.icode(icode),.ifun(ifun),.vale(valE),.cnd(cnd),.SF(SF),.ZF(ZF),.OF(OF));

memory m1(clk, icode, ifun, valA, valB, valC, valP, valE, valM, dmem_error);

decode_reg_block wb1(clk, cnd, icode, ifun, rA, rB, reg_write_enable, valE, valM, valP, valC, valA, valB, PC_updated, reg_error);

always @(*) begin 
    if (icode == 4'b0000) begin 
        Stat = 4'b0001;
    end
    else if (imem_error == 1 || dmem_error == 1) begin 
        $display("Error! Invalid addressing.\n");
        Stat = 4'b0100;
    end
    else if (func_error == 1) begin 
        $display("Error! Invalid instruction.\n");
        Stat = 4'b0010;
    end
end

always @ (*) begin 
    // $display("Stat = %d", Stat);
    if (Stat == 4'b0001) begin 
        $display("Halt instruction encountered!\n");
        $finish;
    end
    if (Stat == 4'b0010) begin 
        $display("Halted due to invalid instruction!\n");
        $finish;
    end
    if (Stat == 4'b0100) begin 
        $display("Halted due to invalid addressing!\n");
        $finish;
    end
end

always begin         
    #0.50 clk = !clk;
end

always @ (posedge clk) begin 
    reg_write_enable = 0;
end

always @ (PC_updated) begin 
    PC = PC_updated;
end

always @ (negedge clk) begin 
    reg_write_enable = 1;
end

initial
begin
    $dumpfile("medf_out.vcd");
    $dumpvars(0, memory_execute_decode_fetch_tb);
    $monitor("ra = %d, rb = %d, icode = %d, ifun = %d, A = %0d, B = %0d, E = %0d, M = %0d, PC = %0d, dme = %d, fe = %d, ime = %d, cnd = %d", 
    rA, rB, icode, ifun,valA,valB,valE,valM,PC,dmem_error, func_error, imem_error,cnd);

        Stat = 4'b1000;

        clk = 0;
        reg_write_enable = 1;
        
        // #0.50 clk = 1;
        // reg_write_enable = 0;
        PC = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0; 

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0; 

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0; 

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0; 

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #0.50 clk = 0;
        // // PC = PC_updated;
        // reg_write_enable = 1;

        // #0.50 clk = 1;
        // PC = PC_updated;
        // reg_write_enable = 0;

        // #50 $finish;
end
endmodule

