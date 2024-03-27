`include "add_sub_1_bit.v"
`include "add_sub_64_bit.v"
`include "and_1_bit.v"
`include "and_64_bit.v"
`include "xor_1_bit.v"
`include "xor_64_bit.v"

module execute_block(vala,valb,valc,icode,ifun,vale,cnd,SF,ZF,OF);

input [63:0] vala,valb,valc;
input [3:0] icode,ifun;
output reg [63:0] vale;
output reg cnd,SF,ZF,OF;

/*reg SF,ZF,OF;*/
reg z = 0;
reg nz = 1;

reg [63:0] p = 4'b1000;
wire [62:0] r1,r2,r3,r6,r7,r8,r9;
wire [63:0] r4,r5;
wire of1,of2,of3,of6,of7,of8,of9,sf1,sf2,sf3,sf6,sf7,sf8,sf9;

add_sub_64_bit m1(.a(valb),.b(p),.m(nz),.sum(r1),.over(of1),.sign(sf1)); /* valb - 8 */
add_sub_64_bit m2(.a(valb),.b(p),.m(z),.sum(r2),.over(of2),.sign(sf2)); /* valb + 8 */
add_sub_64_bit m3(.a(valc),.b(valb),.m(z),.sum(r3),.over(of3),.sign(sf3)); /* valb + valc */
and_64_bit a3(.a(vala),.b(valb),.c(r4)); /* vala and valb */
xor_64_bit a4(.a(vala),.b(valb),.c(r5)); /* vala xor valb */
add_sub_64_bit m6(.a(valb),.b(vala),.m(z),.sum(r6),.over(of6),.sign(sf6)); /* valb + vala */
add_sub_64_bit m7(.a(valb),.b(vala),.m(nz),.sum(r7),.over(of7),.sign(sf7)); /* valb - vala */
add_sub_64_bit m8(.a(vala),.b(p),.m(z),.sum(r8),.over(of8),.sign(sf8)); /* vala + 8 */
add_sub_64_bit m9(.a(vala),.b(p),.m(nz),.sum(r9),.over(of9),.sign(sf9)); /* vala - 8 */


always@(*)
begin
if(icode == 2)
begin
    vale <= vala;
    if(ifun == 0)
    begin
        cnd = 0;
    end
    else if(ifun == 1)
    begin
        cnd = (SF^OF)|ZF;
    end
    else if(ifun == 2)
    begin
        cnd = SF^OF;
    end
    else if(ifun == 3)
    begin
        cnd = ZF;
    end
    else if(ifun == 4)
    begin
        cnd = ~ZF;
    end
    else if(ifun == 5)
    begin
        cnd = ~(SF^OF);
    end
    else
    begin
        cnd   = ~((SF^OF)|ZF);
    end
end
else if(icode == 3)
begin
    vale <= valc;
    OF <= of3;
    SF <= sf3;
    if(r3 == 0)
    begin
        ZF <= 1;
    end
    else
    begin
        ZF <=0;
    end
end
else if(icode == 4)
begin
    vale <= r3;
    OF <= of3;
    SF <= sf3;
    if(r3 == 0)
    begin
        ZF <= 1;
    end
    else
    begin
        ZF <=0;
    end
end
else if(icode == 5)
begin
    vale <= r3;
    OF <= of3;
    SF <= sf3;
    if(r3 == 0)
    begin
        ZF <= 1;
    end
    else
    begin
        ZF <=0;
    end
end
else if(icode == 6)
begin
    if(ifun == 0)
    begin
        vale <= r6;
        OF <= of6;
        SF <= sf6;
        if(r6 == 0)
        begin
            ZF <= 1;
        end
        else
    begin
        ZF <=0;
    end
    end
    else if(ifun == 1)
    begin
        vale <= r7;
        OF <= of7;
        SF <= sf7;
        if(r7 == 0)
        begin
            ZF <= 1;
        end
        else
    begin
        ZF <=0;
    end
    end
    else if(ifun == 2)
    begin
        vale <= r4;
        OF <= 0;
        if(r4 == 0)
        begin
            ZF <= 1;
        end
        else
    begin
        ZF <=0;
    end
    end
    else
    begin
        vale <= r5;
        OF <= 0;
        if(r5 == 0)
        begin
            ZF <= 1;
        end
        else
        begin
        ZF <=0;
    end
    end
end
else if(icode == 7)
begin
    if(ifun == 0)
    begin 
        vale <= valc;
        cnd <= 1;
    end
    if(ifun == 1)
    begin
        cnd <= (SF^OF)|ZF;
    end
    else if(ifun == 2)
    begin
        cnd <= SF^OF;
    end
    else if(ifun == 3)
    begin
        cnd <= ZF;
    end
    else if(ifun == 4)
    begin
        cnd <= ~ZF;
    end
    else if(ifun == 5)
    begin
        cnd <= ~(SF^OF);
    end
    else
    begin
        cnd <= ~((SF^OF)|ZF);
    end
end
else if(icode == 8)
begin 
    vale <= r1;
    OF <= of1;
    SF <= sf1;
    if(r1 == 0)
    begin
        ZF <= 1;
    end
    else
    begin
        ZF <=0;
    end
end
else if(icode == 9)
begin
    vale <= r2;
    OF <= of2;
    SF <= sf2;
    if(r2 == 0)
    begin
        ZF <= 1;
    end
    else
    begin
        ZF <=0;
    end
end
else if(icode == 10)
begin
    vale <= r1;
    OF <= of1;
    SF <= sf1;
    if(r1 == 0)
    begin
        ZF <= 1;
    end
    else
    begin
        ZF <=0;
    end
end
else
begin
    vale <= r2;
    OF <= of2;
    SF <= sf2;
    if(r2 == 0)
    begin
        ZF <= 1;
    end
    else
    begin
        ZF <=0;
    end
end
end

endmodule
