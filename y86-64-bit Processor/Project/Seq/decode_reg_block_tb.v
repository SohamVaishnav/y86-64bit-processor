module decode_reg_block_tb;

reg read,write;
reg [3:0] ra,rb;
reg [3:0] data_in;
wire [3:0] vala,valb;
wire err;

decode_reg_block dut(.read(read),.write(write),.data_in(data_in),.ra(ra),.rb(rb),.vala(vala),.valb(valb),.err(err));

initial
begin
       read = 0; write = 1; rb = 4'b0011 ; data_in = 4'b1011;
    #5 read = 0; write = 1; rb = 4'b0101; data_in = 4'b0001;
    #5 read = 0; write = 1; rb = 4'b1101; data_in = 4'b0110;
    #5 read = 1; write = 0; ra = 4'b0101; rb = 4'b1101; data_in =4'bxxxx;
    #5 read = 1; write = 1; rb = 4'b1101; data_in = 4'b0110;
    #5 read = 1; write = 0; ra = 4'b0011; rb = 4'b1101; data_in = 4'bxxxx;
    #5 read = 0; write = 1; rb = 4'b1111; data_in = 4'b0100;
    #5 read = 1; write = 0; ra = 4'b1111; rb = 4'b1000; data_in = 4'b1110;
    #5 read = 1; write = 0; ra = 4'b0001; rb = 4'b1111; data_in = 4'b0110;
end


endmodule
