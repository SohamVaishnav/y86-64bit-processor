module write_back_tb;

reg clk;
reg write_enable;
reg [3:0] rA, rB;
reg [3:0] icode, ifun;
reg [63:0] valE, valM;

wire [63:0] valA, valB;
wire reg_error;

decode_reg_block dut(clk, icode, ifun, rA, rB, write_enable, valE, valM, valA, valB, reg_error);

initial
begin
    $dumpfile("write_back_out.vcd");
    $dumpvars(0, write_back_tb);
    $monitor("icode = %d, ifun = %d, rA = %d, rB = %d, we = %d, E = %0d, M = %0d, A = %0d, B = %0d", 
    icode, ifun, rA, rB, write_enable, valE, valM, valA, valB);
    
    #20 clk = 0;
    write_enable = 1;
    
    #20 clk = !clk; //clk -> 1 : ready to write back
    icode = 0; ifun = 0;
    rA = 4; rB = 7; 
    valE = 10; valM = 12;
    write_enable = 0;

    #20 clk = !clk; //clk -> 0 : registers updated
    write_enable = 1;

    #20 clk = !clk; //clk -> 1 : ready to write back
    icode = 1; ifun = 0;
    rA = 3; rB = 5; 
    valE = 114; valM = 102;
    write_enable = 0;

    #20 clk = !clk; //clk -> 0 : registers updated
    write_enable = 1;

    #20 clk = !clk; //clk -> 1 : ready to write back
    icode = 2; ifun = 0;
    rA = 9; rB = 12; 
    valE = 109; valM = 120;
    write_enable = 0;

    #20 clk = !clk; //clk -> 0 : registers updated
    write_enable = 1;

    #20 clk = !clk; //clk -> 1 : ready to write back
    icode = 2; ifun = 3;
    rA = 12; rB = 14;
    valE = 137; valM = 192; 
    write_enable = 0;

    #20 clk = !clk; //clk -> 0 : registers updated
    write_enable = 1;

    #20 clk = !clk; //clk -> 1 : ready to write back
    icode = 3; ifun = 0;
    rA = 3; rB = 14;
    valE = 100; valM = 912; 
    write_enable = 0;

    #20 clk = !clk; //clk -> 0 : registers updated
    write_enable = 1;

    #20 clk = !clk; //clk -> 1 : ready to write back
    icode = 4; ifun = 0;
    rA = 13; rB = 10; 
    valE = 31; valM = 702;
    write_enable = 0;

    #20 clk = !clk; //clk -> 0 : registers updated
    write_enable = 1;

    #20 clk = !clk; //clk -> 1 : ready to write back
    icode = 5; ifun = 0;
    rA = 1; rB = 6; 
    valE = 19; valM = 52;
    write_enable = 0;

    #20 clk = !clk; //clk -> 0 : registers updated
    write_enable = 1;

    #20 clk = !clk; //clk -> 1 : ready to write back
    icode = 6; ifun = 0;
    rA = 2; rB = 11; 
    valE = 15; valM = 732;
    write_enable = 0;

    #20 clk = !clk; //clk -> 0 : registers updated
    write_enable = 1;

    #20 clk = !clk; //clk -> 1 : ready to write back
    icode = 7; ifun = 0;
    rA = 4; rB = 7; 
    valE = 1; valM = 72;
    write_enable = 0;

    #20 clk = !clk; //clk -> 0 : registers updated
    write_enable = 1;

    #20 clk = !clk; //clk -> 1 : ready to write back
    icode = 10; ifun = 0;
    rA = 4; rB = 7; 
    valE = 1; valM = 72;
    write_enable = 0;

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
