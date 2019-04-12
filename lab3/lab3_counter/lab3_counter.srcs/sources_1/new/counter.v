`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/12 00:19:44
// Design Name: 
// Module Name: counter
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


module counter(
    input [BITS-1:0] din,
    input pe,
    input ce,
    input rst,
    input clk,
    output reg [BITS-1:0] q
    );
    
    parameter BITS = 4;
    
    always @ (posedge clk or rst) begin
        if (rst) begin
            q <= 0;
        end else if (pe) begin
            q <= din;
        end else if (ce) begin
            q <= q + 1;
        end
    end
endmodule
