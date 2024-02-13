module memory (
    input [63:0] address,
    input write_enable, 
    input signed [63:0] data_in,
    input clk, 
    output reg signed [63:0] data_out, 
    output reg dmem_error
);

    reg [63:0] RAM [1023:0]; 
    // last 64 locations have been reserved for stack operations  
    // -> from 960 to 1023 locations are reserved for stack operations  

    always @(negedge clk) begin
        dmem_error = 1;
        if (address < 1024 && address > 0) begin 
            dmem_error = 0;
        end
        if (write_enable && !dmem_error) begin 
            RAM[address] = data_in;
        end
        else if (!write_enable && !dmem_error) begin
            data_out = RAM[address];
        end
    end
    
endmodule