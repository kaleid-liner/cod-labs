`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/18 15:57:32
// Design Name: 
// Module Name: top
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


module top(
    input clk_100mhz,
    input [11:0] rgb,
    input [3:0] dir,
    input draw,
    input rst,
    output [11:0] vrgb,
    output hs,
    output vs
    );
    
    wire [15:0] vaddr;
    wire [11:0] vdata;
    
    wire [7:0] x, y;
    
    wire we;
    wire [15:0] paddr;
    wire [11:0] pdata;
    
    wire clk_50mhz;
    clk_wiz_0 _clk_wiz_0 (
        .clk_in1(clk_100mhz),
        .clk_out1(clk_50mhz)
    );
    
    vga DCU (
        .clk_50mhz(clk_50mhz),
        .vdata(vdata),
        .x(x),
        .y(y),
        .hs(hs),
        .vs(vs),
        .vrgb(vrgb),
        .vaddr(vaddr)
    );
    
    dist_mem_gen_0 VRAM (
        .dpra(vaddr),
        .dpo(vdata),
        .clk(clk_50mhz),
        .a(paddr),
        .d(pdata),
        .we(we)
    );
    
    drawpad PCU (
        .rgb(rgb),
        .dir(dir),
        .draw(draw),
        .x(x),
        .y(y),
        .clk_50mhz(clk_50mhz),
        .rst(rst),
        .paddr(paddr),
        .pdata(pdata),
        .we(we)
    );
    
endmodule
