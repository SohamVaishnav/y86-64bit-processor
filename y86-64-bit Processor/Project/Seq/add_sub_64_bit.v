module add_sub_64_bit (a,b,m,sum,over,sign);

input [63:0] a,b;
input m;
output [62:0] sum;
output over,sign;

wire j,cout;
wire [63:0] c;
wire w1,w2,w3,w4,w5,w6;
assign c[0] = m;

genvar i;

assign zero = 0;

generate
    for (i=0 ; i < 63 ; i = i + 1)
    begin
        add_sub_1_bit u0 (a[i],b[i],c[i],a[63],b[63],m,sum[i],c[i+1]);
    end
endgenerate

add_sub_1_bit u1 (.a(a[63]),.b(b[63]),.c(c[63]),.ma(a[63]),.mb(b[63]),.m(m),.sum(cout),.car(j));

and and1(w1,~a[63],~b[63],cout,~m);
and and2(w2,a[63],b[63],~cout,~m);
or or1(w5,w1,w2);

and and3(w3,~a[63],b[63],cout,m);
and and4(w4,a[63],~b[63],~cout,m);
or or2(w6,w3,w4);

or or3(over,w5,w6);

and and5(sign,~over,cout);



endmodule

