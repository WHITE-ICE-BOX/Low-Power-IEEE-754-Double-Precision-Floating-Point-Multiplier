`timescale 1ns/1ps
module sort_area(
    input clk,
    input reset,
    input [18:0] Area_complex[0:4],
    input [2:0] Index_before[0:4],
    input wire area_on,
    output reg [2:0] Index_after[0:4],    // Sorted heptagon index output
    output reg [18:0] Area_after[0:4],    // Sorted heptagon area output
    output reg valid_on
);
    reg [3:0] i,j;
    reg [3:0] state;
    always @(posedge clk) begin
        if (area_on) begin
            case (state)
                0: begin
                    i <= 0;
                    state <= 1;
                end
                1: begin
                    Index_after[i] <= Index_before[i];
                    Area_after[i] <= Area_complex[i];
                    if (i == 4) begin
                        i <= 0;
                        state <= 2;
                    end else begin
                        i <= i + 1;
                    end
                end
                2: begin
                    j <= i + 1;
                    state <= 3;
                end
                3: begin
                    if (Area_after[i] < Area_after[j]) begin
                        Area_after[j] <= Area_after[i];
                        Area_after[i] <= Area_after[j];
                        Index_after[j] <= Index_after[i];
                        Index_after[i] <= Index_after[j];
                    end
                    if (j == 4) begin
                        if (i == 3) begin
                            state <= 4;
                        end else begin
                            i <= i + 1;
                            j <= i + 2;
                        end
                    end else begin
                        j <= j + 1;
                    end
                end
                4: begin
                    valid_on <= 1;
                    state <= 5;
                end
                5: begin
                end
            endcase
        end else begin
            if (reset) begin
                state <= 0;
                valid_on <= 0;
            end
        end
    end
endmodule
