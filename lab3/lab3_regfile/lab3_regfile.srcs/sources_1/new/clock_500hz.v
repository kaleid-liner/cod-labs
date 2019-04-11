`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/16 14:04:14
// Design Name: 
// Module Name: clock_500hz
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


module clock_500hz(
    input clk,
    output reg Q
    );
    reg [15:0]cnt;
    initial 
    begin
        Q<=0;
        cnt=16'd0; 
    end
    always @ (posedge clk)
    begin
        if (cnt>=16'd4999)
        begin
            Q<=~Q;
            cnt<=16'd0;
        end
        else 
            cnt=cnt+16'd1;
    end
endmodule
