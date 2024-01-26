module add_sub_1_bit (a,b,c,ma,mb,m,sum,car);

input a,b,c,ma,mb,m;
output sum,car;

wire w1,w2,w3,w4,w5,w6,w7;

xor xor3(w3,b,m);
xor xor4(w4,a,w3);
xor xor5(sum,w4,c);
and and1(w5,a,w3);
and and2(w6,w4,c);
or or1(car,w6,w5);
    
endmodule
