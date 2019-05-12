`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/12 15:39:08
// Design Name: 
// Module Name: ddu
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
`include "define.vh"

module ddu(
    input cont,
    input step,
    input mem,
    input inc,
    input dec,
    input [`BITS-1:0] data,
    input [`ADDR_BITS-1:0] pc,
    input clk_50mhz,
    output run,
    output [`ADDR_BITS-1:0] addr,
    output [15:0] led,
    output [7:0] an,
    output [6:0] seg,
    output dp
    );
    
    seg_displayer disp (
        .x(data),
        .clk_50mhz(clk_50mhz),
        .an(an),
        .dp(dp),
        .seg(seg)
    );
    
endmodule
