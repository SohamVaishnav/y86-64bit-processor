module RAM32x8 (
    input [63:0] write_addr,
    input [63:0] read_addr,  
    input signed [127:0] input_data, 
    input read_enable, write_enable,
    input clk, rst,
    output reg [63:0] read_out, 
    output reg invalid_r_addr,
    output reg invalid_w_addr,
    output reg w_r_same_addr, 
    output reg mem_loc_occupied, 
    output reg data_overflow
);
    reg [63:0]RAM [31:0];

    always @ (write_enable or read_enable or input_data) begin 
        mem_loc_occupied <= 0;
        w_r_same_addr <= 0;
        invalid_w_addr <= 0;
        invalid_r_addr <= 0;
        data_overflow <= 0;
        if (write_addr > 64'b11111 || write_addr < 0) begin 
            invalid_w_addr <= 1;
        end
        if (read_addr > 64'b11111 || read_addr < 0) begin 
            invalid_r_addr <= 1;
        end
        if ((read_enable && write_enable) && read_addr == write_addr) begin
            w_r_same_addr <= 1;
        end
        if (write_enable && RAM[write_addr] >= 0) begin
            mem_loc_occupied <= 1;
        end
        if (input_data > (2**63-1) || input_data < -(2**63-1)) begin 
            data_overflow <= 1;
        end
    end

    always @ (posedge clk) begin
        if (write_enable == 1 && !w_r_same_addr && !invalid_w_addr) begin 
            if (!data_overflow) begin
                RAM[write_addr] <= input_data;
            end
            //While writing the memory, regardless of the address being already occupied
            //with past data or not, new data will be over-written at that location 
        end
    end

    integer i;
    always @ (*) begin 
        if (read_enable == 1 && !w_r_same_addr && !invalid_r_addr) begin 
            read_out <= RAM[read_addr];
        end
    //Here the code does not take into account the order of enabling of rst and other
    //enables. This implies that it will function as per the instructions but if at the
    //end it finds that rst is high, then it will wipe the memory
        if (rst == 1) begin 
            for (i=0 ; i<=31 ; i=i+1) begin
                RAM[i] <= 64'bx;
            end
            mem_loc_occupied <= 0;
        end
    end

endmodule