`timescale 1ns/1ps

module encoder(
    input [7:0] a,
    output [2:0] k
);

    wire w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12,w13,w14,w15,w16,w17,w18,w19;
    wire one_more_one;
    wire one_more_one_high;
    wire one_more_one_low;
    //4bits or gate
    OR4DBWP2P90 or_1(.A1(a[7]),.A2(a[6]),.A3(a[5]),.A4(a[4]),.Z(w3));
    OR4DBWP2P90 or_2(.A1(a[7]),.A2(a[6]),.A3(a[3]),.A4(a[2]),.Z(w2));
    OR4DBWP2P90 or_3(.A1(a[7]),.A2(a[5]),.A3(a[3]),.A4(a[1]),.Z(w1));

    //0~3bit have more than one one?
    OR3D1BWP16P90 or_4(.A1(a[1]),.A2(a[2]),.A3(a[3]),.Z(w4));
    AN2D12BWP16P90 and_1(.A1(w4),.A2(a[0]),.Z(w5));
    OR2D12BWP16P90 or_5(.A1(a[2]),.A2(a[3]),.Z(w6));
    AN2D12BWP16P90 and_2(.A1(w6),.A2(a[1]),.Z(w7));
    AN2D12BWP16P90 and_3(.A1(a[2]),.A2(a[3]),.Z(w8));
    OR3D1BWP16P90 or_6(.A1(w8),.A2(w7),.A3(w5),.Z(w9));

    //4~7bit have more than one one?
    OR3D1BWP16P90 or_7(.A1(a[5]),.A2(a[6]),.A3(a[7]),.Z(w10));
    AN2D12BWP16P90 and_4(.A1(w10),.A2(a[4]),.Z(w11));
    OR2D12BWP16P90 or_8(.A1(a[6]),.A2(a[7]),.Z(w12));
    AN2D12BWP16P90 and_5(.A1(w12),.A2(a[5]),.Z(w13));
    AN2D12BWP16P90 and_6(.A1(a[6]),.A2(a[7]),.Z(w14));
    OR3D1BWP16P90 or_9(.A1(w14),.A2(w13),.A3(w11),.Z(w15));

    //0~3 and 0~4 more than one one?
    OR4DB1BWP16P90 or_10(.A1(a[0]),.A2(a[1]),.A3(a[2]),.A4(a[3]),.Z(w17));
    OR4DB1BWP16P90 or_11(.A1(a[4]),.A2(a[5]),.A3(a[6]),.A4(a[7]),.Z(w18));
    AN2D12BWP16P90 and_7(.A1(w17),.A2(w18),.Z(w19));
    OR3D1BWP16P90 or_12(.A1(w15),.A2(w19),.A3(w9),.Z(w16));

    //if more than one one 0000 else w
    //assign one_more_one = w16;
    BUFFD12BWP16P90 buf_1(.I(w16),.Z(one_more_one));
    MUX2D1BWP16P90 mux_1(.I0(w3),.I1(1'b0),.S(one_more_one),.Z(k[2]));
    MUX2D1BWP16P90 mux_2(.I0(w2),.I1(1'b0),.S(one_more_one),.Z(k[1]));
    MUX2D1BWP16P90 mux_3(.I0(w1),.I1(1'b0),.S(one_more_one),.Z(k[0]));

endmodule
