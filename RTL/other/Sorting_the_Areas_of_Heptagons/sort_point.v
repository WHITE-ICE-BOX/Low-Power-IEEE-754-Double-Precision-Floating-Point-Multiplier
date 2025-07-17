`timescale 1ns/1ps
module sort_point(
    input clk,
    input reset,
    input wire [9:0] x_mem[0:34],    // X-coordinate input (unsigned)
    input wire [9:0] y_mem[0:34],    // Y-coordinate input (unsigned)
    input wire point_on,
    input wire area_on,
    output reg cal_on,
    output reg [9:0] x_change[0:34],
    output reg [9:0] y_change[0:34]
);

    reg [3:0] i,j,k,base_idx;
    reg signed [31:0] cross_product;
    reg [4:0] state;

    always @(posedge clk) begin
        if (point_on) begin
            case(state)
                0: begin
                    i <= 0;
                    state <= 1;
                end
                1: begin
                    j <= 0;
                    state <= 2;
                end
                2: begin
                    x_change[i*7+j] <= x_mem[i*7+j];
                    y_change[i*7+j] <= y_mem[i*7+j];
                    state <= 3;
                end
                3: begin
                    if (j == 6) begin
                        state <= 4;
                    end else begin
                        j <= j + 1;
                        state <= 2;
                    end
                end
                4: begin
                    base_idx <= 0;
                    j <= 1;
                    state <= 5;
                end
                5: begin
                    if ((y_change[i*7+j] < y_change[i*7+base_idx]) ||
                        (y_change[i*7+j] == y_change[i*7+base_idx] && x_change[i*7+j] < x_change[i*7+base_idx]))
                        base_idx <= j;
                    state <= 6;
                end
                6: begin
                    if (j == 6) begin
                        j <= 1;
                        state <= 7;
                    end else begin
                        j <= j + 1;
                        state <= 5;
                    end
                end
                7: begin
                    if (base_idx != 0) begin
                        x_change[i*7+0] <= x_change[i*7+base_idx];
                        x_change[i*7+base_idx] <= x_change[i*7+0];
                        y_change[i*7+0] <= y_change[i*7+base_idx];
                        y_change[i*7+base_idx] <= y_change[i*7+0];
                    end
                    j <= 1;
                    k <= 1;
                    state <= 8;
                end
                8: begin
                    if (k < (7 - j)) begin
                        if (k < 6) begin
                            cross_product = (x_change[i*7+k] - x_change[i*7+0])*(y_change[i*7+k+1] - y_change[i*7+0]) -
                                            (x_change[i*7+k+1] - x_change[i*7+0])*(y_change[i*7+k] - y_change[i*7+0]);
                            if (cross_product <= 0) begin
                                x_change[i*7+k+1] <= x_change[i*7+k];
                                x_change[i*7+k] <= x_change[i*7+k+1];
                                y_change[i*7+k+1] <= y_change[i*7+k];
                                y_change[i*7+k] <= y_change[i*7+k+1];
                            end
                        end
                        k <= k + 1;
                    end else begin
                        if (j == 5) begin
                            state <= 9;
                        end else begin
                            j <= j + 1;
                            k <= 1;
                            state <= 8;
                        end
                    end
                end
                9: begin
                    i <= i + 1;
                    if (i == 4) begin
                        cal_on <= 1;
                    end else begin
                        state <= 1;
                    end
                end
            endcase
        end else begin
            if (area_on)
                cal_on <= 0;
            if (reset) begin
                state <= 0;
                cal_on <= 0;
            end
        end
    end
endmodule
