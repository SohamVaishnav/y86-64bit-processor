module memory (
    input clk,
    input [3:0] icode, ifun,
    input [63:0] valA, valB, valC, 
    input [63:0] valP, valE,
    // input write_enable,
    output reg [63:0] valM, 
    output reg dmem_error
);
    reg [8:0] RAM [2047:0]; //2048 bytes memory
    // reg [63:0] RAM[1023:0];
    // last 64 locations have been reserved for stack operations  
    // -> from 1984 to 2047 locations are reserved for stack operations 
    reg [63:0] address; 
    reg [63:0] data_in;

    always @ (*) begin //all the "reading from mem." operations
        case (icode) 
        4'b0101 : begin //mrmovq
        //here valE is the address and output is valM
            address = valE;
            if (address < 2047 && address >= 0) begin
                dmem_error = 0;
                // if (write_enable == 0) begin 
                    // valM = RAM[address];
                    valM[7:0] = RAM[address];
                    valM[15:8] = RAM[address+1];
                    valM[23:16] = RAM[address+2];
                    valM[31:24] = RAM[address+3];
                    valM[39:32] = RAM[address+4];
                    valM[47:40] = RAM[address+5];
                    valM[55:48] = RAM[address+6];
                    valM[63:56] = RAM[address+7];
                // end
            end
            else dmem_error = 1;
        end
        4'b1001 : begin //ret
        //here valA is the address and output is valM
            address = valA;
            if (address < 2047 && address >= 0) begin 
                dmem_error = 0;
                // if (write_enable == 0) begin
                    // valM = RAM[address]; 
                    valM[7:0] = RAM[address];
                    valM[15:8] = RAM[address+1];
                    valM[23:16] = RAM[address+2];
                    valM[31:24] = RAM[address+3];
                    valM[39:32] = RAM[address+4];
                    valM[47:40] = RAM[address+5];
                    valM[55:48] = RAM[address+6];
                    valM[63:56] = RAM[address+7];
                // end
            end
            else dmem_error = 1;
        end
        4'b1011 : begin //popq
        //here valE is the address and output is valM
            address = valA;
            if (address < 2047 && address >= 0) begin 
                dmem_error = 0;
                // if (write_enable == 0) begin 
                    // valM = RAM[address];
                    valM[7:0] = RAM[address];
                    valM[15:8] = RAM[address+1];
                    valM[23:16] = RAM[address+2];
                    valM[31:24] = RAM[address+3];
                    valM[39:32] = RAM[address+4];
                    valM[47:40] = RAM[address+5];
                    valM[55:48] = RAM[address+6];
                    valM[63:56] = RAM[address+7];
                // end
            end
            else dmem_error = 1;
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

    always @(negedge clk) begin //all the "writing into mem." operations
        case (icode) 
        4'b0100 : begin //rmmovq
        //here valE is the address and valA is the input data
            address = valE; 
            data_in = valA;
            if (address < 2047 && address >= 0) begin 
                dmem_error = 0;
                // if (write_enable == 1) begin 
                    // RAM[address] = data_in;
                    RAM[address] = data_in[7:0];
                    RAM[address+1] = data_in[15:8];
                    RAM[address+2] = data_in[23:16];
                    RAM[address+3] = data_in[31:24];
                    RAM[address+4] = data_in[39:32];
                    RAM[address+5] = data_in[47:40];
                    RAM[address+6] = data_in[55:48];
                    RAM[address+7] = data_in[63:56];
                // end
            end
            else dmem_error = 1;
        end
        4'b1000 : begin //call 
        //here valE is the address and valP is the input data
            address = valE;
            data_in = valP;
            if (address < 2047 && address >= 0) begin 
                dmem_error = 0;
                // if (write_enable == 1) begin  
                    // RAM[address] = data_in;
                    RAM[address] = data_in[7:0];
                    RAM[address+1] = data_in[15:8];
                    RAM[address+2] = data_in[23:16];
                    RAM[address+3] = data_in[31:24];
                    RAM[address+4] = data_in[39:32];
                    RAM[address+5] = data_in[47:40];
                    RAM[address+6] = data_in[55:48];
                    RAM[address+7] = data_in[63:56];
                // end
            end
            else dmem_error = 1;
        end
        4'b1010 : begin //pushq 
        //here valE is the address and valA is the input data
            address = valE;
            data_in = valA;
            if (address < 2047 && address >=0) begin 
                dmem_error = 0;
                // if (write_enable == 1) begin
                    // RAM[address] = data_in;
                    RAM[address] = data_in[7:0];
                    RAM[address+1] = data_in[15:8];
                    RAM[address+2] = data_in[23:16];
                    RAM[address+3] = data_in[31:24];
                    RAM[address+4] = data_in[39:32];
                    RAM[address+5] = data_in[47:40];
                    RAM[address+6] = data_in[55:48];
                    RAM[address+7] = data_in[63:56];
                // end
            end 
            else dmem_error = 1;
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