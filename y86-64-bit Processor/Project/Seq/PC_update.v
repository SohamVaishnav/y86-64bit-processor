module PC_update (
    input clk, halt, nop,
    input [3:0] icode, ifun,
    input [63:0] valP,
    input [63:0] valC,
    input [63:0] valM,
    input cnd, 
    output reg [63:0] PC_updated
);
    always @ (negedge clk) begin //PC update stage
        case (icode) 
        4'b0111 : begin //jXX
            if (ifun == 4'b0000) begin
                PC_updated <= valC; 
            end
            else begin 
                if (cnd == 1) begin 
                    PC_updated <= valC;
                end
                else begin 
                    PC_updated <= valP;
                end
            end
        end
        4'b1000 : begin //call 
            PC_updated <= valC;
        end
        4'b1001 : begin //ret
            PC_updated <= valM; 
        end
        default : begin //all remaining instructions
            PC_updated <= valP;
        end
        endcase
    end
endmodule