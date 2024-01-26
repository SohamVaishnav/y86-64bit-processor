module RAM32x8_tb;
    reg [63:0] write_addr;
    reg [63:0] read_addr;
    reg signed [127:0] input_data;
    reg read_enable;
    reg write_enable;
    reg clk, rst;

    wire [63:0] read_out;
    wire invalid_r_addr;
    wire invalid_w_addr;
    wire w_r_same_addr;
    wire mem_loc_occupied;
    wire data_overflow;

    RAM32x8 M(write_addr, read_addr, input_data, read_enable, write_enable, 
    clk, rst, read_out, invalid_r_addr, invalid_w_addr, w_r_same_addr, mem_loc_occupied, 
    data_overflow);

    always @ (clk) begin 
        $display("clk = %d | Rst = %d | DataIn = %0d, WAdd. = %0d, RAdd. = %0d", clk, rst, input_data, write_addr, read_addr);
        if (data_overflow == 1 && write_enable && !invalid_w_addr) begin 
            $display("error-data_overflow: the size of data input is too large!\n");
        end
        if (invalid_w_addr == 1) begin 
            $display("error-mem_addr: invalid memory address for writing data into!\n");
        end
        if (invalid_r_addr == 1) begin 
            $display("error-mem_addr: invalid memory address for reading data from!\n");
        end
        if (w_r_same_addr == 1) begin
            if (!invalid_r_addr && !invalid_w_addr) begin 
                $display("error-mem_conflict: data cannot be written into and read from the same address simultaneously!\n");
            end
        end
        if (mem_loc_occupied == 1 && !w_r_same_addr) begin 
            $display("warning-data_conflict: desired location pre-occupied - older data will be lost!\n");
        end
        if (read_enable && !invalid_r_addr && !w_r_same_addr) begin
            $display("Data at address %0d is %0d.\n", read_addr, read_out);

        end
        if (clk && !invalid_w_addr && !w_r_same_addr && !data_overflow) begin
            if (write_enable == 1) begin 
                $display("Data %0d has been successfully written at address %0d\n", input_data, write_addr);
            end 
            else begin 
                $display("Write command not enabled!\n");
            end
        end
    end

    initial begin 
        $dumpfile("results.vcd");
        $dumpvars(0, RAM32x8_tb);

        #13 clk <= 1; #1 
        input_data <= -2**64;

        #13 clk <= !clk; #1
        write_enable <= 1;
        write_addr <= 2;

        #13 clk <= !clk; #1
        write_enable <= 0; 
        read_enable <= 1;
        read_addr <= 2;

        #13 clk <= !clk; #1
        read_enable <= 0; 
        write_enable <= 1;
        write_addr <= 40;

        #13 clk <= !clk; #1
        write_enable <= 0; 
        read_enable <= 1;
        read_addr <= 33;

        #13 clk <= !clk; #1
        read_enable <= 1;
        write_enable <= 1;
        write_addr <= 2;
        read_addr <= 2;

        #13 clk <= !clk; #1
        write_enable <= 0;
        read_enable <= 1;
        read_addr <= 2;

        #13 clk <= !clk; #1
        input_data <= 7;
        read_enable <= 0;
        write_enable <= 1;
        write_addr <= 2;

        #13 clk <= !clk; #1
        write_enable <= 0;
        read_enable <= 1;
        read_addr <= 2;

        #30 $finish;
    end

endmodule 