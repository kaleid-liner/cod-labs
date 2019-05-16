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
    input clk_50mhz,
    output reg clk_500hz
    );
    
    reg [16:0] cnt;
    
    always @ (posedge clk_50mhz) begin
        if (cnt>=17'd9999) begin
            clk_500hz <= ~clk_500hz;
            cnt <= 0;
        end else
            cnt <= cnt + 1;
    end
    
endmodule
