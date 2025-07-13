`timescale 1ns/1ps

module FP_MUL(
    input        CLK,
    input        RESET,
    input        ENABLE,
    input  [7:0] DATA_IN,

    output reg [7:0] DATA_OUT,
    output reg       READY

);

    reg [4:0]   state;
    reg [63:0]  A;
    reg [63:0]  B;
    reg [63:0]  Z;
    reg [6:0]   count;
    reg [52:0]  m_a;
    reg [52:0]  m_b;
    reg [105:0] m_z;

    reg         G, R, S, LSB;

    always@(posedge CLK) begin
        if (RESET) begin
            A     <= 0;
            B     <= 0;
            Z     <= 0;
            G     <= 0;
            R     <= 0;
            S     <= 0;
            LSB   <= 0;
            state <= 0;
            count <= 0;
            m_a   <= 0;
            m_b   <= 0;
            m_z   <= 0;
        end else begin
            case (state)
                0: begin
                    if (ENABLE) begin
                        A <= A | (DATA_IN << (8*count));
                        if (count == 7) begin
                            state <= 1;
                            count <= 0;
                        end else begin
                            state <= 0;
                            count <= count + 1;
                        end
                    end
                end
                1: begin
                    if (ENABLE) begin
                        B <= B | (DATA_IN << (8*count));
                        if (count == 7) begin
                            state <= 2;
                            count <= 0;
                        end else begin
                            state <= 1;
                            count <= count + 1;
                        end
                    end
                end
                2: begin
                    if ((A[62:52] == 11'b11111111111 && A[51:0] != 0) ||
                        (B[62:52] == 11'b11111111111 && B[51:0] != 0)) begin
                        Z <= 64'h7FF8000000000000; // NAN
                        state <= 8;
                    end else if ((A[62:52] == 11'b11111111111 && A[51:0] == 0) ||
                                 (B[62:52] == 11'b11111111111 && B[51:0] == 0)) begin
                        Z <= 64'h7FF0000000000000; // +Inf
                        state <= 8;
                    end else if (A[62:0] == 0 || B[62:0] == 0) begin
                        Z <= {A[63]^B[63],63'b0};
                        state <= 8;
                    end else if ((A[62:52] == 11'b11111111111 && A[51:0] == 0) ||
                                 (B[62:52] == 11'b11111111111 && B[51:0] == 0)) begin
                        Z <= {A[63]^B[63],11'b11111111111,52'b0};
                        state <= 8;
                    end else begin
                        state <= 3;
                    end
                end
                3: begin
                    Z[63]      <= A[63]^B[63];
                    Z[62:52]   <= A[62:52] + B[62:52] - 11'd023;
                    m_a        <= {1'b1, A[51:0]};
                    m_b        <= {1'b1, B[51:0]};
                    state      <= 4;
                end
                4: begin
                    if (count == 53) begin
                        state <= 5;
                    end else begin
                        if (m_b[0] == 1) begin
                            m_z   <= m_z + (m_a << count);
                            m_b   <= m_b >> 1;
                            count <= count + 1;
                            state <= 4;
                        end else begin
                            m_b   <= m_b >> 1;
                            count <= count + 1;
                            state <= 4;
                        end
                    end
                end
                5: begin
                    if (m_z[105] == 1) begin
                        G    <= m_z[52];
                        R    <= m_z[51];
                        S    <= |m_z[50:0];
                        LSB  <= m_z[53];
                        m_z  <= m_z >> 1;
                        Z[62:52] <= Z[62:52] + 11'd1;
                        state <= 6;
                        count <= 1;
                    end else begin
                        G    <= m_z[51];
                        R    <= m_z[50];
                        S    <= |m_z[49:0];
                        LSB  <= m_z[53];
                        state <= 6;
                        count <= 0;
                    end
                end
                6: begin
                    Z[51:0] <= m_z[103:52];
                    state   <= 7;
                    count   <= 0;
                end
                7: begin
                    if (G == 1 && (R == 1 || S == 1)) begin
                        Z[51:0] <= Z[51:0] + 52'd1;
                        state   <= 8;
                    end else if (G == 1 && (R == 0 && S == 0 && LSB == 1)) begin
                        Z[51:0] <= Z[51:0] + 52'd1;
                        state   <= 8;
                    end else begin
                        state   <= 8;
                    end
                end
                8: begin
                    READY <= 1;
                    case (count)
                        0: DATA_OUT <= Z[7:0];
                        1: DATA_OUT <= Z[15:8];
                        2: DATA_OUT <= Z[23:16];
                        3: DATA_OUT <= Z[31:24];
                        4: DATA_OUT <= Z[39:32];
                        5: DATA_OUT <= Z[47:40];
                        6: DATA_OUT <= Z[55:48];
                        7: DATA_OUT <= Z[63:56];
                    endcase
                    if (count > 7) begin
                        READY <= 0;
                        state <= 0;
                        count <= 0;
                        A <= 0;
                        B <= 0;
                        Z <= 0;
                        m_a <= 0;
                        m_b <= 0;
                        m_z <= 0;
                        G <= 0;
                        R <= 0;
                        S <= 0;
                        LSB <= 0;
                    end else begin
                        state <= 8;
                        count <= count + 1;
                    end
                end
            endcase
        end
    end

endmodule
