`timescale 1ns/1ps
`include "sort_point.v"
`include "area_calculation.v"
`include "sort_area.v"

module heptagon(
    input           clk,        // Clock signal
    input           reset,      // Asynchronous active-high reset
    input   [9:0]   X,          // X-coordinate input (unsigned)
    input   [9:0]   Y,          // Y-coordinate input (unsigned)
    output reg      valid,      // Output valid signal
    output reg [2:0] Index,     // Sorted heptagon index output
    output reg [18:0] Area      // Sorted heptagon area output
);

    reg  [9:0] x_mem[0:34];
    reg  [9:0] y_mem[0:34];
    wire [9:0] x_change[0:34];
    wire [9:0] y_change[0:34];
    wire [18:0] Area_complex[0:4];
    wire [2:0] Index_before[0:4];
    wire [2:0] Index_after[0:4];
    wire [18:0] Area_after[0:4];
    reg  [2:0] heptagons_count;
    reg  [2:0] point_count;
    reg  [3:0] state;
    reg  [2:0] valid_count;
    reg        point_on;
    wire       cal_on;
    wire       area_on;
    wire       valid_on;

    sort_point point_0(.clk(clk),
        .reset(reset),
        .x_mem(x_mem),
        .y_mem(y_mem),
        .x_change(x_change),
        .y_change(y_change),
        .point_on(point_on),
        .area_on(area_on),
        .cal_on(cal_on)
    );
    area_calculation calculation_0(.clk(clk),
        .reset(reset),
        .Index_before(Index_before),
        .Area_complex(Area_complex),
        .x_change(x_change),
        .y_change(y_change),
        .cal_on(cal_on),
        .area_on(area_on),
        .valid_on(valid_on)
    );
    sort_area area_0(.clk(clk),
        .Index_after(Index_after),
        .reset(reset),
        .Area_after(Area_after),
        .Area_complex(Area_complex),
        .Index_before(Index_before),
        .area_on(area_on),
        .valid_on(valid_on)
    );

    always @(posedge clk or reset)begin

        if(reset)begin
            heptagons_count <= 0;
            point_count <= 0;
            valid_count <= 0;
            valid <= 0;
            point_on <= 0;
            state <= 0;
        end else begin
            case(state)
                0: begin
                    state <= 1;
                end
                1: begin
                    x_mem[heptagons_count*7+point_count] <= X;
                    y_mem[heptagons_count*7+point_count] <= Y;
                    if(point_count == 6) begin
                        point_count <= 0;
                        if(heptagons_count == 4) begin
                            point_on <= 1;
                            state <= 2;
                        end else begin
                            heptagons_count <= heptagons_count + 1;
                            state <= 1;
                        end
                    end else begin
                        point_count <= point_count + 1;
                        state <= 1;
                    end
                end
                2: begin
                    if(cal_on)begin
                        point_on <= 0;
                        state <= 3;
                    end
                end
                3: begin
                    if(area_on)begin
                        //cal_on <= 0;
                        state <= 4;
                    end
                end
                4: begin
                    if(valid_on)begin
                        //area_on <= 0;
                        valid <= 1;
                        Index <= Index_after[valid_count];
                        Area <= Area_after[valid_count];
                        if(valid_count < 5) begin
                            valid_count <= valid_count + 1;
                            state <= 4;
                        end else
                            valid <= 0;
                    end else
                        valid <= 0;
                end
            endcase
        end
    end

endmodule
