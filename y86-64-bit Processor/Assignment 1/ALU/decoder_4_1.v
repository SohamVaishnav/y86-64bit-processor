module decoder_4_1(s0,s1,out0,out1,out2,out3);

input s0,s1;
output out0,out1,out2,out3;

wire w1,w2,w3,w4;

and and1(out0,~s0,~s1);
and and2(out1,~s0,s1);
and and3(out2,s0,~s1);
and and4(out3,s0,s1);

endmodule

