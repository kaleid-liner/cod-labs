`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/28 15:38:09
// Design Name: 
// Module Name: div
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

module div(
    input [3:0] x,
    input [3:0] y,
    input rst,
    input clk,
    output [3:0] q,
    output [3:0] r,
    output done,
    output error
    );

    localparam SSub = 0,
               SShl = 1,
               SDone = 2;
    
    reg [8:0] remainder;
    reg [3:0] divisor;
    reg [2:0] cnt;
    reg [1:0] state, next_state;
    reg lsb;
    
    assign error = !y;
    assign done = (state == SDone);

    assign q = remainder[3:0];
    assign r = remainder[8:5];

    always @(state or cnt or rst) begin
        case (state) 
            SSub: next_state = SShl;
            SShl: begin
                if (cnt)
                    next_state = SSub;
                else    
                    next_state = SDone;
            end
            default:
                next_state = SDone;
        endcase
    end

    always @(posedge clk) begin
        if (rst) begin
            remainder <= {4'd0, x};
            divisor <= y;
            cnt <= 5;
        end
        else begin
            case (state)
                SSub: begin
                    cnt <= cnt - 1;
                    if (remainder[7:4] >= divisor) begin
                        lsb <= 1;
                        remainder[7:4] <= remainder[7:4] - divisor;
                    end else 
                        lsb <= 0;
                end
                SShl: begin
                    remainder <= (remainder << 1) | {8'd0, lsb};
                end
                default: ;
            endcase
        end
    end
    
    always @(posedge clk)
        if (rst) state <= SSub;
        else state <= next_state;
    
endmodule
