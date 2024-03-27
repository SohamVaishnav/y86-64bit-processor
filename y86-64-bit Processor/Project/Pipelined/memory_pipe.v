module memory_pipe (
    input M_cnd,
    input [3:0] M_stat, M_icode, 
    input [3:0] M_dstE, M_dstM,
    input [63:0] M_valA, M_valE,
    output reg [3:0] m_stat, m_icode, m_dstE, m_dstM,
    output reg [63:0] m_valE, m_valM
);
    reg dmem_error;
    reg [8:0] RAM [2047:0]; //2048 bytes memory
    // reg [63:0] RAM[1023:0];
    // last 64 locations have been reserved for stack operations  
    // -> from 1984 to 2047 locations are reserved for stack operations 
    reg [63:0] address; 
    reg [63:0] data_in;

    always@(*)
    begin
        m_icode = M_icode;
        m_valE = M_valE;
        m_dstE = M_dstE;
        m_dstM = M_dstM;
    end

    always @ (*) begin //all the "reading from mem." operations
        case ( M_icode) 
        4'b0101 : begin //mrmovq
        //here M_valE is the address and output is m_valM
            address = M_valE;
            if (address < 2047 && address >= 0) begin
                dmem_error = 0;
                // if (write_enable == 0) begin 
                    // m_valM = RAM[address];
                    m_valM[7:0] = RAM[address];
                    m_valM[15:8] = RAM[address+1];
                    m_valM[23:16] = RAM[address+2];
                    m_valM[31:24] = RAM[address+3];
                    m_valM[39:32] = RAM[address+4];
                    m_valM[47:40] = RAM[address+5];
                    m_valM[55:48] = RAM[address+6];
                    m_valM[63:56] = RAM[address+7];
                // end
            end
            else dmem_error = 1;
        end
        4'b1001 : begin //ret
        //here M_valA is the address and output is m_valM
            address = M_valA;
            if (address < 2047 && address >= 0) begin 
                dmem_error = 0;
                // if (write_enable == 0) begin
                    // m_valM = RAM[address]; 
                    m_valM[7:0] = RAM[address];
                    m_valM[15:8] = RAM[address+1];
                    m_valM[23:16] = RAM[address+2];
                    m_valM[31:24] = RAM[address+3];
                    m_valM[39:32] = RAM[address+4];
                    m_valM[47:40] = RAM[address+5];
                    m_valM[55:48] = RAM[address+6];
                    m_valM[63:56] = RAM[address+7];
                // end
            end
            else dmem_error = 1;
        end
        4'b1011 : begin //popq
        //here M_valE is the address and output is m_valM
            address = M_valA;
            if (address < 2047 && address >= 0) begin 
                dmem_error = 0;
                // if (write_enable == 0) begin 
                    // m_valM = RAM[address];
                    m_valM[7:0] = RAM[address];
                    m_valM[15:8] = RAM[address+1];
                    m_valM[23:16] = RAM[address+2];
                    m_valM[31:24] = RAM[address+3];
                    m_valM[39:32] = RAM[address+4];
                    m_valM[47:40] = RAM[address+5];
                    m_valM[55:48] = RAM[address+6];
                    m_valM[63:56] = RAM[address+7];
                // end
            end
            else dmem_error = 1;
        end
        default : begin 
            if ((M_icode == 4'b0000) || (M_icode == 4'b0001) || (M_icode == 4'b0010) || (M_icode == 4'b0011) 
            || (M_icode == 4'b0110) || (M_icode == 4'b0111) || (M_icode == 4'b1000) || (M_icode == 4'b1010)
            || (M_icode == 4'b0100)) begin 
                dmem_error = 0;
            end
        end
        endcase
    end

    always @(*) begin //all the "writing into mem." operations
        case (M_icode) 
        4'b0100 : begin //rmmovq
        //here M_valE is the address and M_valA is the input data
            address = M_valE; 
            data_in = M_valA;
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
        //here M_valE is the address and valP is the input data
            address = M_valE;
            data_in = M_valA;
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
        //here M_valE is the address and M_valA is the input data
            address = M_valE;
            data_in = M_valA;
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
            if ((M_icode == 4'b0000) || (M_icode == 4'b0001) || (M_icode == 4'b0010) || (M_icode == 4'b0011) 
            || (M_icode == 4'b0110) || (M_icode == 4'b0111) || (M_icode == 4'b1001) || (M_icode == 4'b1011)
            || (M_icode == 4'b0101)) begin 
                dmem_error = 0;
            end
        end
        endcase 
    end

    always@(*)
    begin
        m_stat = M_stat;
        m_stat[2] = dmem_error;
    end
    
endmodule
