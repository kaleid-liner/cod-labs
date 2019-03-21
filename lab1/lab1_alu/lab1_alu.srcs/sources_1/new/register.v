`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/20 22:50:25
// Design Name: 
// Module Name: register
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


module register(
    input [BITS-1:0] in,
    input en,
    input rst,
    input clk,
    output reg [BITS-1:0] out
    );

    parameter BITS = 32;

    always @ (posedge clk) begin
        if (rst)
            out <= 0;
        else if (en) 
            out <= in;
    end

endmodule
