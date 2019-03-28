`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/24 16:30:14
// Design Name: 
// Module Name: sort
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sort(
    input [3:0] x0,
    input [3:0] x1,
    input [3:0] x2,
    input [3:0] x3,
    input rst,
    input clk,
    output reg [3:0] s0,
    output reg [3:0] s1,
    output reg [3:0] s2,
    output reg [3:0] s3,
    output done
    );
    
    localparam CMP01   = 4'd0,
               CMP12   = 4'd1,
               CMP23   = 4'd2,
               CMP01_2 = 4'd3,
               CMP12_2 = 4'd4,
               CMP01_3 = 4'd5,
               DONE    = 4'd6;
    
    reg [2:0] state;
    
    always @ (posedge clk) begin
        if (rst) begin
            state <= CMP01;
            s0 <= x0;
            s1 <= x1;
            s2 <= x2;
            s3 <= x3;
        end
        else begin
            case (state)
                CMP01: begin
                    state <= CMP12;
                    if (s0 < s1) begin
                        s0 <= s1;
                        s1 <= s0;
                    end
                end
                CMP12: begin
                    state <= CMP23;
                    if (s1 < s2) begin
                        s1 <= s2;
                        s2 <= s1;
                    end
                end
                CMP23: begin
                    state <= CMP01_2;
                    if (s2 < s3) begin
                        s2 <= s3;
                        s3 <= s2;
                    end
                end
                CMP01_2: begin
                    state <= CMP12_2;
                    if (s0 < s1) begin
                        s0 <= s1;
                        s1 <= s0;
                    end
                end
                CMP12_2: begin
                    state <= CMP01_3;
                    if (s1 < s2) begin
                        s1 <= s2;
                        s2 <= s1;
                    end
                end
                CMP01_3: begin
                    state <= DONE;
                    if (s0 < s1) begin
                        s0 <= s1;
                        s1 <= s0;
                    end
                end
                default: ;
            endcase
        end
    end

    assign done = (state == DONE);

    
endmodule
