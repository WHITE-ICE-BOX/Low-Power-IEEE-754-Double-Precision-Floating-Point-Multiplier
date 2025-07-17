`timescale 100ps/10ps

module find_all_point(
    input clk,
    input reset,
    input nt,
    input wire[2:0] x_mem0,
    input wire[2:0] x_mem1,
    input wire[2:0] x_mem2,
    input wire[2:0] y_mem0,
    input wire[2:0] y_mem1,
    input wire[2:0] y_mem2,
    //input valid,
    output reg out_on,
    output reg po,
    output reg busy,
    output reg [2:0] xo,
    output reg [2:0] yo
);

    reg [4:0] state;
    reg signed [3:0] x,y;
    reg signed [6:0] a1,b1,c1,a2,b2,c2;
    reg signed [6:0] x0,x1,x2,y0,y1,y2;
    reg signed [12:0] line_1,line_2; //test
    reg [2:0] x_limit;

    always@(posedge clk)begin
        if(reset)begin
            busy   <= 0;
            po     <= 0;
            state  <= 0;
            out_on <= 0;
            xo     <= 0;
            yo     <= 0;
        end else begin
            //if(valid)begin
            case(state)
                0: begin
                    out_on <= 0;
                    state  <= 1;
                end
                1: begin
                    busy   <= 1;
                    xo     <= x_mem0;
                    yo     <= y_mem0;
                    state  <= 2;
                end
                2: begin
                    x1     <= x_mem1;
                    y1     <= y_mem1;
                    state  <= 3;
                end
                3: begin
                    x2     <= x_mem2;
                    y2     <= y_mem2;
                    state  <= 4;
                end
                4: begin
                    a1     <= y0 - y1;
                    b1     <= x1 - x0;
                    c1     <= x0 * y1 - x1 * y0;
                    a2     <= y2 - y1;
                    b2     <= x1 - x2;
                    c2     <= x2 * y1 - x1 * y2;
                    y      <= y0;
                    x      <= x0;
                    state  <= 5;
                end
                5: begin
                    xo      <= x;
                    yo      <= y;
                    po      <= 1;
                    if(b1 > 0)begin
                        state   <= 6;
                        x       <= x + 1;
                        x_limit <= x1;
                    end else begin
                        state   <= 9;
                        x       <= x1;
                        y       <= y + 1;
                        x_limit <= x0;
                    end
                end
                6: begin
                    po      <= 0;
                    line_1  <= a1 * x + b1 * y + c1;
                    line_2  <= a2 * x + b2 * y + c2;
                    state   <= 7;
                end
                7: begin
                    if(line_1 >= 0 && line_2 <= 0 && x <= x_limit)begin
                        xo     <= x;
                        yo     <= y;
                        po     <= 1;
                        x      <= x + 1;
                        line_1 <= line_1 + a1;
                        line_2 <= line_2 + a2;
                        state  <= 7;
                    end else begin
                        po <= 0;
                        if(y == y2)begin
                            state   <= 8;
                            busy    <= 0;
                            out_on  <= 1;
                            xo      <= 0;
                            yo      <= 0;
                        end else begin
                            if(x1-x0 > 0)begin
                                y     <= y + 1;
                                x     <= x0;
                                state <= 6;
                            end else begin
                                y     <= y + 1;
                                x     <= x1;
                                state <= 6;
                            end
                        end
                    end
                end
                8: begin
                    state <= 0;
                end
                9: begin
                    po      <= 0;
                    line_1  <= a1 * x + b1 * y + c1;
                    line_2  <= a2 * x + b2 * y + c2;
                    state   <= 10;
                end
                10: begin
                    if(x <= x_limit)begin
                        if(line_1 <= 0 && line_2 >= 0)begin
                            xo <= x;
                            yo <= y;
                            po <= 1;
                        end
                        x      <= x + 1;
                        line_1 <= line_1 + a1;
                        line_2 <= line_2 + a2;
                        state  <= 10;
                    end else begin
                        po <= 0;
                        if(y == y2)begin
                            state   <= 8;
                            busy    <= 0;
                            out_on  <= 1;
                            xo      <= 0;
                            yo      <= 0;
                        end else begin
                            if(x1-x0 > 0)begin
                                y     <= y + 1;
                                x     <= x0;
                                state <= 9;
                            end else begin
                                y     <= y + 1;
                                x     <= x1;
                                state <= 9;
                            end
                        end
                    end
                end
            endcase
        end
    end

endmodule
