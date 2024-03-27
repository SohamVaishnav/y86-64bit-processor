module memory_1 (
    input clk,
    input [3:0] icode, ifun,
    input [63:0] valA, valB, valC, 
    input [63:0] valP, valE,
    // input write_enable,
    output reg [63:0] valM, 
    output reg dmem_error
);

    reg [63:0] RAM [1023:0]; 
    // last 64 locations have been reserved for stack operations  
    // -> from 960 to 1023 locations are reserved for stack operations 
    reg [63:0] address; 
    reg [63:0] data_in;

    always @ (*) begin //all the "reading from mem." operations
        dmem_error = 1;
        case (icode) 
        4'b0101 : begin //mrmovq
        //here valE is the address and output is valM
            address = valE;
            if (address < 1024 && address >= 0) begin
                dmem_error = 0;
                // if (write_enable == 0) begin 
                    valM = RAM[address];
                // end
            end
        end
        4'b1001 : begin //ret
        //here valA is the address and output is valM
            address = valA;
            if (address < 1024 && address >= 0) begin 
                dmem_error = 0;
                // if (write_enable == 0) begin
                    valM = RAM[address]; 
                // end
            end
        end
        4'b1011 : begin //popq
        //here valE is the address and output is valM
            address = valE;
            if (address < 1024 && address >= 0) begin 
                dmem_error = 0;
                // if (write_enable == 0) begin 
                    valM = RAM[address];
                // end
            end
        end
        default : begin 
            if ((icode == 4'b0000) || (icode == 4'b0001) || (icode == 4'b0010) || (icode == 4'b0011) 
            || (icode == 4'b0110) || (icode == 4'b0111) || (icode == 4'b1000) || (icode == 4'b1010)
            || (icode == 4'b0100)) begin 
                dmem_error = 0;
            end
        end
        endcase
    end

    always @(*) begin //all the "writing into mem." operations
        dmem_error = 1;
        case (icode) 
        4'b0100 : begin //rmmovq
        //here valE is the address and valA is the input data
            address = valE; 
            data_in = valA;
            if (address < 1024 && address >= 0) begin 
                dmem_error = 0;
                // if (write_enable == 1) begin 
                    RAM[address] = data_in;
                // end
            end
        end
        4'b1000 : begin //call 
        //here valE is the address and valP is the input data
            address = valE;
            data_in = valP;
            if (address < 1024 && address >= 0) begin 
                dmem_error = 0;
                // if (write_enable == 1) begin  
                    RAM[address] = data_in;
                // end
            end
        end
        4'b1010 : begin //pushq 
        //here valE is the address and valA is the input data
            address = valE;
            data_in = valA;
            if (address < 1024 && address >=0) begin 
                dmem_error = 0;
                // if (write_enable == 1) begin
                    RAM[address] = data_in;
                // end
            end 
        end
        default : begin 
            if ((icode == 4'b0000) || (icode == 4'b0001) || (icode == 4'b0010) || (icode == 4'b0011) 
            || (icode == 4'b0110) || (icode == 4'b0111) || (icode == 4'b1001) || (icode == 4'b1011)
            || (icode == 4'b0101)) begin 
                dmem_error = 0;
            end
        end
        endcase 
    end
    
endmodule
