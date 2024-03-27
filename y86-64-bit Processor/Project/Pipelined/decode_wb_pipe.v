module decode_wb_pipe(
    input [3:0] D_icode, D_ifun, 
    input [3:0] D_rA, D_rB, 
    input [3:0] D_Stat, 
    input [63:0] D_valC, D_valP, 
    input [3:0] e_dstE, M_dstE, 
    input [63:0] e_valE, M_valE, 
    input [3:0] M_dstM, W_dstM, 
    input [3:0] W_dstE, 
    input [63:0] W_valE, m_valM, 
    input [63:0] W_valM, 
    input write_enable,
    output reg [3:0] d_icode, d_ifun, 
    output reg [3:0] d_Stat, 
    output reg [63:0] d_valC,
    output reg [63:0] d_valA, d_valB, 
    output reg [3:0] d_dstE, d_dstM, 
    output reg [3:0] d_srcA, d_srcB
);
    reg [3:0] dstE, dstM, srcA, srcB;
    reg [63:0] d_rvalA, d_rvalB;

    reg [63:0] storage [15:0];

    initial
    begin
        storage[0] = 64'b0000; //%rax
        storage[1] = 64'b1110; //%rcx
        storage[2] = 64'b1011; //%rdx
        storage[3] = 64'b1111; //%rbx
        storage[4] = 64'd2047; //%rsp -> points at the top of the stack which is at memory location 2047
        storage[5] = 64'b1010; //%rbp
        storage[6] = 64'b0001; //%rsi
        storage[7] = 64'b0010; //%rdi
        storage[8] = 64'b1000; //%r8 
        storage[9] = 64'b1110; //%r9
        storage[10] = 64'b1010; //%r10
        storage[11] = 64'b1001; //%r11
        storage[12] = 64'b1110; //%r12
        storage[13] = 64'b0111; //%r13 
        storage[14] = 64'b0101; //%r14
        storage[15] = 64'bx; //no register -> F
    end
    
    always @ (*) begin //pipeline - pipeline direct connections
        d_valC = D_valC;
        d_Stat = D_Stat;
        d_icode = D_icode;
        d_ifun = D_ifun;
    end

    always @ (*) begin //logic for dstE and dstM
        if (D_icode == 4'b1000 || D_icode == 4'b1010) begin //call or pushq
            dstE = 4'b0100;
            dstM = 4'bx;
        end
        else if (D_icode == 4'b1001 || D_icode == 4'b1011) begin //ret or popq
            dstE = 4'b0100;
            dstM = D_rA;
        end
        else if (D_icode == 4'b0101) begin //mrmovq 
            dstM = D_rB; 
            dstE = 4'bx;
        end
        else begin 
            dstE = D_rB;
            dstM = 4'bx;
        end
        d_dstE = dstE; //pipeline - pipeline direct connections
        d_dstM = dstM; //pipeline - pipeline direct connections
    end

    always @ (*) begin //logic for srcA and srcB
        if (D_icode == 4'b0011) begin //irmovq
            srcA = 15;
            srcB = D_rB;
        end
        else if (D_icode == 4'b1010) begin //pushq
            srcA = D_rA;
            srcB = 4'b0100;
        end
        else if (D_icode == 4'b1000 || D_icode == 4'b1001 || D_icode == 4'b1011) begin //call, ret, popq
            srcA = 4;
            srcB = 4;
        end
        else begin 
            srcA = D_rA;
            srcB = D_rB;
        end
        d_srcA = srcA; //pipeline - pipeline direct connections
        d_srcB = srcB; //pipeline - pipeline direct connections

        if (D_icode == 4'b0101) begin //mrmovq
            d_rvalA = storage[srcB];
            d_rvalB = storage[srcA];
        end
        else begin 
            d_rvalA = storage[srcA];
            d_rvalB = storage[srcB];
        end
    end

    always @ (*) begin //decode stage operations for valA (including data forwarding)
        if (D_icode == 4'b1000 || D_icode == 4'b0111) begin //call or jXX -> use valP
            d_valA = D_valP;
        end
        else if (srcA == e_dstE) begin //if data dependency in execute stage
            d_valA = e_valE;
        end
        else if (srcA == M_dstM) begin //if data dependency in memory stage -> valM
            d_valA = m_valM;
        end
        else if (srcA == M_dstE) begin //if data dependency in memory stage -> valE
            d_valA = M_valE; 
        end
        else if (srcA == W_dstM) begin //if data dependency in write-back stage -> valM
            d_valA = W_dstM;
        end
        else if (srcA == W_dstE) begin //if data dependency in write-back stage -> valE
            d_valA = W_valE;
        end
        else d_valA = d_rvalA; //default case of decoding as in seq
    end

    always @ (*) begin //decode stage operations for valB (including data forwarding)
        if (srcB == e_dstE) begin //if data dependency in execute stage
            d_valB = e_valE;
        end
        else if (srcB == M_dstM) begin //if data dependency in memory stage -> valM
            d_valB = m_valM;
        end
        else if (srcB == M_dstE) begin //if data dependency in memory stage -> valE
            d_valB = M_valE; 
        end
        else if (srcB == W_dstM) begin //if data dependency in write-back stage -> valM
            d_valB = W_dstM;
        end
        else if (srcB == W_dstE) begin //if data dependency in write-back stage -> valE
            d_valB = W_valE;
        end
        else d_valB = d_rvalB; //default case of decoding as in seq
    end

    always @ (*) begin //write-back stage operations
        // if (write_enable == 1) begin
            storage[W_dstE] = W_valE;
            storage[W_dstM] = W_valM;
        end
    // end
endmodule