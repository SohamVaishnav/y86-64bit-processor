module decode_reg_block_tb;

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
    $dumpfile("decode_out.vcd");
    $dumpvars(0, decode_reg_block_tb);
    $monitor("icode = %d, ifun = %d, rA = %d, rB = %d, we = %d, E = %0d, M = %0d, A = %0d, B = %0d", 
    icode, ifun, rA, rB, write_enable, valE, valM, valA, valB);
    
    #20 write_enable = 0;
    
    #20 icode = 0; ifun = 0;
    rA = 4; rB = 7; 

    #20 icode = 1; ifun = 0;
    rA = 11; rB = 8;

    #20 icode = 2; ifun = 0;
    rA = 12; rB = 13;

    #20 icode = 2; ifun = 2;
    rA = 0; rB = 5;

    #20 icode = 3; ifun = 0;
    rA = 12; rB = 9;

    #20 icode = 4; ifun = 0;
    rA = 1; rB = 14;

    #20 icode = 10; ifun = 0;
    rA = 7; rB = 6;

    #20 $finish;

end
endmodule
