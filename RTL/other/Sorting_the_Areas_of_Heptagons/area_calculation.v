`timescale 1ns/1ps
module area_calculation(
    input clk,
    input reset,
    input [9:0] x_change[0:34],
    input [9:0] y_change[0:34],
    input wire cal_on,
    input wire valid_on,
    output reg [2:0] Index_before[0:4],
    output reg [18:0] Area_complex[0:4],
    output reg area_on
);

    reg [3:0] i, j;
    reg signed [31:0] temp;
    reg signed [31:0] sum;
    reg [3:0] state;

    always @(posedge clk) begin
        if(cal_on)begin
            case(state)
            0: begin
                i <= 0;
                state <= 1;
            end
            1: begin
                j <= 0;
                sum <= 0;
                state <= 2;
            end
            2: begin
                temp <= (x_change[i * 7 + j] * y_change[i * 7 + (j+1)%7] - x_change[i * 7 + (j+1)%7] * y_change[i * 7 + j]);
                state <= 3;
            end
            3: begin
                sum <= sum + temp;
                state <= 4;
            end
            4: begin
                if(j < 6)begin
                    j <= j + 1;
                    state <= 2;
                end else begin
                    state <= 5;
                end
            end
            5: begin
                Index_before[i] <= i[2:0] + 1;
                Area_complex[i] <= (sum > 0) ? sum/2 : -sum/2;
                state <= 6;
            end
            6: begin
                if(i == 4)begin
                    area_on <= 1;
                end else begin
                    i <= i + 1;
                    state <= 1;
                end
            end
            endcase
        end else begin
            if(valid_on)
                area_on <= 0;
            if(reset) begin
                state <= 0;
                area_on <= 0;
            end
        end
    end

endmodule
