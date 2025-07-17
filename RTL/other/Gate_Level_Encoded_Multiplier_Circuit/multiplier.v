module multiplier(
    input [2:0] A,
    input [2:0] B,
    output [5:0] C
);
//9 and for mul
    wire l0,l1,l2,l3,l4,l5,l6,l7,l8;
    AN2D12BWP16P90 and_1(.A1(A[0]),.A2(B[0]),.Z(l0));
    AN2D12BWP16P90 and_2(.A1(A[0]),.A2(B[1]),.Z(l1));
    AN2D12BWP16P90 and_3(.A1(A[0]),.A2(B[2]),.Z(l2));
    AN2D12BWP16P90 and_4(.A1(A[1]),.A2(B[0]),.Z(l3));
    AN2D12BWP16P90 and_5(.A1(A[1]),.A2(B[1]),.Z(l4));
    AN2D12BWP16P90 and_6(.A1(A[1]),.A2(B[2]),.Z(l5));
    AN2D12BWP16P90 and_7(.A1(A[2]),.A2(B[0]),.Z(l6));
    AN2D12BWP16P90 and_8(.A1(A[2]),.A2(B[1]),.Z(l7));
    AN2D12BWP16P90 and_9(.A1(A[2]),.A2(B[2]),.Z(l8));

//fa for s c
    wire s1,c1,s2_1,c2_1,c2_2,s2,c2,s3,c3,s4,c4,c5;
    FA1D1BWP16P90 full_1(.A(l1),.B(l3),.CI(1'b0),.S(s1),.CO(c1));
    FA1D1BWP16P90 full_2(.A(l6),.B(l2),.CI(c1),.S(s2_1),.CO(c2_1));
    FA1D1BWP16P90 full_3(.A(s2_1),.B(1'b0),.CI(c2_1),.S(s2),.CO(c2_2));
    FA1D1BWP16P90 full_4(.A(c2_2),.B(1'b0),.CI(c2_1),.S(c2),.CO(c5));
    FA1D1BWP16P90 full_5(.A(l5),.B(l7),.CI(c2),.S(s3),.CO(c3));
    FA1D1BWP16P90 full_6(.A(l8),.B(c5),.CI(c3),.S(s4),.CO(c4));

    BUFFD12BWP16P90 buf_1(.I(l0),.Z(C[0]));
    BUFFD12BWP16P90 buf_2(.I(s1),.Z(C[1]));
    BUFFD12BWP16P90 buf_3(.I(s2),.Z(C[2]));
    BUFFD12BWP16P90 buf_4(.I(s3),.Z(C[3]));
    BUFFD12BWP16P90 buf_5(.I(s4),.Z(C[4]));
    BUFFD12BWP16P90 buf_6(.I(c4),.Z(C[5]));
endmodule
