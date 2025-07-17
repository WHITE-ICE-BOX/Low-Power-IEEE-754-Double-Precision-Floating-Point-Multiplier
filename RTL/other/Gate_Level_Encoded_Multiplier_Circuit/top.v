module top (
    input [7:0] a,
    input [7:0] b,
    output [5:0] out
);
    wire [2:0] l_a, l_b;
    encoder encoder_1(.a(a), .k(l_a));
    encoder encoder_2(.a(b), .k(l_b));
    multiplier multiplier_1(.A(l_a),.B(l_b),.C(out));

endmodule
