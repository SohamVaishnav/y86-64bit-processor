module enable_64_bit(e,a,b,c,d);

input e;
input [63:0] a,b;
output [63:0] c,d;

genvar i;

generate
    for (i = 0 ; i < 64 ; i = i + 1 )
    begin
        enable_1_bit u0(e,a[i],c[i]);
    end
endgenerate

genvar j;

generate
    for (j = 0 ; j < 64 ; j = j + 1 )
    begin
        enable_1_bit u0(e,b[j],d[j]);
    end
endgenerate

endmodule


