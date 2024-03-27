module write_back_tb;

reg [63:0] PC;

reg clk, cnd;
reg write_enable;
reg [3:0] rA, rB;
reg [3:0] icode, ifun;
reg [63:0] valE, valM;
reg [63:0] valP, valC;

wire [63:0] valA, valB;
wire reg_error;
wire [63:0] PC_updated;

decode_reg_block dut(clk, cnd, icode, ifun, rA, rB, write_enable, valE, valM, valP, valC, valA, valB, PC_updated, reg_error);

initial
begin
    $dumpfile("write_back_out.vcd");
    $dumpvars(0, write_back_tb);
    $monitor("icode = %d, ifun = %d, rA = %d, rB = %d, we = %d, E = %0d, M = %0d, P = %0d, C = %0d, A = %0d, B = %0d, P_up = %0d, PC = %0d", 
    icode, ifun, rA, rB, write_enable, valE, valM, valP, valC, valA, valB, PC_updated, PC);
    
    #20 clk = 0;
    write_enable = 1;
    
    #20 clk = !clk; //clk -> 1 : ready to write back
    icode = 0; ifun = 0;
    rA = 4; rB = 7; 
    valE = 10; valM = 12;
    valP = 69;
    write_enable = 0;
    PC = PC_updated;

    #20 clk = !clk; //clk -> 0 : registers updated
    write_enable = 1;

    #20 clk = !clk; //clk -> 1 : ready to write back
    icode = 1; ifun = 0;
    rA = 3; rB = 5; 
    valE = 114; valM = 102;
    valP = 68;
    write_enable = 0;
    PC = PC_updated;

    #20 clk = !clk; //clk -> 0 : registers updated
    write_enable = 1;

    #20 clk = !clk; //clk -> 1 : ready to write back
    icode = 2; ifun = 0;
    rA = 9; rB = 12; 
    valE = 109; valM = 120;
    valP = 67;
    write_enable = 0;
    PC = PC_updated;

    #20 clk = !clk; //clk -> 0 : registers updated
    write_enable = 1;

    #20 clk = !clk; //clk -> 1 : ready to write back
    icode = 2; ifun = 3;
    rA = 12; rB = 14;
    valE = 137; valM = 192; 
    valP = 66;
    write_enable = 0;
    PC = PC_updated;

    #20 clk = !clk; //clk -> 0 : registers updated
    write_enable = 1;

    #20 clk = !clk; //clk -> 1 : ready to write back
    icode = 3; ifun = 0;
    rA = 3; rB = 14;
    valE = 100; valM = 912; 
    valP = 65;
    write_enable = 0;
    PC = PC_updated;

    #20 clk = !clk; //clk -> 0 : registers updated
    write_enable = 1;

    #20 clk = !clk; //clk -> 1 : ready to write back
    icode = 4; ifun = 0;
    rA = 13; rB = 10; 
    valE = 31; valM = 702;
    valP = 64;
    write_enable = 0;
    PC = PC_updated;

    #20 clk = !clk; //clk -> 0 : registers updated
    write_enable = 1;

    #20 clk = !clk; //clk -> 1 : ready to write back
    icode = 5; ifun = 0;
    rA = 1; rB = 6; 
    valE = 19; valM = 52;
    valP = 63;
    write_enable = 0;
    PC = PC_updated;

    #20 clk = !clk; //clk -> 0 : registers updated
    write_enable = 1;

    #20 clk = !clk; //clk -> 1 : ready to write back
    icode = 6; ifun = 0;
    rA = 2; rB = 11; 
    valE = 15; valM = 732;
    valP = 62;
    write_enable = 0;
    PC = PC_updated;

    #20 clk = !clk; //clk -> 0 : registers updated
    write_enable = 1;

    #20 clk = !clk; //clk -> 1 : ready to write back
    icode = 7; ifun = 0;
    rA = 4; rB = 7; 
    valE = 1; valM = 72;
    valP = 61;
    write_enable = 0;
    PC = PC_updated;

    #20 clk = !clk; //clk -> 0 : registers updated
    write_enable = 1;

    #20 clk = !clk; //clk -> 1 : ready to write back
    icode = 10; ifun = 0;
    rA = 4; rB = 7; 
    valE = 1; valM = 72;
    write_enable = 0;
    PC = PC_updated;

    #20 clk = !clk; //clk -> 0 : registers updated
    write_enable = 1;

    #20 clk = !clk; //clk -> 1 : ready to write back
    icode = 11; ifun = 0;
    rA = 4; rB = 7; 
    valE = 1; valM = 92;
    write_enable = 0;

    #20 clk = !clk; //clk -> 0 : registers updated
    write_enable = 1;

    #20 clk = !clk; //clk -> 1 : ready to write back
    icode = 20; ifun = 0;
    rA = 4; rB = 7; 
    valE = 1; valM = 72;
    write_enable = 0;

    #20 clk = !clk; //clk -> 0 : registers updated
    write_enable = 1;

    #20 $finish;

end
endmodule
