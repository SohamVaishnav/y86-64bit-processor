`include "add_sub_1_bit.v"
`include "add_sub_64_bit.v"
`include "and_1_bit.v"
`include "and_64_bit.v"
`include "xor_1_bit.v"
`include "xor_64_bit.v"

module execute_pipe(E_stat, W_stat, m_stat, E_icode, E_ifun, E_dstE, E_dstM, E_valC, E_valA, E_valB, e_cnd, e_stat, e_icode, e_dstE, e_dstM, e_valE, e_valA, SF, ZF, OF);

input [3:0] E_stat, W_stat, m_stat, E_icode, E_ifun, E_dstE, E_dstM;
input [63:0] E_valC, E_valA, E_valB;
output reg e_cnd;
output reg [3:0] e_stat, e_icode, e_dstE, e_dstM;
output reg [63:0] e_valE, e_valA;

reg dstE;

output reg SF,ZF,OF;
reg z = 0;
reg nz = 1;

reg [63:0] p = 4'b1000;
wire [62:0] r1,r2,r3,r6,r7,r8,r9;
wire [63:0] r4,r5;
wire of1,of2,of3,of6,of7,of8,of9,sf1,sf2,sf3,sf6,sf7,sf8,sf9;

add_sub_64_bit m1(.a(E_valB),.b(p),.m(nz),.sum(r1),.over(of1),.sign(sf1)); /* valb - 8 */
add_sub_64_bit m2(.a(E_valB),.b(p),.m(z),.sum(r2),.over(of2),.sign(sf2)); /* valb + 8 */
add_sub_64_bit m3(.a(E_valC),.b(E_valB),.m(z),.sum(r3),.over(of3),.sign(sf3)); /* valb + valc */
and_64_bit a3(.a(E_valA),.b(E_valB),.c(r4)); /* vala and valb */
xor_64_bit a4(.a(E_valA),.b(E_valB),.c(r5)); /* vala xor valb */
add_sub_64_bit m6(.a(E_valA),.b(E_valB),.m(z),.sum(r6),.over(of6),.sign(sf6)); /* vala + valb */
add_sub_64_bit m7(.a(E_valB),.b(E_valA),.m(nz),.sum(r7),.over(of7),.sign(sf7)); /* vala - valb */
add_sub_64_bit m8(.a(E_valA),.b(p),.m(z),.sum(r8),.over(of8),.sign(sf8)); /* vala + 8 */
add_sub_64_bit m9(.a(E_valA),.b(p),.m(nz),.sum(r9),.over(of9),.sign(sf9)); /* vala - 8 */

initial begin 
    e_cnd = 0;
end

always@(*)
begin
    e_stat = E_stat;
    e_icode = E_icode;
    e_dstE = E_dstE;
    e_dstM = E_dstM;
    e_valA = E_valA;
end


always@(*)
begin
if(E_icode == 2)
begin
    e_valE <= E_valA;
    if(W_stat == 8 && m_stat == 8)
    begin
    if(E_ifun == 0)
    begin
        e_cnd = 0;
    end
    else if(E_ifun == 1)
    begin
        e_cnd = (SF^OF)|ZF;
    end
    else if(E_ifun == 2)
    begin
        e_cnd = SF^OF;
    end
    else if(E_ifun == 3)
    begin
        e_cnd = ZF;
    end
    else if(E_ifun == 4)
    begin
        e_cnd = ~ZF;
    end
    else if(E_ifun == 5)
    begin
        e_cnd = ~(SF^OF);
    end
    else
    begin
        e_cnd   = ~((SF^OF)|ZF);
    end
    end
end
else if(E_icode == 3)
begin
    e_valE <= E_valC;
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
else if(E_icode == 4)
begin
    e_valE <= r3;
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
else if(E_icode == 5)
begin
    e_valE <= r3;
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
else if(E_icode == 6)
begin
    if(E_ifun == 0)
    begin
        e_valE <= r6;
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
    else if(E_ifun == 1)
    begin
        e_valE <= r7;
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
    else if(E_ifun == 2)
    begin
        e_valE <= r4;
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
    else if (E_ifun == 3)
    begin
        e_valE <= r5;
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
else if(E_icode == 7)
begin
    if(E_ifun == 0)
    begin 
        e_valE <= E_valC;
        e_cnd = 0;
    end
    if((W_stat != 1 && W_stat != 2 && W_stat !=4) && (m_stat != 1 && m_stat != 2 && m_stat !=4))
    begin
    if(E_ifun == 1)
    begin
        e_cnd <= (SF^OF)|ZF;
    end
    else if(E_ifun == 2)
    begin
        e_cnd <= SF^OF;
    end
    else if(E_ifun == 3)
    begin
        e_cnd <= ZF;
    end
    else if(E_ifun == 4)
    begin
        e_cnd <= ~ZF;
    end
    else if(E_ifun == 5)
    begin
        e_cnd <= ~(SF^OF);
    end
    else
    begin
        e_cnd <= ~((SF^OF)|ZF);
    end
    end
end
else if(E_icode == 8)
begin 
    e_valE <= r1;
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
else if(E_icode == 9)
begin
    e_valE <= r2;
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
else if(E_icode == 10)
begin
    e_valE <= r1;
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
    e_valE <= r2;
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
