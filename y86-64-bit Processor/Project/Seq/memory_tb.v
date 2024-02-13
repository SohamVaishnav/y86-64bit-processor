module memory_tb;
    reg [63:0] address;
    reg signed [63:0] data_in;
    reg clk;
    reg write_enable;

    wire signed [63:0] data_out;
    wire dmem_error;

    memory M(address, write_enable, data_in, clk, data_out, dmem_error);

    initial begin 
        $dumpfile("memory_out.vcd");
        $dumpvars(0, memory_tb);
        $monitor("clk = %d, addr = %0d, din = %0d, we = %0d, dout = %0d, err = %d", 
        clk, address, data_in, write_enable, data_out, dmem_error);

        #20 clk = 0; //-> clk = 0

        #20 clk = !clk; //clk -> 1 : data ready to be written
        address = 10;
        write_enable = 1;
        data_in = 100;

        #20 clk = !clk; //clk -> 0 : data gets written

        #20 clk = !clk; //clk -> 1 : data shouldnt get written
        data_in = 10;
        address = 19;

        #20 clk = !clk; //clk -> 0 : data gets read
        write_enable = 0;
        address = 10;

        #20 clk = !clk; //clk -> 1 : data ready to be read
        address = 96;
        write_enable = 0;
        data_in = 90;

        #20 clk = !clk; //clk -> 0 : data gets read

        #20 clk = !clk; //clk -> 1 : data ready to be written
        write_enable = 1; 

        #20 clk = !clk; //clk -> 0 : data gets written

        #20 clk = !clk; //clk -> 1 : data ready to be read
        write_enable = 0;

        #20 clk = !clk; //clk -> 0 : data gets read

        #20 $finish;
    end
endmodule