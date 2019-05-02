`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/02 19:45:46
// Design Name: 
// Module Name: clock_25mhz
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


module clock_25mhz(
    input clk_50mhz,
    output clk_25mhz
    );
    
    reg [1:0] cnt;
    
    assign clk_25mhz = cnt[0];
    
    always @(posedge clk_50mhz) begin
        cnt <= cnt + 1;
    end
    
endmodule
