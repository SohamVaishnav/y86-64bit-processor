module memory1_pipe (
    input M_cnd,
    input [3:0] M_stat, M_icode,
    input [63:0] M_valA, M_valE, M_dstE, M_dstM,
    output reg [3:0] m_stat, m_icode, m_dstE, m_dstM,
    output reg [63:0] m_valE, m_valM
);

    reg dmem_error;
    reg [63:0] RAM [1023:0]; 
    // last 64 locations have been reserved for stack operations  
    // -> from 960 to 1023 locations are reserved for stack operations 
    reg [63:0] address; 
    reg [63:0] data_in;

    always@(*)
    begin
        m_icode = M_icode;
        m_valE = M_valE;
    end

    always @ (*) begin //all the "reading from mem." operations
        dmem_error = 1;
        case (M_icode) 
        4'b0101 : begin //mrmovq
        //here valE is the address and output is valM
            address = M_valE;
            if (address < 1024 && address >= 0) begin
                dmem_error = 0;
                // if (write_enable == 0) begin 
                    m_valM = RAM[address];
                // end
            end
        end
        4'b1001 : begin //ret
        //here valA is the address and output is valM
            address = M_valA;
            if (address < 1024 && address >= 0) begin 
                dmem_error = 0;
                // if (write_enable == 0) begin
                    m_valM = RAM[address]; 
                // end
            end
        end
        4'b1011 : begin //popq
        //here valE is the address and output is valM
            address = M_valE;
            if (address < 1024 && address >= 0) begin 
                dmem_error = 0;
                // if (write_enable == 0) begin 
                    m_valM = RAM[address];
                // end
            end
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
        dmem_error = 1;
        case (M_icode) 
        4'b0100 : begin //rmmovq
        //here valE is the address and valA is the input data
            address = M_valE; 
            data_in = M_valA;
            if (address < 1024 && address >= 0) begin 
                dmem_error = 0;
                // if (write_enable == 1) begin 
                    RAM[address] = data_in;
                // end
            end
        end
        4'b1000 : begin //call 
        //here valE is the address and valP is the input data
            address = M_valE;
            // data_in = valP;
            if (address < 1024 && address >= 0) begin 
                dmem_error = 0;
                // if (write_enable == 1) begin  
                    RAM[address] = data_in;
                // end
            end
        end
        4'b1010 : begin //pushq 
        //here valE is the address and valA is the input data
            address = M_valE;
            data_in = M_valA;
            if (address < 1024 && address >=0) begin 
                dmem_error = 0;
                // if (write_enable == 1) begin
                    RAM[address] = data_in;
                // end
            end 
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
        m_stat[1] = dmem_error;
    end
    
endmodule
