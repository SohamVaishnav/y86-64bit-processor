module and_64_bit (a,b,c);

input [63:0] a,b;
output [63:0] c;

genvar i;

generate
    for (i = 0; i < 64 ;i = i + 1)
    begin
        and_1_bit u0 (a[i],b[i],c[i]);
    end
endgenerate    

endmodule
