`timescale 1ns/1ps
`include "/usr/chipware/CW_mult.v"
//cadence translate_on

module TRANSFORMER_ATTENTION(
    input        clk,
    input        reset,
    input        en,
    input [3:0]  MATRIX_Q,
    input [3:0]  MATRIX_K,
    input [3:0]  MATRIX_V,

    output reg [17:0] answer,
    output reg       done

);
    reg [4:0]           state;
    reg [3:0]  Q_mem [0:63];
    reg [3:0]  V_mem [0:63];
    reg [3:0]  K_mem [0:63];
    reg [14:0] W_mem [0:63];
    reg [6:0]  mem_count;
    reg [6:0]  O_count;
    wire [7:0]  temp [0:15];
    wire [17:0] temp_1 [0:7];
    reg [17:0]  temp_2 [0:7];
    reg [17:0]  O_mem  [0:63];
    reg [3:0]   A_input [0:15];
    reg [3:0]   B_input [0:15];
    reg [14:0]  C_input [0:7];
    reg [3:0]   D_input [0:7];
    reg [6:0]   i,j,k;

    CW_mult #(4,4) mul_0 (.A(A_input[0]), .B(B_input[0]), .TC(1'b0), .Z(temp[0]));
    CW_mult #(4,4) mul_1 (.A(A_input[1]), .B(B_input[1]), .TC(1'b0), .Z(temp[1]));
    CW_mult #(4,4) mul_2 (.A(A_input[2]), .B(B_input[2]), .TC(1'b0), .Z(temp[2]));
    CW_mult #(4,4) mul_3 (.A(A_input[3]), .B(B_input[3]), .TC(1'b0), .Z(temp[3]));
    CW_mult #(4,4) mul_4 (.A(A_input[4]), .B(B_input[4]), .TC(1'b0), .Z(temp[4]));
    CW_mult #(4,4) mul_5 (.A(A_input[5]), .B(B_input[5]), .TC(1'b0), .Z(temp[5]));
    CW_mult #(4,4) mul_6 (.A(A_input[6]), .B(B_input[6]), .TC(1'b0), .Z(temp[6]));
    CW_mult #(4,4) mul_7 (.A(A_input[7]), .B(B_input[7]), .TC(1'b0), .Z(temp[7]));

    CW_mult #(4,4) mul_8 (.A(A_input[8]), .B(B_input[8]), .TC(1'b0), .Z(temp[8]));
    CW_mult #(4,4) mul_9 (.A(A_input[9]), .B(B_input[9]), .TC(1'b0), .Z(temp[9]));
    CW_mult #(4,4) mul_10(.A(A_input[10]),.B(B_input[10]),.TC(1'b0),.Z(temp[10]));
    CW_mult #(4,4) mul_11(.A(A_input[11]),.B(B_input[11]),.TC(1'b0),.Z(temp[11]));
    CW_mult #(4,4) mul_12(.A(A_input[12]),.B(B_input[12]),.TC(1'b0),.Z(temp[12]));
    CW_mult #(4,4) mul_13(.A(A_input[13]),.B(B_input[13]),.TC(1'b0),.Z(temp[13]));
    CW_mult #(4,4) mul_14(.A(A_input[14]),.B(B_input[14]),.TC(1'b0),.Z(temp[14]));
    CW_mult #(4,4) mul_15(.A(A_input[15]),.B(B_input[15]),.TC(1'b0),.Z(temp[15]));

    CW_mult #(15,4) mul_16(.A(C_input[0]), .B(D_input[0]), .TC(1'b0), .Z(temp_1[0]));
    CW_mult #(15,4) mul_17(.A(C_input[1]), .B(D_input[1]), .TC(1'b0), .Z(temp_1[1]));
    CW_mult #(15,4) mul_18(.A(C_input[2]), .B(D_input[2]), .TC(1'b0), .Z(temp_1[2]));
    CW_mult #(15,4) mul_19(.A(C_input[3]), .B(D_input[3]), .TC(1'b0), .Z(temp_1[3]));
    CW_mult #(15,4) mul_20(.A(C_input[4]), .B(D_input[4]), .TC(1'b0), .Z(temp_1[4]));
    CW_mult #(15,4) mul_21(.A(C_input[5]), .B(D_input[5]), .TC(1'b0), .Z(temp_1[5]));
    CW_mult #(15,4) mul_22(.A(C_input[6]), .B(D_input[6]), .TC(1'b0), .Z(temp_1[6]));
    CW_mult #(15,4) mul_23(.A(C_input[7]), .B(D_input[7]), .TC(1'b0), .Z(temp_1[7]));

    always@(posedge clk) begin
        if (reset) begin
            state     <= 0;
            mem_count <= 0;
            i         <= 0;
            j         <= 0;
            k         <= 0;
            done      <= 0;
            O_count   <= 0;
            temp_2[0] <= 0;
            temp_2[1] <= 0;
            temp_2[2] <= 0;
            temp_2[3] <= 0;
            temp_2[4] <= 0;
            temp_2[5] <= 0;
            temp_2[6] <= 0;
            temp_2[7] <= 0;
        end else begin
            case(state)
                0: begin
                    if (en) begin //input data
                        Q_mem[mem_count] <= MATRIX_Q;
                        V_mem[mem_count] <= MATRIX_V;
                        K_mem[mem_count] <= MATRIX_K;
                        if (mem_count == 63) begin
                            state     <= 1;
                            mem_count <= 0;
                        end else begin
                            mem_count <= mem_count + 1;
                            state     <= 0;
                        end
                    end else begin
                        state <= 0;
                    end
                end
                1: begin
                    A_input[0] <= Q_mem[0 + i];B_input[0] <= K_mem[0 + j];
                    A_input[1] <= Q_mem[1 + i];B_input[1] <= K_mem[1 + j];
                    A_input[2] <= Q_mem[2 + i];B_input[2] <= K_mem[2 + j];
                    A_input[3] <= Q_mem[3 + i];B_input[3] <= K_mem[3 + j];
                    A_input[4] <= Q_mem[4 + i];B_input[4] <= K_mem[4 + j];
                    A_input[5] <= Q_mem[5 + i];B_input[5] <= K_mem[5 + j];
                    A_input[6] <= Q_mem[6 + i];B_input[6] <= K_mem[6 + j];
                    A_input[7] <= Q_mem[7 + i];B_input[7] <= K_mem[7 + j];
                    A_input[8] <= Q_mem[0 + i];B_input[8] <= K_mem[8 + j];
                    A_input[9] <= Q_mem[1 + i];B_input[9] <= K_mem[9 + j];
                    A_input[10] <= Q_mem[2 + i];B_input[10] <= K_mem[10 + j];
                    A_input[11] <= Q_mem[3 + i];B_input[11] <= K_mem[11 + j];
                    A_input[12] <= Q_mem[4 + i];B_input[12] <= K_mem[12 + j];
                    A_input[13] <= Q_mem[5 + i];B_input[13] <= K_mem[13 + j];
                    A_input[14] <= Q_mem[6 + i];B_input[14] <= K_mem[14 + j];
                    A_input[15] <= Q_mem[7 + i];B_input[15] <= K_mem[15 + j];
                    state <= 2;
                end
                2: begin
                    W_mem[mem_count]   <= temp[0] + temp[1] + temp[2] + temp[3] + temp[4] + temp[5] + temp[6] + temp[7];
                    W_mem[mem_count+1] <= temp[8] + temp[9] + temp[10] + temp[11] + temp[12] + temp[13] + temp[14] + temp[15];
                    state <= 3;
                end
                3: begin
                    C_input[0] <= W_mem[mem_count];D_input[0] <= V_mem[0 + k];
                    C_input[1] <= W_mem[mem_count];D_input[1] <= V_mem[1 + k];
                    C_input[2] <= W_mem[mem_count];D_input[2] <= V_mem[2 + k];
                    C_input[3] <= W_mem[mem_count];D_input[3] <= V_mem[3 + k];
                    C_input[4] <= W_mem[mem_count];D_input[4] <= V_mem[4 + k];
                    C_input[5] <= W_mem[mem_count];D_input[5] <= V_mem[5 + k];
                    C_input[6] <= W_mem[mem_count];D_input[6] <= V_mem[6 + k];
                    C_input[7] <= W_mem[mem_count];D_input[7] <= V_mem[7 + k];
                    state <= 4;
                end
                4: begin
                    temp_2[0] <= temp_1[0] + temp_2[0];
                    temp_2[1] <= temp_1[1] + temp_2[1];
                    temp_2[2] <= temp_1[2] + temp_2[2];
                    temp_2[3] <= temp_1[3] + temp_2[3];
                    temp_2[4] <= temp_1[4] + temp_2[4];
                    temp_2[5] <= temp_1[5] + temp_2[5];
                    temp_2[6] <= temp_1[6] + temp_2[6];
                    temp_2[7] <= temp_1[7] + temp_2[7];
                    if (k==8 || k==24 || k==40 || k==56) begin
                        state <= 5;
                    end else begin
                        mem_count <= mem_count + 1;
                        k         <= k + 8;
                        state     <= 3;
                    end
                end
                5: begin
                    if (j==48) begin
                        O_mem[0+i] <= temp_2[0];
                        O_mem[1+i] <= temp_2[1];
                        O_mem[2+i] <= temp_2[2];
                        O_mem[3+i] <= temp_2[3];
                        O_mem[4+i] <= temp_2[4];
                        O_mem[5+i] <= temp_2[5];
                        O_mem[6+i] <= temp_2[6];
                        O_mem[7+i] <= temp_2[7];
                        if (i==56) begin
                            state <= 6;
                            k     <= 0;
                        end else begin
                            i <= i + 8;
                            j <= 0;
                            k <= 0;
                            temp_2[0] <= 0;
                            temp_2[1] <= 0;
                            temp_2[2] <= 0;
                            temp_2[3] <= 0;
                            temp_2[4] <= 0;
                            temp_2[5] <= 0;
                            temp_2[6] <= 0;
                            temp_2[7] <= 0;
                            mem_count <= mem_count + 1;
                            state <= 1;
                        end
                    end else begin
                        j         <= j + 16;
                        k         <= k + 8;
                        mem_count <= mem_count + 1;
                        state     <= 1;
                    end
                end
                6: begin
                    if (O_count == 64) begin
                        state <= 0;
                    end else begin
                        done   <= 1;
                        answer <= O_mem[O_count];
                        state  <= 6;
                        O_count<= O_count + 1;
                    end
                end
            endcase
        end
    end

endmodule
