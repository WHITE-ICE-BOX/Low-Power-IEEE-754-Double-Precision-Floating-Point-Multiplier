`timescale 100ps/10ps
`include "find_all_point.v"

module triangle(
    input       clk,
    input       reset,
    input       nt,
    input [2:0] xi,
    input [2:0] yi,
    output      busy,
    output      po,
    output [2:0] xo,
    output [2:0] yo
);

    reg [2:0] x_mem0;
    reg [2:0] x_mem1;
    reg [2:0] x_mem2;
    reg [2:0] y_mem0;
    reg [2:0] y_mem1;
    reg [2:0] y_mem2;
    reg [3:0] state;
    reg       find_on;
    //reg valid;

    find_all_point point_0(.clk(clk),
        .reset(reset),
        .nt(nt),
        //.valid(valid),
        .x_mem0(x_mem0),
        .x_mem1(x_mem1),
        .x_mem2(x_mem2),
        .y_mem0(y_mem0),
        .y_mem1(y_mem1),
        .y_mem2(y_mem2),
        .out_on(out_on),
        .po(po),
        .busy(busy),
        .xo(xo),
        .yo(yo)
    );

    always @(posedge clk) begin
        if (reset) begin
            state <= 0;
        end else begin
            case(state)
                0: begin
                    if (nt) begin
                        state <= 1;
                        x_mem0 <= xi;
                        y_mem0 <= yi;
                        //valid <= 0;
                    end else
                        state <= 0;
                end
                1: begin
                    x_mem1 <= xi;
                    y_mem1 <= yi;
                    state <= 2;
                end
                2: begin
                    x_mem2 <= xi;
                    y_mem2 <= yi;
                    state <= 3;
                end
                3: begin
                    //valid <= 1;
                    state <= 4;
                end
                4: begin
                    if (out_on) begin
                        //valid <= 0;
                        state <= 0;
                    end else
                        state <= 3;
                end
            endcase
        end
    end

endmodule
