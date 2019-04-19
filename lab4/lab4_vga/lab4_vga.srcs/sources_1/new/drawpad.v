`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/18 16:11:50
// Design Name: 
// Module Name: drawpad
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


module drawpad(
    input [11:0] rgb,
    input [3:0] dir,
    input draw,
    input clk_50mhz,
    input rst,
    output reg [15:0] paddr,
    output reg [11:0] pdata,
    output reg we,
    output reg [7:0] x,
    output reg [7:0] y
    );
    
    wire left, right, down, up;
    
    always @ (posedge clk_50mhz) begin
        if (rst) begin
            we <= 1;
            paddr <= paddr + 1;
            pdata <= 12'hFFF;
            x <= 127;
            y <= 127;
        end else begin
            we <= draw;
            paddr <= x + y * 256;
            pdata <= rgb;
            x <= x + right - left;
            y <= y + down - up;
        end
    end

    debouncer btn_dwn (
        .clk_50mhz(clk_50mhz),
        .button(dir[3]),
        .btn_down(down)
    );
    
    debouncer btn_up (
        .clk_50mhz(clk_50mhz),
        .button(dir[0]),
        .btn_down(up)
    );
    
    debouncer btn_rgt (
        .clk_50mhz(clk_50mhz),
        .button(dir[2]),
        .btn_down(right)
    );
    
    debouncer btn_lft (
        .clk_50mhz(clk_50mhz),
        .button(dir[1]),
        .btn_down(left)
    );
        
    
endmodule
